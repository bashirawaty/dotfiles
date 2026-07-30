#!/usr/bin/env bash
# Auto-start ssh-agent and load keys

SSH_ENV="$HOME/.ssh/environment"

start_agent() {
    echo "Starting ssh-agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    source "$SSH_ENV" > /dev/null
    ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null
    ssh-add "$HOME/.ssh/id_rsa" 2>/dev/null
}

if [ -f "$SSH_ENV" ]; then
    source "$SSH_ENV" > /dev/null
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null || start_agent
else
    start_agent
fi
