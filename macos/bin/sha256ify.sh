#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title sha256ify
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "what? 🤔" }

# Documentation:
# @raycast.description get sha256 of input
# @raycast.author Andrew Marquez

pbcopy < <(echo -n "$1" | shasum -a 256 | awk '{print $1}' | tr -d '\n')
echo "sha256 copied to clipboard 📋"

