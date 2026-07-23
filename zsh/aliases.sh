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
alias ..='cd ..'
alias ...='cd ../..'

### --- GIT ---
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

### --- KUBERNETES ---
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kga='kubectl get all'
alias kgn='kubectl get nodes'
alias kctx='kubectl config current-context'

### --- DOCKER ---
alias d='docker'
alias dc='docker compose'
alias di='docker images'
alias dp='docker ps'

### --- TERRAFORM ---
alias tf='terraform'
alias tfa='terraform apply -auto-approve'
alias tfi='terraform init'
alias tfp='terraform plan'

### --- ANSIBLE ---
alias ans='ansible'
alias ansp='ansible-playbook'
alias ansi='ansible-inventory --graph'

### --- SYSTEM (Cross‑Platform) ---
if [[ "$OS" == "mac" ]]; then
    alias mem='vm_stat'                     # macOS equivalent of free -h
    alias cpu='sysctl -a | grep machdep.cpu' # macOS equivalent of lscpu
    alias ports='netstat -an'               # macOS equivalent of ss
else
    alias mem='free -h'
    alias cpu='lscpu'
    alias ports='ss -tulwn'
fi
