#!/usr/bin/env bash

##############################################
#  Bashir Awaty — Simple Dotfiles Installer
##############################################

set -e

DOTFILES="$HOME/dotfiles"

echo "🔗 Creating symlinks for dotfiles..."

# Create directories if they don't exist
mkdir -p "$HOME/.config/nvim"

# Link shell config files
ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

# Link tmux config
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Link Neovim config
ln -sf "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "✅ Symlinks created successfully!"
echo "Restart your terminal or source your shell config to apply changes."
