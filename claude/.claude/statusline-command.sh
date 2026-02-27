#!/usr/bin/env bash
# Claude Code status line - mirrors the zsh PROMPT style
# Receives JSON via stdin with session/model/context data

input=$(cat)

# --- Extract fields from JSON ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# --- Colors (ANSI-C quoting so escapes are real ESC chars) ---
CYAN=$'\033[0;36m'
RED=$'\033[0;31m'
BLUE=$'\033[1;34m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
MAGENTA=$'\033[0;35m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

# --- Directory (basename, like %c in zsh prompt) ---
dir=$(basename "$cwd")

# --- Git info (branch + clean/dirty), skipping optional locks ---
git_info=""
if git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null); then
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
    git_status="${YELLOW}${BOLD}✗${RESET}"
  else
    git_status="${GREEN}${BOLD}✓${RESET}"
  fi
  git_info=" ${BLUE}${BOLD}git:(${RED}${git_branch}${BLUE})${RESET} ${git_status}"
fi

# --- Model ---
model_info=""
if [ -n "$model" ]; then
  model_info="${MAGENTA}${model}${RESET}"
fi

# --- Context window usage ---
context_info=""
if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  if [ "$used_int" -ge 80 ]; then
    ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi
  context_info=" ${ctx_color}ctx:${used_int}%${RESET}"
fi

# --- Vim mode indicator ---
vim_info=""
if [ -n "$vim_mode" ]; then
  if [ "$vim_mode" = "NORMAL" ]; then
    vim_info=" ${YELLOW}[N]${RESET}"
  else
    vim_info=" ${GREEN}[I]${RESET}"
  fi
fi

# --- Assemble and print ---
printf "${CYAN}${BOLD}%s${RESET}%s" "$dir" "$git_info"
if [ -n "$model_info" ] || [ -n "$context_info" ] || [ -n "$vim_info" ]; then
  printf "  ${BOLD}|${RESET}  %s%s%s" "$model_info" "$context_info" "$vim_info"
fi
printf "\n"
