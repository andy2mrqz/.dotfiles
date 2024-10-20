# shellcheck disable=SC2034

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

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi

# fzf
if type fzf &>/dev/null; then
  # shellcheck disable=SC1090
  source <(fzf --zsh)
fi

# shellcheck disable=SC1091
source "$ZSH/oh-my-zsh.sh"
# unset some aliases from oh-my-zsh
unalias gb

# User configuration

export EDITOR='nvim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias sz="exec zsh" # "source ~/.zshrc" -- this is the WRONG way (https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load.html)
alias vz="vim ~/.zshrc"
# alias ex="vim -e"
alias vim="nvim"
# alias repl="lein repl :connect"
alias pk="kill -9"
# alias ts-swc="ts-node --swc"
alias vimdiff="nvim -d"
# alias sbcl="rlwrap sbcl" # common lisp
alias vimg="vim -c 'NvimTreeToggle' -c 'G' -c '1000'" # open with git mode on and go to the last line (1000)
alias vimv="cd ~/vault && vim Notes/personal-todo.md -c 'NvimTreeToggle' -c 'wincmd l' -c 'NvimTreeFindFile' -c 'wincmd l'" # open vault notes

# Poetry
alias sp="source \$(poetry env info --path 2>/dev/null)/bin/activate &>/dev/null || source venv/bin/activate"
alias prp="poetry run python"
alias prs="poetry run start"

# Git aliases
alias gco="git checkout"
alias gmo="git merge origin/main 2>/dev/null || git merge origin/master"
alias gfollow="git log --follow -p"
alias gsp="git stash pop"
alias gitcs="git log -n 1 --pretty=format:%H | tee >(pbcopy)"
alias gb="git branch --sort=-committerdate"

# Run github copilot cli
alias how="gh copilot explain"

# Run snowsql
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

gmbd() {
    curr=$(git symbolic-ref --short HEAD)
    (git checkout master || git checkout main) && git pull && git branch -d "$curr"
    git remote prune origin
    unset curr
}

awslogin() {
  source "$HOME/bin/_awslogin" "$1"
}

# vim mode
bindkey -v
bindkey '^R' history-incremental-search-backward

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
