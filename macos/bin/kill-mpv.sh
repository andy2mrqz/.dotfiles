#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title kill mpv
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🤫
#
# Documentation:
# @raycast.author Andrew Marquez

pgrep mpv | xargs kill -9
