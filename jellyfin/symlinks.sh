#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Base directory
BASE_DIR="$HOME/jellyfin"

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Create symbolic links
ln -sfn /var/lib/jellyfin   "$BASE_DIR/data"
ln -sfn /etc/jellyfin       "$BASE_DIR/config"
ln -sfn /var/log/jellyfin   "$BASE_DIR/log"
ln -sfn /var/cache/jellyfin "$BASE_DIR/cache"

echo "Jellyfin Symlinks created."
