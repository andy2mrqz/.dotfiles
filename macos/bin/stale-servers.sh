#!/usr/bin/env bash
#
# stale-servers.sh — find long-running, *detached* dev servers that look abandoned.
#
# These are NOT zombies (see zombies.sh for those). A stale server is a fully
# alive process — a dev server / watcher (yarn dev, node server.js, vite, next
# dev, nodemon, uvicorn, …) that:
#   • matches a known dev-tool command pattern (things meant to be short-lived,
#     run in a terminal you're watching), AND
#   • is detached: reparented to launchd (PPID 1) or has no controlling TTY
#     (its launching terminal is gone), AND
#   • has been running longer than a threshold (default: 1 day).
#
# The classic culprit: you `yarn dev`, close the terminal, and the node process
# gets adopted by launchd and quietly runs for weeks — not serving anything,
# but holding open DB/Redis connections to staging.
#
# IMPORTANT: this is a HEURISTIC. Every signal here has false positives on its
# own (PPID 1 describes most OS daemons; "old" describes most of them too). The
# discriminator is the command pattern — so treat the output as *candidates for
# review*, never as "definitely dead." Read-only by default; --kill is opt-in
# and confirms before signaling.
#
# Usage:
#   stale-servers.sh                  # report candidates (read-only)
#   stale-servers.sh --older-than 7d  # only those older than 7 days (also: 12h, 30m)
#   stale-servers.sh --all-users      # don't restrict to the current user
#   stale-servers.sh --kill           # report, then prompt to reap them
#   stale-servers.sh --kill --yes     # reap without prompting (careful)
#
set -uo pipefail

# ---- options ---------------------------------------------------------------
MIN_MINUTES=1440      # default: 1 day
DO_KILL=0
ASSUME_YES=0
ALL_USERS=0

parse_duration() { # "7d" | "12h" | "30m" | "90" (minutes) -> minutes
  local v="$1" n unit
  n="${v%[dhms]}"; unit="${v#"$n"}"
  case "$unit" in
    d) echo $(( n * 1440 )) ;;
    h) echo $(( n * 60 )) ;;
    m|"") echo $(( n )) ;;
    s) echo $(( n / 60 )) ;;
    *) echo "$n" ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --older-than) MIN_MINUTES="$(parse_duration "${2:-1d}")"; shift 2 ;;
    --kill)       DO_KILL=1; shift ;;
    --yes|-y)     ASSUME_YES=1; shift ;;
    --all-users)  ALL_USERS=1; shift ;;
    -h|--help)    sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

# ---- colors (only if stdout is a terminal) ---------------------------------
if [[ -t 1 ]]; then
  BOLD=$'\033[1m'; RED=$'\033[31m'; GRN=$'\033[32m'; YLW=$'\033[33m'
  CYN=$'\033[36m'; DIM=$'\033[2m'; RST=$'\033[0m'
else
  BOLD=''; RED=''; GRN=''; YLW=''; CYN=''; DIM=''; RST=''
fi
hr() { printf '%s\n' "------------------------------------------------------------"; }

# ---- dev-server command patterns (the actual discriminator) ----------------
# Matched case-insensitively against each process's full argv.
DEV_PATTERN='(yarn (dev|start|serve)|(npm|pnpm)( run)? (dev|start|serve)|bun (dev|run)|nodemon|ts-node-dev|node([^ ]*)? [^ ]*server\.(js|ts)|next (dev|start)|next-server|vite( |$)|webpack(-dev-server| serve)|react-scripts start|ng serve|storybook|astro dev|(nuxt|remix)([ -])dev|rails server|\bpuma\b|rackup|flask run|uvicorn|gunicorn|php artisan serve|\bair\b|cargo (run|watch)|deno (run|task)|mix phx\.server|turbo run (dev|start))'

is_dev() { printf '%s' "$1" | grep -Eiq "$DEV_PATTERN"; }

ME="$(whoami)"

echo "${BOLD}Stale Dev-Server Report${RST}  ${DIM}$(date '+%Y-%m-%d %H:%M:%S')  $(hostname -s)${RST}"
echo "${DIM}criteria: dev-tool command + detached (PPID 1 or no TTY) + age ≥ $(( MIN_MINUTES/1440 ))d$(( (MIN_MINUTES%1440)/60 ))h${RST}"
hr

# ---- scan ------------------------------------------------------------------
candidates=()  # "pid|days|hours|user|cwd|listen|estab|args"

