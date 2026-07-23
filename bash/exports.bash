### --- PATH (cross‑platform) ---
if [[ "$OS" == "mac" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
