#!/usr/bin/env bash

set -e

# ---------------------------------------------------------
# PATHS
# ---------------------------------------------------------
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
# VERIFY DOTFILES DIRECTORY
# ---------------------------------------------------------
verify_dotfiles() {
    log "Checking dotfiles directory..."

    if [[ ! -d "$DOTFILES" ]]; then
        err "Dotfiles directory not found at $DOTFILES"
        echo "Expected location: ~/.dotfiles"
        echo "Fix: Clone your repo into ~/.dotfiles"
        exit 1
    fi

    ok "Dotfiles directory found"
}

# ---------------------------------------------------------
# PULL LATEST CHANGES
# ---------------------------------------------------------
pull_latest() {
    log "Pulling latest dotfiles..."
    cd "$DOTFILES"
    git pull --rebase
    ok "Dotfiles updated"
}

# ---------------------------------------------------------
# REFRESH SYMLINKS
# ---------------------------------------------------------
refresh_symlinks() {
    log "Refreshing symlinks..."

    # Backup existing files
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

    ok "Symlinks refreshed"
}

# ---------------------------------------------------------
# UPDATE PLUGIN MANAGERS
# ---------------------------------------------------------
update_plugins() {
    log "Updating plugin managers..."

    # Zinit
    if [[ -d "$HOME/.local/share/zinit" ]]; then
        zsh -c "source ~/.zshrc; zinit self-update; zinit update"
    fi

    # TPM
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
    fi

    # lazy.nvim
    if [[ -d "$CONFIG/nvim/lazy" ]]; then
        nvim --headless "+Lazy! sync" +qa
    fi

    ok "Plugins updated"
}

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------
detect_os
verify_dotfiles
pull_latest
refresh_symlinks
update_plugins

ok "Update complete 🎉"
echo "Restart your terminal to apply changes."
