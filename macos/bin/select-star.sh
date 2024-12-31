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
tell application "System Events"
    keystroke "v" using {command down}
end tell
EOF
