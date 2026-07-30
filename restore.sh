#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# restore.sh — restores dotfiles from the most recent backup directory.
# Works with backups created by install.sh (dotfiles_backup_YYYYMMDD_HHMMSS).
# ------------------------------------------------------------------------------

set -e

BACKUP_BASE="$HOME"
LATEST_BACKUP=$(ls -dt "$BACKUP_BASE"/dotfiles_backup_* 2>/dev/null | head -n 1)

if [[ -z "$LATEST_BACKUP" ]]; then
    echo "❌ No backup directory found. Nothing to restore."
    exit 1
fi

echo "🔄 Restoring dotfiles from: $LATEST_BACKUP"
echo

restore() {
    local file="$1"
    local src="$LATEST_BACKUP/$file"
    local dest="$HOME/$file"

    if [[ -e "$src" ]]; then
        echo "Restoring $file → $dest"
        cp -R "$src" "$dest"
    else
        echo "Skipping $file (no backup found)"
    fi
}

# ------------------------------------------------------------------------------
# RESTORE FILES
# ------------------------------------------------------------------------------
restore ".bashrc"
restore ".bash_profile"
restore ".tmux.conf"
restore ".ssh/config"
restore ".gitconfig"
restore ".gitignore_global"

echo
echo "✅ Restore complete."
echo "Restored from: $LATEST_BACKUP"
