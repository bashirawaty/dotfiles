### --- KUBECTL COMPLETION ---
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
fi

### --- DOCKER COMPLETION ---
if command -v docker >/dev/null 2>&1; then
    source <(docker completion bash)
fi
