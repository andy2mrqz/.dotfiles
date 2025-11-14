#!/usr/bin/env bash

set -euo pipefail

start_dir="$(pwd)"
trap 'cd "$start_dir"' EXIT

shopt -s nullglob

first=1
for dir in */; do
    [ -d "$dir" ] || continue
    [ "$first" -eq 1 ] && first=0 || printf '\n'
    printf '[%s]\n' "${dir%/}"
    cd "$dir"

    if [ -d .git ]; then
        git pull --ff-only
    else
        echo "Skipping: not a git repository"
    fi

    cd "$start_dir"
done

