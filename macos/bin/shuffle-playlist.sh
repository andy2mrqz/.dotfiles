#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title shuffle playlist
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 🎧
#
# Documentation:
# @raycast.author Andrew Marquez

set -euo pipefail

PLAYLIST="${1:-liked}"

cd ~/ytmusic/playlists || exit

nohup mpv --no-video --shuffle --no-terminal --really-quiet "$PLAYLIST" </dev/null >>"$HOME/Library/Logs/mpv-raycast.log" 2>&1 &

exit 0

