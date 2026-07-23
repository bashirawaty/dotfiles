#!/usr/bin/env bash

############################################################
#  Bashir Awaty — Full System Bootstrap Script
#  macOS + Linux + Cloud Engineering Ready
############################################################

set -e

timestamp=$(date +"%Y-%m-%d-%H-%M")
DOTFILES="$HOME/dotfiles"

echo "🔍 Detecting OS..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    echo "🟦 macOS detected"
else
    OS="linux"
    echo "🟩 Linux detected"
fi

############################################################
# Install Homebrew (macOS only)
############################################################

if [[ "$OS" == "mac" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "🍺 Homebrew already installed"
    fi
fi

############################################################
# Detect Linux package manager
############################################################

if [[ "$OS" == "linux" ]]; then
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

############################################################
# Install core packages
############################################################

echo "📦 Installing core packages..."

install_pkg() {
    case "$PKG" in
        brew) brew install "$1" ;;
        apt) sudo apt update && sudo apt install -y "$1" ;;
        dnf) sudo dnf install -y "$1" ;;
        pacman) sudo pacman -Sy --noconfirm "$1" ;;
    esac
}

# Universal tools
for pkg in git curl wget tmux neovim zsh; do
    install_pkg "$pkg"
done

# Search tools
if [[ "$OS" == "mac" ]]; then
    install_pkg fd
    install_pkg ripgrep
    install_pkg fzf
    install_pkg reattach-to-user-namespace
else
    install_pkg fd-find || true
    install_pkg ripgrep || true
    install_pkg fzf || true
fi

############################################################
# Set Zsh as default shell
############################################################

echo "🐚 Setting Zsh as default shell..."

if ! grep -q "$(command -v zsh)" /etc/shells; then
    echo "$(command -v zsh)" | sudo tee -a /etc/shells
fi

chsh -s "$(command -v zsh)"

############################################################
# Clone dotfiles repo
############################################################

if [[ ! -d "$DOTFILES" ]]; then
    echo "⬇️ Cloning dotfiles repo..."
    git clone https://github.com/bashirawaty/dotfiles.git "$DOTFILES"
else
    echo "📁 Dotfiles repo already exists — pulling latest..."
    cd "$DOTFILES"
    git pull --rebase
fi

############################################################
# Run install.sh
############################################################

echo "⚙️ Running install.sh..."
bash "$DOTFILES/install.sh"

############################################################
# Final message
############################################################

echo ""
echo "🎉 Bootstrap complete!"
echo "Your machine is now fully configured:"
echo "✔ Zsh + plugins"
echo "✔ Tmux + plugins"
echo "✔ Neovim + LSP + Treesitter + Telescope"
echo "✔ Cloud engineering tools installed"
echo "✔ Dotfiles symlinked + backups preserved"
echo ""
echo "Welcome to your new environment, Bashir."
