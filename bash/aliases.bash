### --- OS Detection ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    export OS="mac"
else
    export OS="linux"
fi

### --- GENERAL ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

### --- SYSTEM (cross‑platform) ---
if [[ "$OS" == "mac" ]]; then
    alias cpu='sysctl -a | grep machdep.cpu'
    alias ports='netstat -an'
else
    alias cpu='lscpu'
    alias ports='ss -tulwn'
fi

### --- GIT ---
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

### --- CLOUD TOOLS ---
alias k='kubectl'
alias d='docker'
alias tf='terraform'
alias ans='ansible'
