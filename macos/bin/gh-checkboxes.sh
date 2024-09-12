#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title gh-checkboxes
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Andrew Marquez

osascript <<EOF
tell application "Arc"
  tell the active tab of its first window
    execute javascript "
      (() => {
        let checkboxes = document.querySelectorAll('input[type=\"checkbox\"].js-reviewed-checkbox');
        checkboxes.forEach(checkbox => checkbox.click());
      })();
    "
  end tell
end tell
return
EOF
