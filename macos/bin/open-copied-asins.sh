#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Copied ASINs
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🛍️

# Documentation:
# @raycast.author Andrew Marquez

pbpaste | xargs -I {} open "https://www.amazon.com/dp/{}"
