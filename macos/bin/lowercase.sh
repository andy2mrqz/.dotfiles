#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Lowercase
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤏
# @raycast.argument1 { "type": "text", "placeholder": "YOUR STRING" }

# Documentation:
# @raycast.author Andrew Marquez

LOWERCASED=$(echo -n "$1" | tr '[:upper:]' '[:lower:]')

echo -n "Lowercased: '$LOWERCASED'"
echo -n "$LOWERCASED" | pbcopy
