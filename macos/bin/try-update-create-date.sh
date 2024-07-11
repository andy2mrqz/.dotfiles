#!/bin/bash
#
# Usage: try-update-create-date.sh <file>
#
# Attempts to update the creation date of files based on the EXIF data.

FILE=$1
ts=''
# Get the EXIF creation date
ts_exif=$(exiftool "$FILE" -CreateDate -d '%Y%m%d%H%M' -p '$CreateDate' -q -q)
if [ -z "$ts_exif" ]; then
  # If EXIF creation date is empty, try to extract timestamp from the file name
  ts_grep=$(echo "$FILE" | grep -Eo '20[0|1|2]\d{5}[_|-]*\d{4}' | sed 's/[_|-]//g')
  ts="$ts_grep"
else
  # If EXIF creation date is not empty
  if [ -n "$ts_grep" ] && [ "$ts_exif" != "$ts_grep" ]; then
    # If timestamp extracted from file name is not empty and different from EXIF creation date
    ts="$ts_grep"
  else
    # Use EXIF creation date as the timestamp
    ts="$ts_exif"
    ts_created=$(exiftool "$FILE" -CreateDate -d '%m/%d/%Y %H:%M:%S' -p '$CreateDate' -q -q) # Get the formatted creation date
  fi
fi

if [ -z "$ts" ]; then
  # If no timestamp is found
  echo 'no timestamp found for: ' "$FILE"
else
 echo "Updating timestamp for $FILE to $ts"
  # Update the file's modification timestamp
  touch -t "$ts" "$FILE"
  if [ -n "$ts_created" ]; then
    # If formatted creation date is available, update the file's creation date
    setfile -d "$ts_created" "$FILE"
  fi
fi