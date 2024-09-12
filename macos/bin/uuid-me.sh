#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title UUID me
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🦑

# Documentation:
# @raycast.author Andrew Marquez

uuid=$(uuidgen | tr '[:upper:]' '[:lower:]')
echo "Copied $uuid"
echo -n "$uuid" | pbcopy