while read -r pid ppid _stat etime tty user args; do
  [[ -z "${pid:-}" || "$pid" == "PID" ]] && continue
  [[ "$ALL_USERS" -eq 0 && "$user" != "$ME" ]] && continue

  # age in minutes from etime (DD-HH:MM:SS | HH:MM:SS | MM:SS)
  local_days=0; rest="$etime"
  if [[ "$etime" == *-* ]]; then local_days="${etime%%-*}"; rest="${etime#*-}"; fi
  IFS=':' read -r a b c <<<"$rest"
  if [[ -n "${c:-}" ]]; then hh="$a"; mm="$b"; else hh=0; mm="$a"; fi
  total_min=$(( 10#${local_days:-0}*1440 + 10#${hh:-0}*60 + 10#${mm:-0} ))
  (( total_min < MIN_MINUTES )) && continue

  # detached?  PPID 1 (reparented to launchd) or no controlling terminal
  detached=0
  [[ "$ppid" == "1" ]] && detached=1
  [[ "$tty" == "??" || "$tty" == "-" ]] && detached=1
  (( detached == 0 )) && continue

  # skip shell command-wrappers (e.g. `zsh -c '... vite ...'`): we want the leaf
  # dev process, not a shell whose argv merely embeds the command string.
  [[ "$args" =~ ^([^[:space:]]*/)?(sh|bash|zsh|dash|fish|ksh)[[:space:]]+-c([[:space:]]|$) ]] && continue

  # the discriminator: does it look like a dev server / watcher?
  is_dev "$args" || continue

  # enrich (only for the handful of candidates — lsof is slow)
  cwd="$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p' | head -1)"
  listen="$(lsof -nP -p "$pid" -a -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1{print $9}' | paste -sd, - )"
  estab="$(lsof -nP -p "$pid" -a -iTCP -sTCP:ESTABLISHED 2>/dev/null | grep -c . )"
  (( estab > 0 )) && estab=$(( estab - 0 ))  # header already excluded by -sTCP filter? keep raw count

  candidates+=( "$pid|$(( total_min/1440 ))|$(( (total_min%1440)/60 ))|$user|${cwd:-?}|${listen:-}|${estab:-0}|$args" )
done < <(ps -axo pid=,ppid=,stat=,etime=,tty=,user=,args=)

if (( ${#candidates[@]} == 0 )); then
  echo "${GRN}✓ No stale dev servers found.${RST}"
  echo "${DIM}  (No detached, long-running dev-tool processes matched.)${RST}"
  echo
  echo "${DIM}Looking for defunct (zombie) processes instead?  →  zombies.sh${RST}"
  exit 0
fi

echo "${YLW}${BOLD}⚠ ${#candidates[@]} candidate(s) for review:${RST}"
echo
kill_pids=()
for c in "${candidates[@]}"; do
  IFS='|' read -r pid d h user cwd listen estab args <<<"$c"
  kill_pids+=( "$pid" )
  echo "${CYN}${BOLD}• pid ${pid}${RST}  ${DIM}(${user}, up ${d}d${h}h)${RST}"
  echo "    cmd:    ${args}"
  echo "    cwd:    ${cwd}"
  if [[ -n "$listen" ]]; then
    echo "    serving: ${listen}   ${DIM}(actually listening — make sure you don't need it!)${RST}"
  else
    echo "    serving: ${RED}nothing${RST}   ${DIM}(no LISTEN socket — not serving anyone)${RST}"
  fi
  echo "    conns:  ${estab} established   ${DIM}(open DB/Redis/etc. connections it's holding)${RST}"
  echo
done

hr
echo "${DIM}Heuristic — verify before killing. A process that is still LISTENING may be one"
echo "you actually want. To reap a candidate and its direct children:${RST}"
echo "    ${BOLD}kill <pid>; pkill -P <pid>${RST}"
echo
echo "${DIM}Defunct (zombie) processes are a different problem  →  zombies.sh${RST}"

# ---- optional kill ---------------------------------------------------------
if (( DO_KILL )); then
  echo
  if (( ! ASSUME_YES )); then
    printf "${BOLD}Reap these %d process(es) and their direct children? [y/N] ${RST}" "${#kill_pids[@]}"
    read -r ans
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "Aborted; nothing killed."; exit 0; }
  fi
  for pid in "${kill_pids[@]}"; do
    pkill -P "$pid" 2>/dev/null
    kill "$pid" 2>/dev/null
    sleep 0.3
    kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null
    kill -0 "$pid" 2>/dev/null && echo "  ${RED}pid $pid: still alive${RST}" || echo "  ${GRN}pid $pid: reaped${RST}"
  done
fi
