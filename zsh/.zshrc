# shellcheck disable=SC2034
zmodload zsh/zprof

# Add to PATH
PRE_PATH=$(tr -d $'\n[:blank:]' <<< "
  $HOME/bin:
  /usr/local/bin:
  /usr/local/sbin:
  $HOME/.emacs.d/bin:
  $HOME/.yarn/bin:
  $HOME/.config/yarn/global/node_modules/.bin:
  $HOME/.local/share/rtx/shims:
  $HOME/.local/bin:
  /opt/homebrew/opt/libiodbc/bin:
  /Applications/Postgres.app/Contents/Versions/latest/bin:
")
export PATH="$PRE_PATH$PATH"
#
# This runs `rtx env` to update the PATH and get things working
eval "$(rtx activate zsh)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Random options
HYPHEN_INSENSITIVE="true"
# - Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true
# - Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# - Unique history
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"
# - Async mode for zsh autosuggestions, and disabling automatic widget re-binding
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_AUTOSUGGEST_MANUAL_REBIND="true"

# Don't update homebrew on every package install
export HOMEBREW_NO_AUTO_UPDATE=1

# - Which plugins would you like to load?
plugins=(
    git
    git-open
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
)

# shellcheck disable=SC1091
source "$ZSH/oh-my-zsh.sh"

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias copy="pbcopy <"
alias sz="exec zsh" # "source ~/.zshrc" -- this is the WRONG way (https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load.html)
alias vim="nvim"
alias repl="lein repl :connect"
alias pk="kill -9"
alias gco="git checkout"
alias gfollow="git log --follow -p"
alias ts-swc="ts-node --swc"
alias vimdiff="nvim -d"
alias awsp="source _awsp"
alias sbcl="rlwrap sbcl" # common lisp

git_change_personal_email_to_work_email() {
  git config --local user.email "andrew.marquez@taxbit.com"
  git filter-repo --force --email-callback "return email if email != b'andy2mgcc@gmail.com' else b'andrew.marquez@taxbit.com'"
}

git_change_work_email_to_personal_email() {
  git config --local user.email "andy2mgcc@gmail.com"
  git filter-repo --force --email-callback "return email if email != b'andrew.marquez@taxbit.com' else b'andy2mgcc@gmail.com'"
}

gmbd() {
    curr=$(git symbolic-ref --short HEAD)
    (git checkout master || git checkout main) && git pull && git branch -d "$curr"
    git remote prune origin
    unset curr
}

searchcomponent() {
  # $1 -> componentName
  # $2 -> propName
  rg -nU "<$1(.|\n)*?/>" src/**/* | rg "$2=" | uniq | rg "$2="
}

awslogin() {
  # $1 -> profileName
  if ! aws sts get-caller-identity --profile "$1" >/dev/null 2>&1; then
    echo "Logging in with profile: $1"
    if ! aws sso login --profile "$1"; then
      echo "SSO login failed"
      return 1
    fi
  fi
  local export_output
  if export_output=$(aws configure export-credentials --profile "$1" --format env 2>/dev/null); then
    eval "$export_output"
    echo "AWS environment variables exported"
  else
    echo "Failed to export AWS environment variables"
    return 1
  fi
}

# vim mode
bindkey -v

# allow enter in terminal
stty sane

# Helps so that `git branch` doesn't use less if content can be viewed on one screen
# See here: https://stackoverflow.com/a/60498979
export LESS="-FRX"

#
# Export common dumps to better places than $HOME
#

mkdir -p "$HOME/.cache"
export LESSHISTFILE=$HOME/.cache/.lesshst
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

SAM_CLI_TELEMETRY=0
