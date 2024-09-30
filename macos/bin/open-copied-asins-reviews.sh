#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Copied ASINs Reviews
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⭐

# Documentation:
# @raycast.author Andrew Marquez

pbpaste | tr ',' '\n' | awk '{$1=$1};1' | xargs -I {} open "https://www.amazon.com/product-reviews/{}?ie=UTF8&reviewerType=avp_only_reviews&sortBy=recent&pageNumber=1&formatType=current_format"
