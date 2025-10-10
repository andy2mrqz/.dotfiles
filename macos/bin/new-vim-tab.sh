#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title new vim tab (ghostty)
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon ♈
#
# Documentation:
# @raycast.author Andrew Marquez

osascript <<EOF
tell application "Ghostty" to activate

tell application "System Events"
  -- Always open a new tab, even if no window exists
  keystroke "t" using command down
  delay 0.1 -- required to avoid race condition

  -- Start vim
  keystroke "vim"
  keystroke return
end tell
EOF
