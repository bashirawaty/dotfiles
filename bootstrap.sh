#!/usr/bin/env bash
set -e

# ---------------------------------------------------------
# SELF-HEALING DOTFILES PATH DETECTOR
# ---------------------------------------------------------
if [[ -d "$HOME/.dotfiles" ]]; then
    DOTFILES="$HOME/.dotfiles"
elif [[ -n "$BASH_SOURCE" ]]; then
    DOTFILES="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
else
    DOTFILES="$(pwd)"
fi

if [[ ! -d "$DOTFILES" ]]; then
    echo "🟥 ERROR: Dotfiles directory not found."
    exit 1
fi

echo "🟩 Dotfiles directory detected: $DOTFILES"

CONFIG="$HOME/.config"

log() { echo -e "🔧 $1"; }
ok()  { echo -e "🟩 $1"; }
err() { echo -e "🟥 $1"; }

# ---------------------------------------------------------
# OS DETECTION
# ---------------------------------------------------------
detect_os() {
    log "Detecting OS..."

    case "$(uname -s)" in
        Darwin) OS="mac"; ok "macOS detected" ;;
        Linux)  OS="linux"; ok "Linux detected" ;;
        *) err "Unsupported OS"; exit 1 ;;
    esac
}

# ---------------------------------------------------------
# PACKAGE MANAGER DETECTION
# ---------------------------------------------------------
detect_pkg_manager() {
    if command -v apt >/dev/null 2>&1; then PKG="apt"
    elif command -v dnf >/dev/null 2>&1; then PKG="dnf"
    elif command -v pacman >/dev/null 2>&1; then PKG="pacman"
    elif command -v brew >/dev/null 2>&1; then PKG="brew"
    else err "No supported package manager found"; exit 1
    fi

    ok "Package manager: $PKG"
}

# ---------------------------------------------------------
# INSTALL PACKAGE WRAPPER
# ---------------------------------------------------------
install_pkg() {
    case "$PKG" in
        apt)    sudo apt update; sudo apt install -y "$1" ;;
        dnf)    sudo dnf install -y "$1" ;;
        pacman) sudo pacman -Sy --noconfirm "$1" ;;
        brew)   brew install "$1" ;;
    esac
}

# ---------------------------------------------------------
# NEOVIM INSTALLER
# ---------------------------------------------------------
install_neovim() {
    log "Installing Neovim..."

    if [[ "$OS" == "mac" ]]; then
        brew install neovim
        ok "Neovim installed (macOS)"
        return
    fi

    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y neovim
        ok "Neovim installed (APT)"
        return
    fi

    if command -v dnf >/dev/null 2>&1; then
        if sudo dnf install -y neovim; then
            ok "Neovim installed (DNF)"
            return
        fi

        log "Enabling EPEL for Neovim..."
        sudo dnf install -y epel-release
        sudo dnf update -y

        if sudo dnf install -y neovim; then
            ok "Neovim installed (EPEL)"
            return
        fi

        log "Neovim not in repos. Installing AppImage..."
    fi

    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm neovim
        ok "Neovim installed (Pacman)"
        return
    fi

    log "Installing Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
    ok "Neovim installed via AppImage"
}

# ---------------------------------------------------------
# INSTALL CORE PACKAGES
# ---------------------------------------------------------
install_core() {
    log "Installing core packages..."
    install_pkg git
    install_pkg curl
    install_pkg wget
    install_pkg tmux
    install_pkg zsh
}

# ---------------------------------------------------------
# SYMLINK CREATION
# ---------------------------------------------------------
create_symlinks() {
    log "Creating symlinks..."

    for file in .zshrc .bashrc .tmux.conf; do
        if [[ -f "$HOME/$file" ]]; then
            mv "$HOME/$file" "$HOME/$file.backup-$(date +%Y%m%d-%H%M)"
        fi
    done

    ln -sf "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
    ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

    mkdir -p "$CONFIG"
    ln -sf "$DOTFILES/nvim" "$CONFIG/nvim"

    ok "Symlinks created"
}

# ---------------------------------------------------------
# INSTALL PLUGIN MANAGERS
# ---------------------------------------------------------
install_plugins() {
    log "Installing plugin managers..."

    if [[ ! -d "$HOME/.local/share/zinit" ]]; then
        sh -c "$(curl -fsSL https://git.io/zinit-install)"
    fi

    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    if [[ ! -d "$CONFIG/nvim/lazy" ]]; then
        git clone https://github.com/folke/lazy.nvim.git "$CONFIG/nvim/lazy"
    fi

    ok "Plugin managers installed"
}

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------
detect_os
detect_pkg_manager
install_core
install_neovim
create_symlinks
install_plugins

ok "Bootstrap complete 🎉"
echo "Restart your terminal to apply changes."
