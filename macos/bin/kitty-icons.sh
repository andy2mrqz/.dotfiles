#!/bin/bash

# Download icons to /tmp/
ICONS_DIR="/tmp/"
ICONS_FILE="kitty.icns"
curl --output-dir "$ICONS_DIR" -o "$ICONS_FILE" "https://raw.githubusercontent.com/DinkDonk/kitty-icon/main/kitty-dark.icns"

# Move icons to kitty icons location
mv "$ICONS_DIR$ICONS_FILE" "/Applications/kitty.app/Contents/Resources/kitty.icns"

# Clear icon caches and refresh Dock
DOCK_CACHE_FILE=$(fd -t f com.apple.dock.iconcache /var/folders/)
[ -n "$DOCK_CACHE_FILE" ] && rm "$DOCK_CACHE_FILE"
DOCK_SERVICES_DIR=$(fd -t d --glob com.apple.iconservices /var/folders/)
[ -n "$DOCK_SERVICES_DIR" ] && rm -r "$DOCK_SERVICES_DIR"
killall Dock

# May not be immediate
cat <<EOF
The icon may not refresh immediately.  You can test by running this command:

open /Applications/kitty.app/Contents/Resources/kitty.icns
EOF
