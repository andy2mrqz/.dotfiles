#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ddb-json
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Andrew Marquez

osascript <<EOF
tell application "Google Chrome"
    tell the active tab of its first window
        execute javascript "document.evaluate('//span[text()=\"JSON view\"]/parent::*',document,null,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue.click(),document.evaluate('//span[text()=\"View DynamoDB JSON\"]/parent::*',document,null,XPathResult.FIRST_ORDERED_NODE_TYPE,null).singleNodeValue.click();"
    end tell
end tell
return
EOF
