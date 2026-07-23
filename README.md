
📦 Bashir’s Dotfiles
Cross‑platform (macOS + Linux) dotfiles for Zsh, Bash, Neovim, Tmux, and CLI tooling — designed for Cloud Engineering, DevOps, and daily productivity.

This repository provides:

Modular Zsh + Bash configuration

Full Neovim setup (LSP, Treesitter, Telescope, lazy.nvim)

Tmux configuration with TPM

Cross‑platform bootstrap installer

Update, uninstall, and health‑check scripts

Clean symlink‑based architecture

macOS + Linux compatibility

🚀 Features
✔ Modular Zsh configuration
Code
zsh/
├── zshrc
├── aliases.zsh
├── exports.zsh
├── functions.zsh
├── prompt.zsh
├── plugins.zsh
└── completion.zsh
✔ Modular Bash configuration
Code
bash/
└── bashrc
✔ Full Neovim setup
lazy.nvim plugin manager

LSP servers

Treesitter

Telescope (with cross‑platform ripgrep config)

Lua‑based config

✔ Tmux configuration
TPM plugin manager

Cross‑platform settings

✔ Scripts included
Code
bootstrap.sh      → Full machine setup (macOS + Linux)
install.sh        → Symlink dotfiles + install plugin managers
update.sh         → Pull latest + refresh symlinks + update plugins
uninstall.sh      → Remove symlinks + restore backups + clean plugins
health-check.sh   → Verify full environment health
📁 Repository Structure
Code
dotfiles/
├── bash/
│   └── bashrc
├── zsh/
│   ├── zshrc
│   ├── aliases.zsh
│   ├── exports.zsh
│   ├── functions.zsh
│   ├── prompt.zsh
│   ├── plugins.zsh
│   └── completion.zsh
├── nvim/
│   ├── init.lua
│   └── lua/
│       ├── core/
│       └── plugins/
├── tmux/
│   └── tmux.conf
├── bootstrap.sh
├── install.sh
├── update.sh
├── uninstall.sh
├── health-check.sh
└── README.md
🧰 Installation (New Machine)
Clone the repo:

bash
git clone https://github.com/bashirawaty/dotfiles ~/.dotfiles
cd ~/.dotfiles
Make scripts executable (only needed if not already committed with +x):

bash
chmod +x bootstrap.sh install.sh update.sh uninstall.sh health-check.sh
Run bootstrap:

bash
./bootstrap.sh
This installs:

Zsh

Neovim

Tmux

Ripgrep, fd, fzf

Homebrew (macOS)

Package manager dependencies (Linux)

Symlinks for all dotfiles

Plugin managers (zinit, TPM, lazy.nvim)

🔐 Do I Need Root?
✔ Cloning the repo → NO root needed
✔ Running bootstrap.sh → NO root needed
✔ Script will ask for sudo automatically when required
The bootstrap script performs system‑level installs:

apt install, dnf install, pacman -Sy → require sudo

Adding Zsh to /etc/shells → requires sudo

Changing default shell (chsh) → may require sudo

Homebrew on macOS → does not require sudo

You should not run the entire script with sudo:

bash
sudo ./bootstrap.sh   # ❌ Do NOT do this
Your dotfiles, symlinks, plugins, and Neovim configuration must install into your user’s home directory, not root’s.

🔗 Symlink Architecture
The installer creates symlinks:

Code
~/.zshrc        → ~/.dotfiles/zsh/zshrc
~/.bashrc       → ~/.dotfiles/bash/bashrc
~/.tmux.conf    → ~/.dotfiles/tmux/tmux.conf
~/.config/nvim/ → ~/.dotfiles/nvim/
Backups are automatically created:

Code
~/.zshrc.backup-YYYY-MM-DD-HH-MM
🔄 Updating Dotfiles
bash
./update.sh
This:

Pulls latest from GitHub

Refreshes symlinks

Updates zinit, TPM, lazy.nvim

Works on macOS + Linux

🗑 Uninstalling Dotfiles
bash
./uninstall.sh
This:

Removes symlinks

Restores backups

Removes plugin managers

Cleans Neovim cache

🩺 Health Check
bash
./health-check.sh
Checks:

Core binaries

Cloud tools

Symlinks

Backups

Zinit / TPM / lazy.nvim

Neovim LSP servers

Default shell

PATH correctness

🧠 Philosophy
This dotfiles setup is built for:

Cloud Engineering

DevOps

Linux + macOS parity

Fast terminal workflows

Clean modular configuration

Zero‑risk symlink management

Full reproducibility across machines

📜 License
GPL‑3.0
See LICENSE for details.
