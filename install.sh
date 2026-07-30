#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# install.sh — symlink installer for dotfiles.
# Creates ~/.bashrc, ~/.bash_profile, ~/.tmux.conf from repo files.
# ------------------------------------------------------------------------------

set -e

DOTFILES="$HOME/dotfiles"

link() {
  src="$DOTFILES/$1"
  dest="$HOME/$2"

  echo "Linking $src → $dest"
  ln -sf "$src" "$dest"
}

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


echo "Dotfiles installed successfully."
