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

# START eval "$(mise activate zsh)"
# shellcheck disable=2199,2206,2300
{ 
  export MISE_SHELL=zsh
  export __MISE_ORIG_PATH="$PATH"

  mise() {
    local command
    command="${1:-}"
    if [ "$#" = 0 ]; then
      command /Users/andrewmarquez/.local/bin/mise
      return
    fi
    shift

    case "$command" in
    deactivate|s|shell)
      # if argv doesn't contains -h,--help
      if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
        eval "$(command /Users/andrewmarquez/.local/bin/mise "$command" "$@")"
        return $?
      fi
      ;;
    esac
    command /Users/andrewmarquez/.local/bin/mise "$command" "$@"
  }

  _mise_hook() {
    eval "$(/Users/andrewmarquez/.local/bin/mise hook-env -s zsh)";
  }
  typeset -ag precmd_functions;
  if [[ -z "${precmd_functions[(r)_mise_hook]+1}" ]]; then
    precmd_functions=( _mise_hook ${precmd_functions[@]} )
  fi
  typeset -ag chpwd_functions;
  if [[ -z "${chpwd_functions[(r)_mise_hook]+1}" ]]; then
    chpwd_functions=( _mise_hook ${chpwd_functions[@]} )
  fi

  if [ -z "${_mise_cmd_not_found:-}" ]; then
      _mise_cmd_not_found=1
      [ -n "$(declare -f command_not_found_handler)" ] && eval "${$(declare -f command_not_found_handler)/command_not_found_handler/_command_not_found_handler}"

      function command_not_found_handler() {
          if /Users/andrewmarquez/.local/bin/mise hook-not-found -s zsh -- "$1"; then
            _mise_hook
            "$@"
          elif [ -n "$(declare -f _command_not_found_handler)" ]; then
              _command_not_found_handler "$@"
          else
              echo "zsh: command not found: $1" >&2
              return 127
          fi
      }
  fi
} # END
