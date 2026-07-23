#!/usr/bin/env bash

##############################################
#  Bashir Awaty — Cross‑Platform Dotfiles Updater
#  Safe re-symlinking + plugin updates
##############################################

set -e

DOTFILES="$HOME/dotfiles"
timestamp=$(date +"%Y-%m-%d-%H-%M")

echo "🔍 Detecting OS..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    echo "🟦 macOS detected"
else
    OS="linux"
    echo "🟩 Linux detected"
fi

##############################################
# Pull latest dotfiles
##############################################

echo "⬇️ Pulling latest dotfiles..."
cd "$DOTFILES"
git pull --rebase

##############################################
# Safe symlink function (does NOT overwrite real files)
##############################################

safe_symlink() {
    local target="$1"
    local link="$2"

    if [[ -L "$link" ]]; then
        echo "🔁 Updating symlink: $link"
        ln -sf "$target" "$link"
    elif [[ -f "$link" ]]; then
        echo "🛑 Skipping $link (real file detected — not a symlink)"
        echo "   If you want to replace it, run install.sh instead."
    else
        echo "🔗 Creating new symlink: $link"
        ln -sf "$target" "$link"
    fi
}

##############################################
# Re-symlink dotfiles safely
##############################################

echo "🔗 Updating symlinks..."

safe_symlink "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
safe_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
safe_symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
safe_symlink "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"
safe_symlink "$DOTFILES/nvim/lua" "$HOME/.config/nvim/lua"

##############################################
# Update Zsh plugins (zinit)
##############################################

echo "⚙️ Updating Zsh plugins (zinit)..."

if [[ -d "$HOME/.zinit" ]]; then
    zsh -c "source $HOME/.zinit/bin/zinit.zsh; zinit self-update; zinit update"
else
    echo "⚠️ zinit not installed — skipping"
fi

##############################################
# Update Tmux plugins (TPM)
##############################################

echo "⚙️ Updating Tmux plugins (TPM)..."

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
else
    echo "⚠️ TPM not installed — skipping"
fi

##############################################
# Update Neovim plugins (lazy.nvim)
##############################################

echo "⚙️ Updating Neovim plugins (lazy.nvim)..."

if command -v nvim >/dev/null 2>&1; then
    nvim --headless "+Lazy! sync" +qa
else
    echo "⚠️ Neovim not installed — skipping"
fi

##############################################
# Final message
##############################################

echo ""
echo "🎉 Update complete!"
echo "➡️ All symlinks refreshed safely."
echo "➡️ All plugins updated (Zsh, Tmux, Neovim)."
echo "➡️ Dotfiles pulled from GitHub."
echo ""
echo "Your system is now fully up to date, Bashir."
