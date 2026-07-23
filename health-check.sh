#!/usr/bin/env bash

############################################################
#  Bashir Awaty — Dotfiles Health Check Script
#  macOS + Linux + Cloud Engineering Ready
############################################################

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

############################################################
# Helper: Check if command exists
############################################################

check_cmd() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "✔ $1 installed"
    else
        echo "❌ $1 missing"
        MISSING=true
    fi
}

############################################################
# Helper: Check symlink validity
############################################################

check_symlink() {
    local link="$1"
    local target="$2"

    if [[ -L "$link" ]]; then
        if [[ "$(readlink "$link")" == "$target" ]]; then
            echo "✔ Symlink OK: $link → $target"
        else
            echo "❌ Symlink incorrect: $link"
            echo "   Expected: $target"
            echo "   Found: $(readlink "$link")"
            SYMLINK_ISSUE=true
        fi
    else
        echo "❌ $link is not a symlink"
        SYMLINK_ISSUE=true
    fi
}

############################################################
# Helper: Check backup presence
############################################################

check_backup() {
    local file="$1"
    local backup_pattern="${file}.backup-*"

    if compgen -G "$backup_pattern" > /dev/null; then
        echo "✔ Backup exists for $file"
    else
        echo "⚠️ No backup found for $file"
    fi
}

############################################################
# Check core binaries
############################################################

echo ""
echo "🔧 Checking core binaries..."

for cmd in git curl wget tmux nvim zsh fzf rg fd; do
    check_cmd "$cmd"
done

############################################################
# Check cloud tools
############################################################

echo ""
echo "☁️ Checking cloud tools..."

for cmd in kubectl docker terraform ansible; do
    check_cmd "$cmd"
done

############################################################
# Check dotfile symlinks
############################################################

echo ""
echo "🔗 Checking dotfile symlinks..."

check_symlink "$HOME/.bashrc" "$DOTFILES/bash/bashrc"
check_symlink "$HOME/.zshrc" "$DOTFILES/zsh/zshrc"
check_symlink "$HOME/.tmux.conf" "$DOTFILES/tmux/tmux.conf"
check_symlink "$HOME/.config/nvim/init.lua" "$DOTFILES/nvim/init.lua"
check_symlink "$HOME/.config/nvim/lua" "$DOTFILES/nvim/lua"

############################################################
# Check backups
############################################################

echo ""
echo "📁 Checking backups..."

check_backup "$HOME/.bashrc"
check_backup "$HOME/.zshrc"
check_backup "$HOME/.tmux.conf"
check_backup "$HOME/.config/nvim/init.lua"

############################################################
# Check Zsh plugin manager (zinit)
############################################################

echo ""
echo "🐚 Checking Zsh plugin manager (zinit)..."

if [[ -d "$HOME/.zinit" ]]; then
    echo "✔ zinit installed"
else
    echo "❌ zinit missing"
fi

############################################################
# Check Tmux plugin manager (TPM)
############################################################

echo ""
echo "🧩 Checking Tmux plugin manager (TPM)..."

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "✔ TPM installed"
else
    echo "❌ TPM missing"
fi

############################################################
# Check Neovim plugin manager (lazy.nvim)
############################################################

echo ""
echo "🎨 Checking Neovim plugin manager (lazy.nvim)..."

LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ -d "$LAZY_PATH" ]]; then
    echo "✔ lazy.nvim installed"
else
    echo "❌ lazy.nvim missing"
fi

############################################################
# Check Neovim LSP servers
############################################################

echo ""
echo "🧠 Checking Neovim LSP servers..."

LSP_SERVERS=(
    lua_ls
    bashls
    pyright
    yamlls
    dockerls
    terraformls
    tsserver
)

for server in "${LSP_SERVERS[@]}"; do
    if [[ -d "$HOME/.local/share/nvim/mason/packages/$server" ]]; then
        echo "✔ $server installed"
    else
        echo "❌ $server missing"
    fi
done

############################################################
# Check default shell
############################################################

echo ""
echo "🐚 Checking default shell..."

if [[ "$SHELL" == "$(command -v zsh)" ]]; then
    echo "✔ Default shell is Zsh"
else
    echo "❌ Default shell is not Zsh"
    echo "   Run: chsh -s $(which zsh)"
fi

############################################################
# Final summary
############################################################

echo ""
echo "============================================================"
echo "🎉 Health Check Complete"
echo "============================================================"

if [[ "$MISSING" == true ]]; then
    echo "❌ Some required binaries are missing."
fi

if [[ "$SYMLINK_ISSUE" == true ]]; then
    echo "❌ Some symlinks are incorrect."
fi

echo ""
echo "If everything shows ✔, your environment is perfect."
echo "If not, run:"
echo "➡️ ./install.sh   (to reinstall)"
echo "➡️ ./update.sh    (to refresh)"
echo "➡️ ./uninstall.sh (to reset)"
echo ""
echo "You're all set, Bashir."
