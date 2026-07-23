### --- STARSHIP PROMPT ---
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  return
fi

### --- PURE PROMPT (fallback) ---
autoload -Uz promptinit
promptinit
prompt pure
