zmodload zsh/zprof

export GOPATH="$HOME/go"

# Add to PATH
PRE_PATH=$(tr -d $'\n[:blank:]' <<< "
  $HOME/bin:
  /usr/local/bin:
  /usr/local/sbin:
  $HOME/.emacs.d/bin:
  $HOME/.yarn/bin:
  $HOME/.config/yarn/global/node_modules/.bin:
  $HOME/Library/Python/3.9/bin:
")
POST_PATH=$(tr -d $'\n[:blank:]' <<< "
  $GOPATH/bin
")
export PATH="$PRE_PATH$PATH$POST_PATH"

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

#export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=true

# Don't update homebrew on every package install
export HOMEBREW_NO_AUTO_UPDATE=1

# - Which plugins would you like to load?
plugins=(
    zsh-nvm
    git
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

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
alias aws-login="yawsso auto --profile taxbit -e | yawsso decrypt | pbcopy && echo 'copied!'"
alias sbcl="rlwrap sbcl" # common lisp

git_reset_author_all_time() {
  git -c rebase.instructionFormat='%s%nexec GIT_COMMITTER_DATE="%cD" GIT_AUTHOR_DATE="%aD" git commit --amend --no-edit --reset-author' rebase -i --root
}

gmbd() {
    curr=`git symbolic-ref --short HEAD`
    (git checkout master || git checkout main) && git pull && git branch -d ${curr}
    unset curr
}

searchcomponent() {
  # $1 -> componentName
  # $2 -> propName
  rg -nU "<$1(.|\n)*?/>" src/**/* | rg "$2=" | uniq | rg "$2="
}

# vim mode
bindkey -v

# allow enter in terminal
stty sane

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

export AWS_REGION='us-east-1'

# Helps so that `git branch` doesn't use less if content can be viewed on one screen
# See here: https://stackoverflow.com/a/60498979
export LESS=-FRX

#
# Export common dumps to better places than $HOME
#

mkdir -p $HOME/.cache
export LESSHISTFILE=$HOME/.cache/.lesshst
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST


