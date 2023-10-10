#!/bin/bash

# Handling of spaces (other part at the end)
OIFS="$IFS"
IFS=$'\n'

for file in $(find -E ./results -type f ! -name '*.json*'); do
  ts=''
  ts_exif=$(exiftool "$file" -CreateDate -d '%Y%m%d%H%M' -p '$CreateDate' -q -q)
  ts_grep=$(echo "$file" | grep -Eo '20[0|1|2]\d{5}[_|-]*\d{4}' | sed 's/[_|-]//g')
  if [ -z "$ts_exif" ]; then
    ts="$ts_grep"
  else
    if [ -n "$ts_grep" ] && [ "$ts_exif" != "$ts_grep" ]; then
      ts="$ts_grep"
    else
      ts="$ts_exif"
      ts_created=$(exiftool "$file" -CreateDate -d '%m/%d/%Y %H:%M:%S' -p '$CreateDate' -q -q)
    fi
  fi

  if [ -z "$ts" ]; then
    echo 'no timestamp found for: ' "$file"
  else
    touch -t "$ts" "$file"
    if [ -n "$ts_created" ]; then
      setfile -d "$ts_created" "$file"
    fi
  fi
done

# Reset how spaces are handled
IFS="$OIFS"

