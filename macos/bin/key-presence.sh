#!/usr/bin/env bash

# Streaming JSON array analyzer - handles files of any size without OOM
# Uses jq --stream to process incrementally
# DEPRECATED: Prefer ~/Projects/key-presence/ now - rust implementation with SIMD acceleration

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
    # Stream through, reconstruct and output records missing the column
    # Uses awk to track record state and rebuild JSON
    jq -rn --stream '
      inputs
      | select(length == 2)
      | select(.[0] | length >= 2)
      | "\(.[0][0])\t\(.[0][1])\t\(.[1] | @json)"
    ' "$json_file" \
    | awk -F'\t' -v col="$column" -v n="$example_count" '
      function flush_record() {
        if (current_idx != "" && !has_col && count < n) {
          # Build JSON object
          printf "{"
          first = 1
          for (k in record) {
            if (!first) printf ","
            printf "\"%s\":%s", k, record[k]
            first = 0
          }
          printf "}\n"
          count++
        }
        delete record
        has_col = 0
      }
      {
        idx = $1; key = $2; val = $3
        if (idx != current_idx && current_idx != "") {
          flush_record()
        }
        current_idx = idx
        record[key] = val
        if (key == col && val != "null" && val != "\"\"") {
          has_col = 1
        }
      }
      END {
        flush_record()
      }
    '

  elif [[ "$verbose" == "true" ]]; then
    # Stream through, reconstruct and output records that have the column
    jq -rn --stream '
      inputs
      | select(length == 2)
      | select(.[0] | length >= 2)
      | "\(.[0][0])\t\(.[0][1])\t\(.[1] | @json)"
    ' "$json_file" \
    | awk -F'\t' -v col="$column" -v n="$example_count" '
      function flush_record() {
        if (current_idx != "" && has_col && count < n) {
          printf "{"
          first = 1
          for (k in record) {
            if (!first) printf ","
            printf "\"%s\":%s", k, record[k]
            first = 0
          }
          printf "}\n"
          count++
        }
        delete record
        has_col = 0
      }
      {
        idx = $1; key = $2; val = $3
        if (idx != current_idx && current_idx != "") {
          flush_record()
        }
        current_idx = idx
        record[key] = val
        if (key == col && val != "null" && val != "\"\"") {
          has_col = 1
        }
      }
      END {
        flush_record()
      }
    '

  else
    # Stream through, output just the column values (most efficient)
    jq -rn --stream --arg col "$column" '
      limit('"$example_count"';
        inputs
        | select(length == 2)
        | select(.[0] | length >= 2)
        | select(.[0][1] == $col)
        | .[1]
        | select(. != null and . != "")
        | tostring
      )
    ' "$json_file" | { echo "$column"; cat; }
  fi

else
  # Key presence statistics - stream through with awk for counting
  jq -rn --stream '
    inputs
    | select(length == 2)
    | select(.[0] | length >= 2)
    | "\(.[0][0])\t\(.[0][1])"
  ' "$json_file" \
  | awk -F'\t' '
    {
      # When record index changes, finalize previous record
      if ($1 != last_idx && NR > 1) {
        for (k in seen) counts[k]++
        delete seen
        total++
      }
      seen[$2] = 1
      last_idx = $1
    }
    END {
      # Finalize last record
      for (k in seen) counts[k]++
      total++
      # Output stats sorted by count
      for (k in counts) {
        pct = (counts[k] / total) * 100
        printf "%s\t%d\t%.3f%%\n", k, counts[k], pct
      }
    }
  ' | sort -t$'\t' -k2 -n | column -t
fi
