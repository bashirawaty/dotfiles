#!/usr/bin/env bash

##############################################
#  Bashir Awaty — Cross‑Platform Dotfiles Installer
#  With Automatic Backup of Original Files
##############################################

set -e

timestamp=$(date +"%Y-%m-%d-%H-%M")
DOTFILES="$HOME/dotfiles"

echo "🔍 Detecting OS..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    PKG="brew"
    echo "🟦 macOS detected"
else
    OS="linux"
    echo "🟩 Linux detected"

    if command -v apt >/dev/null 2>&1; then
        PKG="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PKG="dnf"
    elif command -v pacman >/dev/null 2>&1; then
        PKG="pacman"
    else
        echo "❌ Unsupported Linux package manager"
        exit 1
    fi
fi

##############################################
# Install dependencies
##############################################

echo "📦 Installing dependencies..."

install_pkg() {
    case "$PKG" in
        brew) brew install "$1" ;;
        apt) sudo apt update && sudo apt install -y "$1" ;;
        dnf) sudo dnf install -y "$1" ;;
        pacman) sudo pacman -Sy --noconfirm "$1" ;;
    esac
}

for pkg in git curl wget tmux neovim; do
    install_pkg "$pkg"
done

if [[ "$OS" == "mac" ]]; then
    install_pkg fd
    install_pkg ripgrep
    install_pkg reattach-to-user-namespace
else
    install_pkg fd-find || true
    install_pkg ripgrep || true
fi

##############################################
# Backup function
##############################################

backup_file() {
    local file="$1"
    if [[ -f "$file" || -L "$file" ]]; then
        echo "📁 Backing up $file → $file.backup-$timestamp"
        mv "$file" "$file.backup-$timestamp"
    fi
}

##############################################
# Symlink dotfiles (with backup)
##############################################

echo "🔗 Creating symlinks with backup..."

backup_file "$HOME/.bashrc"
ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"

backup_file "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

backup_file "$HOME/.tmux.conf"
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"

backup_file "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"

backup_file "$HOME/.config/nvim/lua"
ln -sf "$DOTFILES/nvim/lua" "$HOME/.config/nvim/lua"

##############################################
# Install Zsh plugin manager (zinit)
##############################################

echo "⚙️ Installing Zsh plugin manager (zinit)..."

if [[ ! -d "$HOME/.zinit" ]]; then
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi

##############################################
# Install Tmux Plugin Manager (TPM)
##############################################

echo "⚙️ Installing Tmux Plugin Manager (TPM)..."

mkdir -p "$HOME/.tmux/plugins"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

##############################################
# Install Neovim plugin manager (lazy.nvim)
##############################################

echo "⚙️ Installing Neovim plugin manager (lazy.nvim)..."

LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ ! -d "$LAZY_PATH" ]]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
fi

##############################################
# Final message
##############################################

echo ""
echo "🎉 Installation complete!"
echo "🛡 All original files were backed up safely."
echo "➡️ Restart your terminal or run: source ~/.zshrc"
echo "➡️ Open tmux and press: prefix + I (to install plugins)"
echo "➡️ Open Neovim and lazy.nvim will auto-install plugins"
echo ""
echo "You're fully set, Bashir — your dotfiles are now safe, portable, and backed up."
