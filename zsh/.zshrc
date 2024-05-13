# shellcheck disable=SC2034
zmodload zsh/zprof

# Add to PATH
PRE_PATH=$(tr -d $'\n[:blank:]' <<< "
  $HOME/bin:
  /usr/local/bin:
  /usr/local/sbin:
  $HOME/.emacs.d/bin:
  $HOME/.local/share/mise/shims:
  $HOME/.local/bin:
  /opt/homebrew/opt/libiodbc/bin:
  /Applications/Postgres.app/Contents/Versions/latest/bin:
")
export PATH="$PRE_PATH$PATH"

# This runs `mise env` to update the PATH and get things working
eval "$(mise activate zsh)"

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

export EDITOR='nvim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias copy="pbcopy <"
alias sz="exec zsh" # "source ~/.zshrc" -- this is the WRONG way (https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load.html)
alias vz="vim ~/.zshrc"
alias ex="vim -e"
alias vim="nvim"
alias repl="lein repl :connect"
alias pk="kill -9"
alias ts-swc="ts-node --swc"
alias vimdiff="nvim -d"
alias awsp="source _awsp"
alias sbcl="rlwrap sbcl" # common lisp
alias vimg="vim -c 'NvimTreeToggle' -c 'G' -c '1000'" # open with git mode on and go to the last line (1000)
alias vimv="cd ~/vault && vim Notes/personal-todo.md -c 'NvimTreeToggle' -c 'wincmd l' -c 'NvimTreeFindFile' -c 'wincmd l'" # open vault notes

# Poetry
alias sp="source \$(poetry env info --path)/bin/activate"
alias prp="poetry run python"
alias prs="poetry run start"

# Git aliases
alias gco="git checkout"
alias gmo="git merge origin/main 2>/dev/null || git merge origin/master"
alias gfollow="git log --follow -p"
alias gsp="git stash pop"

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
compinit -d "$ZSH/cache"

SAM_CLI_TELEMETRY=0
