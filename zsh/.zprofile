[[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# # PATH updates
export PATH="$HOME/bin:$PATH"                       # personal scripts
export PATH="$HOME/.local/bin:$PATH"                # some scripts get installed here (mise, poetry)
export PATH="$HOME/.local/share/mise/shims:$PATH"   # Add mise shims to PATH
export PATH="$HOME/.rd/bin:$PATH"                   # Add rancher desktop binaries (docker, docker-compose)
eval "$(mise activate zsh)"                         # Activate mise within PATH; must come after shims

