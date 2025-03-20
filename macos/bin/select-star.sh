#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title SNOWFLAKE SELECT STAR
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ❄️

# Documentation:
# @raycast.author Andrew Marquez

table_name=$(pbpaste | awk '{print toupper($1)}')
echo -en "SELECT\n*\nFROM $table_name\nLIMIT 100;" | pbcopy

osascript <<EOF
tell application "System Events" to tell application process "Arc"
  click menu item "Paste" of menu "Edit" of menu bar 1
end tell
return
EOF

