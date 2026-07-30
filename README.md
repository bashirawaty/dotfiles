# Dotfiles

Cross‑platform dotfiles for **Linux (Ubuntu, RHEL, Fedora)** and **macOS**, featuring:

- Modern Bash configuration  
- Tmux setup with mouse + clipboard support  
- Secure SSH configuration with hardening + agent auto‑start  
- Git configuration with delta, GitHub CLI, hooks, and auto‑fetch  
- Automated installer with safe backups  
- Restore script for full rollback  

Everything is organized, modular, and easy to maintain.

---

## 📁 Folder Structure

dotfiles/
├── bash/
│   ├── bashrc
│   └── bash_profile
├── tmux/
│   └── tmux.conf
├── ssh/
│   ├── config
│   ├── hardening.conf
│   ├── templates.conf
│   ├── agent.sh
│   └── generate_keys.sh
├── git/
│   ├── gitconfig
│   ├── gitignore_global
│   ├── gh.conf
│   ├── delta.conf
│   ├── auto-fetch.sh
│   └── hooks/
│       └── pre-commit
├── install.sh
└── restore.sh


---

## 🚀 Installation

Run the installer:

```bash
cd ~/dotfiles
./install.sh
What the installer does
Creates a timestamped backup directory

Backs up existing:

~/.bashrc

~/.bash_profile

~/.tmux.conf

~/.ssh/config

~/.gitconfig

~/.gitignore_global

Symlinks your dotfiles into $HOME

Sets correct permissions (SSH)

Enables global Git hooks

Configures GitHub CLI

Installs delta diff configuration

Backups are stored in:

~/dotfiles_backup_YYYYMMDD_HHMMSS/

♻️ Restore
To restore from the most recent backup:

cd ~/dotfiles
./restore.sh

The restore script automatically:

Detects the latest backup directory

Restores all backed‑up dotfiles

Skips missing files safely
🖥️ Bash Configuration
Features:

Modern history management

OS detection (Linux/macOS)

PATH auto‑management

Smart aliases (eza/exa, navigation, safe cp/mv/rm)

Git‑aware prompt

Tmux auto‑attach

Utility functions (mkcd, extract)

Your .bashrc is fully commented and cross‑platform.

🔧 Tmux Configuration
Includes:

Mouse support

Clipboard integration (macOS pbcopy / Linux xclip)

Modern keybindings

Pane navigation + resizing

Clean status bar

Reload shortcut (prefix + r)

🔐 SSH Configuration
Includes:

Secure defaults (hardening)

Host templates

Agent auto‑start

Key generation script

Bastion / ProxyJump support

GitHub SSH integration

Files:

ssh/config

ssh/hardening.conf

ssh/templates.conf

ssh/agent.sh

ssh/generate_keys.sh

🧩 Git Configuration
Includes:

Global .gitconfig

Global .gitignore_global

GitHub CLI integration

Delta diff tool configuration

Auto‑fetch script

Global pre‑commit hook template

GitHub CLI
Configured to use SSH and vim.

Delta
Beautiful diffs with:

Syntax highlighting

Side‑by‑side view

Dracula theme

Moved line detection

Auto‑Fetch
Optional script to auto‑fetch all repos in ~/projects.

Git Hooks
Global pre‑commit hook includes:

Secret scanning

Python linting

Shell linting

JSON formatting check

🔄 Updating Dotfiles
To update dotfiles:

cd ~/dotfiles
git pull
./install.sh

🛡️ Security Notes
SSH config uses hardened defaults

Password authentication disabled

Agent forwarding disabled

Known hosts hashed

Keys stored with secure permissions

Git hooks prevent accidental secret commits

🧰 Requirements
Linux
sudo apt install tmux xclip delta gh vim flake8 shellcheck jq -y

or for RHEL/Fedora:

sudo dnf install tmux xclip git-delta gh vim flake8 shellcheck jq -y

macOS
brew install tmux xclip delta gh vim flake8 shellcheck jq

🙌 Credits
Created by Bashir Awaty  
Designed for cross‑platform engineering workflows.











