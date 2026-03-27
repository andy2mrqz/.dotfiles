# START eval "$(/opt/homebrew/bin/brew shellenv)"
# shellcheck disable=2034
{
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
} # END

# PATH updates
export PATH="$HOME/bin:$PATH"                       # personal scripts
export PATH="$HOME/bin/nogitsync:$PATH"             # personal scripts
export PATH="$HOME/.local/bin:$PATH"                # some scripts get installed here (mise, poetry)
export PATH="$HOME/.rd/bin:$PATH"                   # Add rancher desktop binaries (docker, docker-compose)
export PATH="$HOME/Projects/ziglang:$PATH"          # ziglang binaries
export PATH="$HOME/Projects/zls/zig-out/bin:$PATH"  # zls (zig language server) binaries

# START eval "$(mise activate zsh --shims)"
export PATH="/Users/andrewmarquez/.local/share/mise/shims:$PATH"
# END

export PATH="/Users/andrewmarquez/bin:$PATH"
