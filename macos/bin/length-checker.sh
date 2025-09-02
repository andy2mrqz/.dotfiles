#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Length
# @raycast.mode inline

# Optional parameters:
# @raycast.icon 📐

# Documentation:
# @raycast.author Andrew Marquez

INPUT=$(pbpaste)
LENGTH=$(echo -n "$INPUT" | wc -c | tr -d ' ')

echo "$LENGTH chars ('$INPUT')"
