zmodload zsh/zprof

# Add to PATH
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
PATH+=":$HOME/.emacs.d/bin"

# Path to your oh-my-zsh installation.
export ZSH="/Users/andrewmarquez/.oh-my-zsh"

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

# Make nvm faster
export NVM_LAZY_LOAD=true
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
gmbd() {
    curr=`git symbolic-ref --short HEAD`
    (git checkout master || git checkout main) && git pull && git branch -d ${curr}
    unset curr
}
# See if this works with new SSO
# ssm() {
#     profile=${2-legacy}
#     targetId=$(aws ec2 describe-instances --profile $profile --filters "Name=tag:Name,Values=$1" \
#   --output text --query 'Reservations[*].Instances[*].InstanceId')
#     if [ -z $targetId ]; then
#         echo 'No instance found by that name'
#     else
#         aws ssm start-session --target $targetId --profile $profile
#     fi
# }

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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

#
# Export common dumps to better places than $HOME
#

mkdir -p $HOME/.cache
export LESSHISTFILE=$HOME/.cache/.lesshst
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST


