#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

link() {
  src="$DOTFILES/$1"
  dest="$HOME/$2"

  echo "Linking $src → $dest"
  ln -sf "$src" "$dest"
}

# bash
link bash/bashrc .bashrc
link bash/bash_profile .bash_profile

# tmux
link tmux/tmux.conf .tmux.conf

echo "Dotfiles installed."
