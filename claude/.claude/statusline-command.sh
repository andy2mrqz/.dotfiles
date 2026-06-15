#!/usr/bin/env bash
# Claude Code status line - mirrors the zsh PROMPT style
# Receives JSON via stdin with session/model/context data

INPUT=$(cat)

# --- Extract fields from JSON ---
CWD=$(echo "$INPUT" | jq -r '.cwd // .workspace.current_dir // ""')
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // ""')
USED_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // empty')
VIM_MODE=$(echo "$INPUT" | jq -r '.vim.mode // empty')
EFFORT=$(echo "$INPUT" | jq -r '.effort.level // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
SESSION_COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
API_DURATION_MS=$(echo "$INPUT" | jq -r '.cost.total_api_duration_ms // 0')
WALL_DURATION_MS=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')

# --- Colors (ANSI-C quoting so escapes are real ESC chars) ---
CYAN=$'\033[0;36m'
RED=$'\033[0;31m'
BLUE=$'\033[1;34m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
MAGENTA=$'\033[0;35m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

# --- Format a millisecond duration as a compact human string ---
# Shows the two largest non-zero units (w/d/h/m/s), e.g. 6d14h, 47m9s, 1.5s.
fmt_duration() {
  local MS=${1%%.*} # strip any decimal
  [ -z "$MS" ] && MS=0
  local S=$((MS / 1000))
  if [ "$S" -ge 604800 ]; then    # >= 1 week
    printf '%dw%dd' $((S / 604800)) $(((S % 604800) / 86400))
  elif [ "$S" -ge 86400 ]; then   # >= 1 day
    printf '%dd%dh' $((S / 86400)) $(((S % 86400) / 3600))
  elif [ "$S" -ge 3600 ]; then    # >= 1 hour
    printf '%dh%dm' $((S / 3600)) $(((S % 3600) / 60))
  elif [ "$S" -ge 60 ]; then      # >= 1 minute
    printf '%dm%ds' $((S / 60)) $((S % 60))
  elif [ "$MS" -ge 1000 ]; then   # >= 1 second
    printf '%d.%01ds' "$S" $(((MS % 1000) / 100))
  else
    printf '%dms' "$MS"
  fi
}

# --- Context window usage bar ---
CONTEXT_INFO=""
if [ -n "$USED_PCT" ]; then
  if [ "$USED_PCT" -ge 90 ]; then
    CTX_COLOR="$RED"
  elif [ "$USED_PCT" -ge 70 ]; then
    CTX_COLOR="$YELLOW"
  else
    CTX_COLOR="$GREEN"
  fi
  printf -v CONTEXT_INFO "${CTX_COLOR}ctx:%s%%${RESET}" "$USED_PCT"
fi

# --- Directory (full path, ~ for $HOME prefix) ---
TILDE='~'
DIR="${CWD/#$HOME/$TILDE}"

# --- Git info (branch + clean/dirty) ---
GIT_INFO=""
if GIT_BRANCH=$(git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null || git -C "$CWD" rev-parse --short HEAD 2>/dev/null); then
  if [ -n "$(git -C "$CWD" status --porcelain 2>/dev/null)" ]; then
    GIT_STATUS="${YELLOW}${BOLD}✗${RESET}"
  else
    GIT_STATUS="${GREEN}${BOLD}✓${RESET}"
  fi
  GIT_INFO=" ${BLUE}${BOLD}git:(${RED}${GIT_BRANCH}${BLUE})${RESET} ${GIT_STATUS}"
fi

# --- Model (+ effort level + context usage) ---
MODEL_INFO=""
if [ -n "$MODEL" ]; then
  MODEL_INFO="${MAGENTA}${MODEL}${RESET}"
  [ -n "$EFFORT" ] && MODEL_INFO="${MODEL_INFO} ${DIM}(${EFFORT})${RESET}"
  [ -n "$CONTEXT_INFO" ] && MODEL_INFO="${MODEL_INFO} ${CONTEXT_INFO}"
fi

# --- Vim mode indicator ---
VIM_INFO=""
if [ -n "$VIM_MODE" ]; then
  if [ "$VIM_MODE" = "NORMAL" ]; then
    VIM_INFO=" ${YELLOW}[N]${RESET}"
  else
    VIM_INFO=" ${GREEN}[I]${RESET}"
  fi
fi

# --- Session stats ---
printf -v COST_INFO '$%.2f' "$SESSION_COST"
API_INFO=$(fmt_duration "$API_DURATION_MS")
WALL_INFO=$(fmt_duration "$WALL_DURATION_MS")

# --- Assemble and print ---
# Line 1: directory + git | model (effort) ctx% + vim mode
printf "${CYAN}${BOLD}%s${RESET}%s  ${BOLD}|${RESET}  %s%s\n" "$DIR" "$GIT_INFO" "$MODEL_INFO" "$VIM_INFO"

# Line 2: cost | api time / wall time | session id
printf "${GREEN}%s${RESET}  ${DIM}|${RESET}  ${DIM}api${RESET} %s ${DIM}/${RESET} ${DIM}wall${RESET} %s  ${DIM}|${RESET}  ${DIM}session_id:${RESET} %s\n" \
  "$COST_INFO" "$API_INFO" "$WALL_INFO" "$SESSION_ID"
