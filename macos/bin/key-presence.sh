#!/usr/bin/env bash

columns=""
example_count=5
json_file=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --columns)
      columns="$2"
      shift 2
      ;;
    --example-count)
      example_count="$2"
      shift 2
      ;;
    *)
      json_file="$1"
      shift
      ;;
  esac
done

if [[ -z "$json_file" ]]; then
  echo "Usage: $0 [--columns col1,col2,...] [--example-count N] <json-file>"
  exit 1
fi

if [[ -n "$columns" ]]; then
  # Output example rows for specified columns as CSV
  # Filter for rows where ALL specified columns have non-null/non-empty values
  jq -r --arg cols "$columns" --argjson n "$example_count" '
    ($cols | split(",")) as $keys
    | ($keys | join(","))
    , (
        [.[] | select(all(.[$keys[]]; . != null and . != ""))]
        | limit($n; .[])
        | [.[$keys[]]]
        | map(tostring)
        | join(",")
      )
  ' "$json_file"
else
  # Original behavior: show key presence statistics
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
  ' "$json_file" | column -t
fi

