### --- COMPLETION SYSTEM ---
autoload -Uz compinit
compinit

### --- KUBECTL COMPLETION ---
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

### --- DOCKER COMPLETION ---
if command -v docker >/dev/null 2>&1; then
  source <(docker completion zsh)
fi
