#!/usr/bin/env bash

column=""
example_count=5
missing=false
verbose=false
json_file=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --column)
      column="$2"
      shift 2
      ;;
    --example-count)
      example_count="$2"
      shift 2
      ;;
    --missing)
      missing=true
      shift
      ;;
    --verbose)
      verbose=true
      shift
      ;;
    *)
      json_file="$1"
      shift
      ;;
  esac
done

if [[ -z "$json_file" ]]; then
  echo "Usage: $0 [--column col] [--example-count N] [--missing] [--verbose] <json-file>"
  exit 1
fi

# --missing implies --verbose (showing full records makes sense when column is empty)
if [[ "$missing" == "true" ]]; then
  verbose=true
fi

if [[ -n "$column" ]]; then
  if [[ "$missing" == "true" ]]; then
    # Show entire records where the column is missing/empty
    jq --arg col "$column" --argjson n "$example_count" '
      [.[] | select(.[$col] == null or .[$col] == "")]
      | limit($n; .[])
    ' "$json_file"
  elif [[ "$verbose" == "true" ]]; then
    # Show entire records where the column is present
    jq --arg col "$column" --argjson n "$example_count" '
      [.[] | select(.[$col] != null and .[$col] != "")]
      | limit($n; .[])
    ' "$json_file"
  else
    # Show just column values for records that have the column
    jq -r --arg col "$column" --argjson n "$example_count" '
      $col
      , (
          [.[] | select(.[$col] != null and .[$col] != "")]
          | limit($n; .[])
          | .[$col]
          | tostring
        )
    ' "$json_file"
  fi
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

