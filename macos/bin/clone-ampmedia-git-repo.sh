#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title clone ampmedia git repo (ghostty)
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "repo name" }
#
# Optional parameters:
# @raycast.icon 🐙
#
# Documentation:
# @raycast.author Andrew Marquez

REPO_NAME="$1"

cd ~/Projects || exit
# if the repo doesn't exist, clone it
if [ ! -d "${REPO_NAME}" ]; then
	git clone "https://github.com/ampmedia/${REPO_NAME}.git"
fi

cd "${REPO_NAME}" && cursor . || exit
