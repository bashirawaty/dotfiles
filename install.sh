#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# install.sh — symlink installer for dotfiles.
# Safely backs up existing ~/.bashrc, ~/.bash_profile, ~/.tmux.conf, ~/.ssh/config,
# and Git configs before linking new ones.
# ------------------------------------------------------------------------------

set -e

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

backup() {
  local target="$HOME/$1"
  if [ -e "$target" ]; then
    echo "Backing up $target → $BACKUP_DIR/$1"
    cp -R "$target" "$BACKUP_DIR/$1"
  fi
}

link() {
  local src="$DOTFILES/$1"
  local dest="$HOME/$2"

  echo "Linking $src → $dest"
  ln -sf "$src" "$dest"
}

echo "Starting dotfiles installation..."
echo "Backup directory: $BACKUP_DIR"
echo

# ------------------------------------------------------------------------------
# BACKUP EXISTING FILES
# ------------------------------------------------------------------------------
backup ".bashrc"
backup ".bash_profile"
backup ".tmux.conf"
backup ".ssh/config"
backup ".gitconfig"
backup ".gitignore_global"

# ------------------------------------------------------------------------------
# SYMLINK NEW FILES
# ------------------------------------------------------------------------------

# Bash
link bash/bashrc .bashrc
link bash/bash_profile .bash_profile

# tmux
link tmux/tmux.conf .tmux.conf

# SSH
mkdir -p "$HOME/.ssh"
link ssh/config .ssh/config
link ssh/hardening.conf .ssh/hardening.conf
link ssh/templates.conf .ssh/templates.conf
link ssh/agent.sh .ssh/agent.sh
chmod 600 "$HOME/.ssh/config"

# Git
link git/gitconfig .gitconfig
link git/gitignore_global .gitignore_global
mkdir -p "$HOME/.config/gh"
link git/gh.conf .config/gh/config.yml
link git/delta.conf .gitconfig_delta

# Git hooks
mkdir -p "$HOME/.git-template/hooks"
link git/hooks/pre-commit .git-template/hooks/pre-commit
chmod +x "$HOME/.git-template/hooks/pre-commit"
git config --global init.templatedir '~/.git-template'

echo
echo "Dotfiles installed successfully."
echo "Backups stored in: $BACKUP_DIR"
