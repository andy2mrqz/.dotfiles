#-----------------------------------------------------------
# Shellcheck configuration
#-----------------------------------------------------------

# shellcheck disable=2034   # disables check for unused variables

#-----------------------------------------------------------
# General configuration
#-----------------------------------------------------------

typeset -U PATH                   # Ensure uniqueness within the PATH env variable
autoload colors; colors;          # Ensure color support is loaded for the terminal
export HOMEBREW_NO_AUTO_UPDATE=1  # Don't update homebrew on every package install
export ZSH="$HOME/.zsh.d"         # Add zsh-specific directory for configuration files

# Export common dumps to places better than $HOME
[ -d "$HOME/.cache" ] || mkdir -p "$HOME/.cache"
export LESSHISTFILE=$HOME/.cache/.lesshst

#-----------------------------------------------------------
# Keybindings
#-----------------------------------------------------------

bindkey -v                                        # vim keybindings
bindkey '^R' history-incremental-search-backward  # history search

#-----------------------------------------------------------
# History
#-----------------------------------------------------------

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.


#-----------------------------------------------------------
# Completion
#-----------------------------------------------------------

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit 
export ZSH_CACHEDIR="$ZSH/cache"
export ZSH_COMPDUMP="$ZSH_CACHEDIR/.zcompdump"

# Speed up completion init, see: https://gist.github.com/ctechols/ca1035271ad134841284
# compinit -d "$ZSH_CACHEDIR"
# for dump in "$ZSH_COMPDUMP"(N.mh+24); do
#   compinit
# done
# compinit -C

unsetopt flowcontrol      # Disable use of ctrl-s and ctrl-q for flow control
setopt auto_menu          # Show completion menu on successive tab press
setopt complete_in_word   # Allow completion within a word, not just at the end
setopt always_to_end      # Move cursor to the end of a completed word
setopt auto_pushd         # Automatically push directories onto the directory stack

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case-insensitive completion

#-----------------------------------------------------------
# Aliases
#-----------------------------------------------------------

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

#-----------------------------------------------------------
# Functions
#-----------------------------------------------------------

gmbd() {
    curr=$(git symbolic-ref --short HEAD)
    (git checkout master || git checkout main) && git pull && git branch -d "$curr"
    git remote prune origin
    unset curr
}

awslogin() {
  # shellcheck disable=1091
  source "$HOME/bin/_awslogin" "$1"
}
