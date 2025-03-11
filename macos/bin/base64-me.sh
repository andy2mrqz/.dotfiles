#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JWT/Base64 Decoder
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔏
# @raycast.argument1 { "type": "text", "placeholder": "Your JWT or Base64 string..." }

# Documentation:
# @raycast.author Andrew Marquez (Updated by ChatGPT)

TOKEN="$1"

if [ -z "$TOKEN" ]; then
	echo "No input provided."
	exit 1
fi

# Function to decode a base64 (or URL-safe base64) encoded string.
# It will add padding if necessary and convert URL-safe characters to standard ones.
decode_base64() {
	local part="$1"
	# Fix padding if needed
	local len=${#part}
	local mod4=$((len % 4))
	if [ $mod4 -eq 2 ]; then
		part="${part}=="
	elif [ $mod4 -eq 3 ]; then
		part="${part}="
	elif [ $mod4 -eq 1 ]; then
		# This is unusual, but we output an error if the padding is off.
		echo "Invalid base64 string (incorrect length)" >&2
		exit 1
	fi
	# Replace URL-safe characters and decode the string.
	echo "$part" | tr '_-' '/+' | base64 -d 2>/dev/null
}

# Function to pretty-print JSON if valid, otherwise return the original string
pretty_print_json() {
    local input="$1"
    # Check if the input is valid JSON
    if echo "$input" | jq -e . >/dev/null 2>&1; then
        # It's valid JSON, pretty-print it
        echo "$input" | jq .
    else
        # Not valid JSON, return as-is
        echo "$input"
    fi
}

# Determine if the input looks like a JWT (i.e. three parts separated by two dots)
dot_count=$(awk -F'.' '{print NF-1}' <<<"$TOKEN")
output=""

if [ "$dot_count" -eq 2 ]; then
	# Assume it's a JWT: decode header and payload.
	header=$(echo "$TOKEN" | cut -d. -f1)
	payload=$(echo "$TOKEN" | cut -d. -f2)

	# Decode header and payload using our decode_base64 function.
	decoded_header=$(decode_base64 "$header")
	decoded_payload=$(decode_base64 "$payload")

	# Pretty-print the header and payload if they're JSON
	formatted_header=$(pretty_print_json "$decoded_header")
	formatted_payload=$(pretty_print_json "$decoded_payload")

	# Store the results in the output variable.
	output="HEADER:
$formatted_header

PAYLOAD:
$formatted_payload"
else
	# Otherwise, treat the input as a simple base64 encoded string.
	decoded=$(decode_base64 "$TOKEN")
	# Pretty-print if it's JSON
	formatted=$(pretty_print_json "$decoded")
	output="$formatted"
fi

# The only echoed output is at the very end.
echo -n "$output"
