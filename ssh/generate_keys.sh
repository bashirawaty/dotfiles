#!/usr/bin/env bash
# Generate secure SSH keys (ED25519 + RSA fallback)

set -e

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

echo "Generating ED25519 key (recommended)..."
ssh-keygen -t ed25519 -a 100 -f "$HOME/.ssh/id_ed25519" -C "bashir@$(hostname)"

echo "Generating RSA key (fallback for legacy systems)..."
ssh-keygen -t rsa -b 4096 -o -a 100 -f "$HOME/.ssh/id_rsa" -C "bashir@$(hostname)"

echo "SSH keys generated."
