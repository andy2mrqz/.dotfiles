#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Copied ASINs (Germany)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🛍️

# Documentation:
# @raycast.author Andrew Marquez

pbpaste | tr ',' '\n' | awk '{$1=$1};1' | xargs -I {} open "https://www.amazon.de/dp/{}"
