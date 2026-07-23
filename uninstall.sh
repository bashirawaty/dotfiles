#!/usr/bin/env bash

##############################################
#  Bashir Awaty — Cross‑Platform Dotfiles Uninstaller
#  Safely restores backups + removes symlinks
##############################################

set -e

timestamp=$(date +"%Y-%m-%d-%H-%M")
# ---------------------------------------------------------
# SELF-HEALING DOTFILES PATH DETECTOR
# ---------------------------------------------------------

# 1. If script is inside ~/.dotfiles, use that
if [[ -d "$HOME/.dotfiles" ]]; then
    DOTFILES="$HOME/.dotfiles"

# 2. If script is being run from inside the repo, detect dynamically
elif [[ -n "$BASH_SOURCE" ]]; then
    DOTFILES="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"

# 3. If script is run via sh ./script.sh, fallback to PWD
else
    DOTFILES="$(pwd)"
fi

# 4. Final validation
if [[ ! -d "$DOTFILES" ]]; then
    echo "🟥 ERROR: Dotfiles directory not found."
    echo "Expected at: ~/.dotfiles OR script location."
    exit 1
fi

echo "🟩 Dotfiles directory detected: $DOTFILES"


echo "🔍 Detecting OS..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    echo "🟦 macOS detected"
else
    OS="linux"
    echo "🟩 Linux detected"
fi

##############################################
# Helper: Restore backup if exists
##############################################

restore_backup() {
    local file="$1"
    local backup_pattern="${file}.backup-*"

    if compgen -G "$backup_pattern" > /dev/null; then
        local backup_file
        backup_file=$(ls -1t $backup_pattern | head -n 1)
        echo "♻️ Restoring backup for $file → $backup_file"
        mv -f "$backup_file" "$file"
    else
        echo "⚠️ No backup found for $file"
    fi
}

##############################################
# Helper: Remove symlink safely
##############################################

remove_symlink() {
    local file="$1"

    if [[ -L "$file" ]]; then
        echo "🗑 Removing symlink: $file"
        rm "$file"
        restore_backup "$file"
    elif [[ -f "$file" ]]; then
        echo "🛑 Skipping $file (real file — not a symlink)"
    else
        echo "⚠️ $file does not exist"
    fi
}

##############################################
# Remove symlinks + restore backups
##############################################

echo "🔗 Removing dotfile symlinks..."

remove_symlink "$HOME/.bashrc"
remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.tmux.conf"

remove_symlink "$HOME/.config/nvim/init.lua"
remove_symlink "$HOME/.config/nvim/lua"

##############################################
# Remove plugin managers
##############################################

echo "🧹 Removing Zsh plugin manager (zinit)..."
if [[ -d "$HOME/.zinit" ]]; then
    rm -rf "$HOME/.zinit"
else
    echo "⚠️ zinit not installed — skipping"
fi

echo "🧹 Removing Tmux Plugin Manager (TPM)..."
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    rm -rf "$HOME/.tmux/plugins/tpm"
else
    echo "⚠️ TPM not installed — skipping"
fi

echo "🧹 Removing Neovim plugin manager (lazy.nvim)..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ -d "$LAZY_PATH" ]]; then
    rm -rf "$LAZY_PATH"
else
    echo "⚠️ lazy.nvim not installed — skipping"
fi

##############################################
# Clean Neovim cache
##############################################

echo "🧽 Cleaning Neovim cache..."
rm -rf "$HOME/.local/share/nvim"
rm -rf "$HOME/.cache/nvim"

##############################################
# Final message
##############################################

echo ""
echo "🎉 Uninstall complete!"
echo "➡️ All symlinks removed safely."
echo "➡️ Backups restored where available."
echo "➡️ Plugin managers removed."
echo ""
echo "Your system is now clean, Bashir."
