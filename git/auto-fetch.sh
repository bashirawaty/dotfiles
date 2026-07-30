#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Auto-fetch all Git repos every 10 minutes.
# Works for Linux + macOS.
# ------------------------------------------------------------------------------

REPO_DIR="$HOME/projects"

while true; do
    echo "Auto-fetching Git repos in $REPO_DIR..."
    find "$REPO_DIR" -maxdepth 2 -type d -name ".git" | while read gitdir; do
        repo="$(dirname "$gitdir")"
        echo "Fetching $repo..."
        git -C "$repo" fetch --all --prune
    done
    sleep 600
done
