#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Sql Listify
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐷

# Documentation:
# @raycast.author Andrew Marquez

pbpaste | xargs -I {} echo "'{}'" | paste -sd, - | pbcopy

echo "Successfully listified and copied to clipboard 🎉"
