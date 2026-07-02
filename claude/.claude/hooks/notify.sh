#!/bin/bash
# Claude Code Stop hook: desktop notification with click-to-focus for Ghostty.
#
# Uses terminal-notifier (`brew install terminal-notifier`) for the
# click-to-run callback, and Ghostty's native AppleScript dictionary
# (Ghostty 1.3+) to jump straight to the originating tty on click --
# no window/tab tree-walking needed, Ghostty exposes `tty` on terminals
# directly.
#
# Usage (Claude Code Stop hook): echo '<payload json>' | notify.sh
# Click callback (terminal-notifier -execute): notify.sh --focus /dev/ttysNNN
set -euo pipefail

# Hooks may run with a minimal PATH that excludes Homebrew.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

osa() { timeout 5 osascript "$@"; }

# --- click callback -------------------------------------------------
if [ "${1:-}" = "--focus" ]; then
  TTY="${2:-}"
  if [ -n "$TTY" ]; then
    osa <<EOF
tell application "Ghostty"
  set matches to every terminal whose tty is "$TTY"
  if (count of matches) > 0 then focus (item 1 of matches)
end tell
EOF
  fi
  exit 0
fi

# --- normal invocation: read the hook payload from stdin ------------
PAYLOAD=$(cat)
CWD=$(jq -r '.cwd // empty' <<< "$PAYLOAD")
TRANSCRIPT=$(jq -r '.transcript_path // empty' <<< "$PAYLOAD")
EVENT=$(jq -r '.hook_event_name // empty' <<< "$PAYLOAD")
TOOL_NAME=$(jq -r '.tool_name // empty' <<< "$PAYLOAD")
PROJECT=$(basename "${CWD:-Claude Code}")

# Controlling tty of this hook, i.e. the Ghostty pty Claude Code is running in.
get_tty() {
  local pid=$$ t
  while [ -n "$pid" ] && [ "$pid" -gt 1 ] 2>/dev/null; do
    t=$(ps -p "$pid" -o tty= 2>/dev/null | tr -d ' ' || true)
    if [ -n "$t" ] && [ "$t" != "??" ]; then
      echo "/dev/$t"
      return
    fi
    pid=$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ' || true)
  done
}
TTY=$(get_tty)

# Skip the notification if Ghostty is frontmost and already showing this tab.
user_is_watching() {
  [ -z "$TTY" ] && return 1
  local front
  front=$(osa -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo "")
  front=$(tr '[:upper:]' '[:lower:]' <<< "$front")
  [ "$front" != "ghostty" ] && return 1
  local cur
  cur=$(osa -e 'tell application "Ghostty" to return tty of (focused terminal of (selected tab of front window))' 2>/dev/null || echo "")
  [ "$cur" = "$TTY" ]
}
user_is_watching && exit 0

# Subject: Ghostty's own tab title, which Claude Code sets to a running
# summary of the conversation. Falls back to the project directory name.
SUBJECT=""
if [ -n "$TTY" ]; then
  SUBJECT=$(osa -e "tell application \"Ghostty\" to return name of (item 1 of (every terminal whose tty is \"$TTY\"))" 2>/dev/null || true)
  SUBJECT=$(sed -E 's/^[^a-zA-Z0-9]+[[:space:]]*//' <<< "$SUBJECT")
fi
[ -z "$SUBJECT" ] && SUBJECT="$PROJECT"

# Message: for events where Claude is blocked waiting on the user, build a
# preview from the payload itself (the last assistant turn is stale/unrelated
# in those cases). For a plain Stop (or unrecognized event), fall back to the
# previous behavior of previewing the last assistant turn's text.
PREVIEW=""
case "$EVENT" in
  PreToolUse)
    if [ "$TOOL_NAME" = "AskUserQuestion" ]; then
      PREVIEW=$(jq -r '.tool_input.questions[0].question // empty' <<< "$PAYLOAD")
      [ -n "$PREVIEW" ] && PREVIEW="Question: $PREVIEW"
    fi
    ;;
  PermissionRequest)
    [ -n "$TOOL_NAME" ] && PREVIEW="Needs permission to use $TOOL_NAME"
    ;;
  Elicitation)
    PREVIEW=$(jq -r '.message // .prompt // empty' <<< "$PAYLOAD")
    [ -n "$PREVIEW" ] && PREVIEW="MCP input needed: $PREVIEW"
    ;;
  StopFailure)
    PREVIEW=$(jq -r '.error_type // .error.type // .error // empty' <<< "$PAYLOAD")
    if [ -n "$PREVIEW" ]; then
      PREVIEW="Turn failed: $PREVIEW"
    else
      PREVIEW="Turn ended due to an error"
    fi
    ;;
esac
PREVIEW="${PREVIEW:0:100}"

if [ -z "$PREVIEW" ] && { [ -z "$EVENT" ] || [ "$EVENT" = "Stop" ]; }; then
  if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    LAST_ASSISTANT_LINE=$(tail -r "$TRANSCRIPT" 2>/dev/null | rg -m 1 '"type":"assistant"' || true)
    if [ -n "$LAST_ASSISTANT_LINE" ]; then
      PREVIEW=$(jq -r '(.message.content | if type == "array" then (map(select(.type == "text") | .text) | first) else . end) // ""' \
        <<< "$LAST_ASSISTANT_LINE" 2>/dev/null | tr -s '[:space:]' ' ' | sed -E 's/^ +//;s/ +$//')
      PREVIEW="${PREVIEW:0:100}"
    fi
  fi
fi

if [ -z "$PREVIEW" ]; then
  if [ -n "$EVENT" ] && [ "$EVENT" != "Stop" ]; then
    PREVIEW="Claude needs your attention ($EVENT)"
  else
    PREVIEW="Ready for input"
  fi
fi

HOOK_PATH="$HOME/.claude/hooks/notify.sh"
ARGS=(-title "Claude Code" -subtitle "$SUBJECT" -message "$PREVIEW" -sound default -group "claude-${TTY:-$PROJECT}")
if [ -n "$TTY" ]; then
  ARGS+=(-execute "$(printf '%q --focus %q' "$HOOK_PATH" "$TTY")")
fi

terminal-notifier "${ARGS[@]}" >/dev/null 2>&1 || true
