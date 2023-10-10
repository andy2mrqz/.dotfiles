#!/bin/bash

for file in *~1~; do
  original_name=${file%%.~1~}
  original_extension=${original_name##*.}
  prefix=${file%%.*}

  new_filename="${prefix}~1~.${original_extension}"

  mv -- "$file" "$new_filename"
done
