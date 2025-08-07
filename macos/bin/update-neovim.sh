#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

# Store the current directory
ORIGINAL_DIR=$(pwd)

# Navigate to the Neovim directory
cd ~/Projects/neovim || {
	echo "Failed to change to Neovim directory"
	exit 1
}

force_update=false
cleanup_days=30 # Number of days to keep old tags

# Parse command line arguments
while [[ $# -gt 0 ]]; do
	case $1 in
		-f | --force) force_update=true ;;
		*)
			echo "Unknown parameter passed: $1"
			exit 1
			;;
	esac
	shift
done

# Fetch the latest changes without merging
git fetch origin master

# Check if there are any new commits
if ! $force_update && git diff HEAD origin/master --quiet; then
	echo "No new commits. Neovim is up to date."
	exit 0
fi

# Show the new commits and wait for user input
echo "New commits since last update:"
git log HEAD..origin/master --oneline
echo
read -p "Press Enter to continue or Ctrl+C to exit..." -r

# Create a tag
DATE=$(date +%Y%m%d)
TAG_PREFIX="andrew-stable-build-"
TAG_NAME="$TAG_PREFIX-$DATE"
git tag "$TAG_NAME" || echo "Continuing with the update." # Ignore error if tag already exists

# Pull latest changes
git pull origin master

# Ask for confirmation before rebuilding
read -p "Ready to rebuild Neovim? (y/n) " -n 1 -r
echo # Move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	# Rebuild
  SDKROOT=$(xcrun --show-sdk-path)
  export SDKROOT
  export CPATH=$SDKROOT/usr/include
	sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
	echo "Update complete. If you need to revert, use: git checkout $TAG_NAME"
else
	echo "Rebuild cancelled. You can rebuild manually when ready."
	exit 0
fi

# Cleanup old tags
echo "Cleaning up old tags..."
git tag -l "$TAG_PREFIX*" --sort=-creatordate | tail -n "+$cleanup_days" | xargs -r git tag -d

echo "Cleanup complete."

# Return to the original directory
cd "$ORIGINAL_DIR" || {
	echo "Failed to return to original directory"
	exit 1
}
