---
name: agent-browser
description: Debug browser automation flows (auth, redirects, SPAs) using agent-browser CLI. Use when diagnosing Playwright scripts, SSO flows, or any browser-based issue where you need to see actual page state.
user-invocable: true
allowed-tools: Bash, Read, Glob, Grep
argument-hint: [url-or-description]
---

Use `agent-browser` (installed via brew) to visually inspect browser flows.

## Workflow

1. If a process generates the URL (e.g. `aws sso login`), start it with `BROWSER=/usr/bin/true` to suppress its browser, capture the URL from stdout
2. Open the URL: `agent-browser open <url>` (headless) or `agent-browser --headed open <url>` (if user needs to interact, e.g. enter credentials)
3. At each step: `agent-browser screenshot /tmp/step-N.png` and read it, `agent-browser snapshot -i` for interactive element refs, `agent-browser get url` for current URL
4. Interact via `agent-browser click @ref` / `agent-browser fill @ref "text"` or let user interact in headed mode
5. Repeat screenshot/snapshot after each transition until flow completes
6. `agent-browser close` when done

## Authenticated flows

Use `--session-name` to persist auth (cookies/storage) across runs:
1. First run (user authenticates): `agent-browser --headed --session-name <name> open <url>`
2. Subsequent runs reuse the session headlessly

State saved to `~/.agent-browser/sessions/`. See `agent-browser state --help` for manual save/load/cleanup.

Run `agent-browser --help` for full command reference.
