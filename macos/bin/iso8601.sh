#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ISO 8601 me
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📅

# Documentation:
# @raycast.author Andrew Marquez

iso8601=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "Copied $iso8601"
echo -n "$iso8601" | pbcopy

