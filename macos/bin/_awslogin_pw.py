# /// script
# requires-python = ">=3.12"
# dependencies = ["playwright"]
# ///
"""Headless AWS SSO login using Playwright for browser automation.

Outputs shell commands (exports, echo) to stdout for eval by the bash wrapper.
Status messages go to stderr so they're visible but don't pollute the eval.
"""

import glob
import os
import re
import subprocess
import sys
import threading
from pathlib import Path

PLAYWRIGHT_DIR = str(Path.home() / ".cache" / "awslogin-playwright")


def log(msg):
    print(msg, file=sys.stderr, flush=True)


def shell(cmd):
    print(cmd, flush=True)


def check_auth(profile):
    return subprocess.run(
        ["aws", "sts", "get-caller-identity", "--profile", profile],
        capture_output=True,
    ).returncode == 0


def export_env(profile):
    result = subprocess.run(
        ["aws", "configure", "export-credentials", "--profile", profile, "--format", "env"],
        capture_output=True, text=True,
    )
    if result.returncode == 0:
        shell(result.stdout.strip())
        log("AWS environment variables exported")
    else:
        shell('echo "Failed to export AWS environment variables" >&2; return 1')


def start_sso_login(profile):
    """Start aws sso login in the background, suppress the default browser, return (proc, url)."""
    env = os.environ.copy()
    env["BROWSER"] = "/usr/bin/true"

    proc = subprocess.Popen(
        ["aws", "sso", "login", "--profile", profile],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        text=True, env=env,
    )

    url = None
    found = threading.Event()

    def read_url():
        nonlocal url
        for line in iter(proc.stdout.readline, ""):
            m = re.search(r"(https://\S+)", line)
            if m:
                url = m.group(1)
                found.set()
                # Keep draining stdout so aws sso login doesn't block on pipe write
        found.set()  # EOF without finding a URL

    reader = threading.Thread(target=read_url, daemon=True)
    reader.start()
    found.wait(timeout=30)

    return proc, url


def automate_browser(url, headless=True):
    """Drive the SSO consent flow in Playwright. Returns 'done', 'need_auth', or 'timeout'."""
    from playwright.sync_api import sync_playwright

    os.makedirs(PLAYWRIGHT_DIR, mode=0o700, exist_ok=True)

    with sync_playwright() as p:
        ctx = p.chromium.launch_persistent_context(
            PLAYWRIGHT_DIR, headless=headless,
            args=["--disable-blink-features=AutomationControlled"],
        )
        try:
            page = ctx.pages[0] if ctx.pages else ctx.new_page()
            page.goto(url, wait_until="domcontentloaded")

            # Let initial redirects settle
            page.wait_for_timeout(3000)

            if "127.0.0.1" in page.url:
                return "done"

            # Headless but no Microsoft session — bail so we can retry headed
            if headless and "microsoftonline.com" in page.url:
                return "need_auth"

            # Wait for the "Allow access" button.
            # In headed mode this can take a while if the user is authenticating with Microsoft.
            timeout_ms = 120_000 if not headless else 30_000
            try:
                btn = page.get_by_role("button", name="Allow access")
                btn.wait_for(state="visible", timeout=timeout_ms)
                btn.click()
            except Exception:
                return "timeout"

            # Wait for the localhost redirect that completes the PKCE flow
            try:
                page.wait_for_url("**/127.0.0.1**", timeout=15_000)
            except Exception:
                pass

            # Give the callback request time to reach the aws sso login server
            page.wait_for_timeout(2000)
            return "done"
        finally:
            ctx.close()


def main():
    profile = None
    force = False
    for arg in sys.argv[1:]:
        if arg in ("-f", "--force"):
            force = True
        else:
            profile = arg

    if not profile:
        shell('echo "Usage: awslogin [-f|--force] <profile>" >&2; return 1')
        return

    if not force and check_auth(profile):
        log(f"Already authenticated with profile: {profile}")
        export_env(profile)
        return

    if force:
        for f in glob.glob(os.path.expanduser("~/.aws/sso/cache/*.json")):
            os.remove(f)

    log(f"Logging in with profile: {profile}")

    proc, url = start_sso_login(profile)
    if not url:
        shell('echo "Failed to capture SSO URL" >&2; return 1')
        if proc:
            proc.terminate()
        return

    # Try headless first; fall back to headed if Microsoft session is missing
    result = automate_browser(url, headless=True)

    if result == "need_auth":
        log("No cached Microsoft session — opening browser for one-time interactive login...")
        # Restart aws sso login since the auth URL may be consumed
        proc.terminate()
        proc.wait()
        proc, url = start_sso_login(profile)
        if not url:
            shell('echo "Failed to capture SSO URL on retry" >&2; return 1')
            return
        result = automate_browser(url, headless=False)

    if result != "done":
        proc.terminate()

    try:
        proc.wait(timeout=15)
    except subprocess.TimeoutExpired:
        log("aws sso login did not exit in time, killing")
        proc.kill()
        proc.wait()

    if proc.returncode != 0 or result != "done":
        shell('echo "SSO login failed" >&2; return 1')
        return

    export_env(profile)


if __name__ == "__main__":
    main()
