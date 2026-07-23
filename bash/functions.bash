### --- MAKE & CD ---
mkcd() {
    mkdir -p "$1" && cd "$1"
}

### --- QUICK SEARCH ---
f() {
    grep -R "$1" .
}

### --- KUBECTL NAMESPACE SWITCH ---
kns() {
    kubectl config set-context --current --namespace="$1"
}

### --- DOCKER CLEANUP ---
dockerclean() {
    docker system prune -af
}
