#!/usr/bin/env bash

set -e

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

CONFIG="$HOME/.config"

log() {
    echo -e "🔧 $1"
}

ok() {
    echo -e "🟩 $1"
}

err() {
    echo -e "🟥 $1"
}

# ---------------------------------------------------------
# OS DETECTION
# ---------------------------------------------------------
detect_os() {
    log "Detecting OS..."

    case "$(uname -s)" in
        Darwin)
            OS="mac"
            ok "macOS detected"
            ;;
        Linux)
            OS="linux"
            ok "Linux detected"
            ;;
        *)
            err "Unsupported OS"
            exit 1
            ;;
    esac
}

# ---------------------------------------------------------
# PACKAGE MANAGER DETECTION
# ---------------------------------------------------------
detect_pkg_manager() {
    if command -v apt >/dev/null 2>&1; then
        PKG="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PKG="dnf"
    elif command -v pacman >/dev/null 2>&1; then
        PKG="pacman"
    elif command -v brew >/dev/null 2>&1; then
        PKG="brew"
    else
        err "No supported package manager found"
        exit 1
    fi

    ok "Package manager: $PKG"
}

# ---------------------------------------------------------
# INSTALL PACKAGE WRAPPER
# ---------------------------------------------------------
install_pkg() {
    case "$PKG" in
        apt)
            sudo apt update
            sudo apt install -y "$1"
            ;;
        dnf)
            sudo dnf install -y "$1"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$1"
            ;;
        brew)
            brew install "$1"
            ;;
    esac
}

# ---------------------------------------------------------
# NEOVIM INSTALLER (macOS + ALL Linux distros)
# ---------------------------------------------------------
install_neovim() {
    log
