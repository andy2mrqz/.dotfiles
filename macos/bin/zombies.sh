#!/usr/bin/env bash
#
# zombies.sh — find zombie (defunct) processes and report what's responsible.
#
# A zombie process is a child that has exited but whose parent hasn't reaped it
# (hasn't called wait()). The zombie itself is harmless and uses no resources
# except a slot in the process table — the *parent* is the buggy actor. You
# can't kill a zombie; you fix it by signaling or restarting the parent.
#
# This script is read-only: it inspects process state and prints a report.
# It never sends signals or kills anything.
#
# Usage: zombies.sh
#
set -euo pipefail

# ---- colors (only if stdout is a terminal) ---------------------------------
if [[ -t 1 ]]; then
  BOLD=$'\033[1m'; RED=$'\033[31m'; GRN=$'\033[32m'; YLW=$'\033[33m'
  CYN=$'\033[36m'; DIM=$'\033[2m'; RST=$'\033[0m'
else
  BOLD=''; RED=''; GRN=''; YLW=''; CYN=''; DIM=''; RST=''
fi

hr() { printf '%s\n' "------------------------------------------------------------"; }

echo "${BOLD}Zombie Process Report${RST}  ${DIM}$(date '+%Y-%m-%d %H:%M:%S')  $(hostname -s)${RST}"
hr

# ---- system-wide process state summary -------------------------------------
# top's header line accounts for every process by state, including zombies.
summary="$(top -l 1 -n 0 2>/dev/null | grep -i '^Processes:' || true)"
[[ -n "$summary" ]] && echo "${DIM}${summary}${RST}" && echo

# ---- collect zombies -------------------------------------------------------
# STAT field contains 'Z' for zombies. Capture pid, ppid, user, and command.
# (comm gives the bare executable name even for <defunct> entries.)
zombies="$(ps -axo pid,ppid,stat,user,comm | awk 'NR>1 && $3 ~ /Z/')"

if [[ -z "$zombies" ]]; then
  echo "${GRN}✓ No zombie processes found.${RST}"
  echo "${DIM}  Nothing to act on — no parent is leaking un-reaped children.${RST}"
  echo
  echo "${DIM}Hunting abandoned-but-*alive* dev servers instead (yarn dev / node server.js"
  echo "left running for weeks, detached from a dead terminal)? Those aren't zombies"
  echo "(they're STAT=S and hold real connections)  →  stale-servers.sh${RST}"
  exit 0
fi

count="$(printf '%s\n' "$zombies" | grep -c .)"
echo "${RED}${BOLD}⚠ Found ${count} zombie process(es).${RST}"
echo
printf "${BOLD}%-8s %-8s %-6s %-12s %s${RST}\n" "PID" "PPID" "STAT" "USER" "COMMAND"
printf '%s\n' "$zombies" | awk '{printf "%-8s %-8s %-6s %-12s %s\n",$1,$2,$3,$4,$5}'
echo

# ---- group by parent: the parent is who needs action -----------------------
hr
echo "${BOLD}Responsible parent processes (act on these):${RST}"
echo

# unique ppids
ppids="$(printf '%s\n' "$zombies" | awk '{print $2}' | sort -u)"

for ppid in $ppids; do
  zcount="$(printf '%s\n' "$zombies" | awk -v p="$ppid" '$2==p' | grep -c .)"

  if [[ "$ppid" == "1" ]]; then
    echo "${YLW}• PPID 1 (launchd)${RST} is parenting ${zcount} zombie(s)."
    echo "  ${DIM}These are reparented orphans. launchd normally reaps these almost"
    echo "  instantly; lingering ones usually clear on their own or at next reboot.${RST}"
    echo
    continue
  fi

  # Parent details. May have already exited between the two ps calls.
  pinfo="$(ps -o pid,user,lstart,etime,comm,args -p "$ppid" 2>/dev/null | awk 'NR>1')"
  if [[ -z "$pinfo" ]]; then
    echo "${YLW}• PPID ${ppid}${RST} — parenting ${zcount} zombie(s), but parent is gone now."
    echo "  ${DIM}Likely already exited; its zombies will be reparented to launchd and reaped.${RST}"
    echo
    continue
  fi

  pcomm="$(ps -o comm= -p "$ppid" 2>/dev/null | sed 's/^ *//')"
  puser="$(ps -o user= -p "$ppid" 2>/dev/null | sed 's/^ *//')"
  pelapsed="$(ps -o etime= -p "$ppid" 2>/dev/null | sed 's/^ *//')"
  pargs="$(ps -o args= -p "$ppid" 2>/dev/null | sed 's/^ *//')"

  echo "${CYN}${BOLD}• ${pcomm}${RST}  ${DIM}(PID ${ppid}, user ${puser}, up ${pelapsed})${RST}"
  echo "  is leaking ${RED}${zcount}${RST} zombie(s):"
  printf '%s\n' "$zombies" | awk -v p="$ppid" '$2==p {printf "      └─ pid %-8s %s\n",$1,$5}'
  echo "  ${DIM}full cmd:${RST} ${pargs}"
  echo "  ${BOLD}Action:${RST} this parent isn't reaping its children. Options:"
  echo "    1. Nudge it to reap:   ${BOLD}kill -CHLD ${ppid}${RST}   ${DIM}(harmless SIGCHLD)${RST}"
  echo "    2. If that fails, restart the parent:  ${BOLD}kill ${ppid}${RST}  ${DIM}(or its service manager)${RST}"
  echo "    3. Zombies vanish once the parent reaps them or itself exits."
  echo
done

hr
echo "${DIM}Note: zombies consume no CPU/RAM — only a process-table slot. They are"
echo "only worth acting on if they accumulate (table exhaustion) or point to a"
echo "buggy parent. You cannot 'kill -9' a zombie directly; target the parent.${RST}"
echo
echo "${DIM}Related: abandoned-but-alive dev servers (detached, running for weeks, NOT"
echo "defunct) are a different problem  →  stale-servers.sh${RST}"
