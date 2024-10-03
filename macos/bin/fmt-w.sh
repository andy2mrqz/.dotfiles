#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title fmt -w
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "60" }

# Documentation:
# @raycast.author Andrew Marquez

# Simulate copying the selected text
osascript -e 'tell application "System Events" to keystroke "x" using command down'

# Wait a moment for the copy operation to complete
sleep 0.1

# Format the text
pbpaste | fmt -w "$1" | pbcopy

# Paste it back over the selected text
osascript -e 'tell application "System Events" to keystroke "v" using command down'
