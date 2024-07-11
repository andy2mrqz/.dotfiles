#!/bin/bash
#
# Usage: try-update-create-date.sh <file>
#
# Attempts to update the creation date of files based on the EXIF data.

FILE=$1
ts=''
ts_exif=$(exiftool "$FILE" -CreateDate -d '%Y%m%d%H%M' -p '$CreateDate' -q -q)
if [ -z "$ts_exif" ]; then
  ts_grep=$(echo "$FILE" | grep -Eo '20[0|1|2]\d{5}[_|-]*\d{4}' | sed 's/[_|-]//g')
  ts="$ts_grep"
else
  if [ -n "$ts_grep" ] && [ "$ts_exif" != "$ts_grep" ]; then
    ts="$ts_grep"
  else
    ts="$ts_exif"
    ts_created=$(exiftool "$FILE" -CreateDate -d '%m/%d/%Y %H:%M:%S' -p '$CreateDate' -q -q)
  fi
fi

if [ -z "$ts" ]; then
  echo 'no timestamp found for: ' "$FILE"
else
  touch -t "$ts" "$FILE"
  if [ -n "$ts_created" ]; then
    setfile -d "$ts_created" "$FILE"
  fi
fi