#!/bin/bash
#
# Usage: group-by-date.sh <directory>
#
# Groups files into subdirectories based on creation time.
# Subdirectories are in format YYYY-MM (e.g. "2022-11")

DIR=$1

if [ ! -d "$DIR" ]; then
	echo "Could not find directory '$DIR'"
	exit 1
else
	echo "Processing '$DIR'"
fi

while IFS= read -r -d '' file; do
  try-update-create-date.sh "$file"
	YEARMONTH=$(stat -f "%SB" -t "%Y-%m" "$file")
	SUBDIR="$DIR/$YEARMONTH"

	if [ ! -d "$SUBDIR" ]; then
		echo "Creating '$YEARMONTH'"
		mkdir "$SUBDIR"
	fi

	mv -- "$file" "$SUBDIR"
done < <(find "$DIR" -type f -maxdepth 1 -print0)
