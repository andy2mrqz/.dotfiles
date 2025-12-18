#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Usage: $0 <json-file>"
  exit 1
fi

jq -r '
  . as $rows
  | ($rows | length) as $total
  | reduce $rows[] as $o ({};
      reduce ($o | keys[]) as $k (.;
        .[$k] += 1
      )
    )
  | to_entries
  | map({
      key: .key,
      count: .value,
      percent: (.value / $total) * 100
    })
  | sort_by(.count)
  | .[]
  | "\(.key)\t\(.count)\t\(.percent | . * 1000 | round / 1000)%"
' "$1" | column -t

