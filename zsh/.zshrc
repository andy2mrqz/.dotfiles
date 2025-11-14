#-----------------------------------------------------------
# Shellcheck configuration
#-----------------------------------------------------------

# shellcheck disable=2034   # [...] appears unused. Verify use (or export if used externally).
# shellcheck disable=2154   # [...] is referenced but not assigned.
# shellcheck disable=2168   # 'local' is only valid in functions.

#-----------------------------------------------------------
# General configuration
#-----------------------------------------------------------

typeset -U PATH                   # Ensure uniqueness within the PATH env variable
unsetopt BEEP                     # Turn off all beeps

#-----------------------------------------------------------
# Environment
#-----------------------------------------------------------

# PATH is defined in ~/.zprofile

export ZSH="$HOME/.zsh.d"                   # Add zsh-specific directory for configuration files
export EDITOR="nvim"                        # Set editor to neovim
export KEYTIMEOUT=1                         # Reduce delay for key combinations in order to change to vi mode faster
export HOMEBREW_NO_AUTO_UPDATE=1            # Don't update homebrew on every package install
export EZA_CONFIG_DIR="$HOME/.config/eza"   # Add config directory for eza (ls replacement)
export XDG_CONFIG_HOME="$HOME/.config"

# Export common dumps to places better than $HOME
[ -d "$HOME/.cache" ] || mkdir -p "$HOME/.cache"
export LESSHISTFILE="$HOME/.cache/.lesshst"

#-----------------------------------------------------------
# Keybindings
#-----------------------------------------------------------

bindkey -v                                                  # vim keybindings
autoload -U edit-command-line && zle -N edit-command-line   # enable line editing with vim

bindkey '^R' history-incremental-search-backward  # history search

bindkey '^[[A' history-substring-search-up        # substring history search (from plugin)
bindkey '^[[B' history-substring-search-down      # substring history search (from plugin)

#-----------------------------------------------------------
# History
#-----------------------------------------------------------

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

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
# Functions
#-----------------------------------------------------------

gmbd() {
    curr=$(git symbolic-ref --short HEAD)
    (git checkout main || git checkout master) && git pull && git branch -d "$curr"
    git remote prune origin
    unset curr
}

awslogin() {
  # shellcheck disable=1091
  source "$HOME/bin/_awslogin" "$1"
}


statsize() {
  for file in "$@"; do
    # get the human‑readable size, measuring apparent-size in bytes
    human=$(gdu -bh "$file" 2>/dev/null | cut -f1)
    # get the raw byte count
    bytes=$(stat -f%z -- "$file" 2>/dev/null)
    # print them plus the filename
    printf "%s %s %s\n" "$human" "$bytes" "$file"
  done
}


ssm-get-parameter() {
  aws ssm get-parameter --name "$1" --with-decryption --query "Parameter" | jq -r '.Value'
}

#-----------------------------------------------------------
# Completion
#-----------------------------------------------------------

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi

# Completion plugins
# Manually compile completion plugins
#   mise completion                zsh  > $ZSH/site-functions/_mise
#   gh completion -s               zsh  > $ZSH/site-functions/_gh
#   docker completion              zsh  > $ZSH/site-functions/_docker
#   poetry completions             zsh  > $ZSH/site-functions/_poetry
#   ruff generate-shell-completion zsh  > $ZSH/site-functions/_ruff
FPATH="$ZSH/site-functions:$FPATH"

# Load and initialize the completion system
autoload -Uz compinit && compinit -C -d "$ZSH/cache/.zcompdump"

unsetopt flowcontrol      # Disable use of ctrl-s and ctrl-q for flow control
setopt auto_menu          # Show completion menu on successive tab press
setopt complete_in_word   # Allow completion within a word, not just at the end
setopt always_to_end      # Move cursor to the end of a completed word
setopt auto_pushd         # Automatically push directories onto the directory stack

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case-insensitive completion

#-----------------------------------------------------------
# Aliases
#-----------------------------------------------------------

alias ls="eza"
alias ll="eza -l"
alias sz="exec zsh" # "source ~/.zshrc" -- this is the WRONG way (https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load.html)
alias vz="vim ~/Projects/.dotfiles/zsh/.zshrc"
alias vim="nvim"
alias pk="kill -9"
alias vimdiff="nvim -d"
alias cloc="scc"
alias vimg="vim -c 'NvimTreeToggle' -c 'G' -c '1000'" # open with git mode on and go to the last line (1000)
alias zdots="z .dotfiles"

# Obsidian notes
alias todo="(cd ~/vault && vim Notes/personal-todo.md -c 'NvimTreeToggle' -c 'wincmd l' -c 'NvimTreeFindFile' -c 'wincmd l')"
alias jo="journal"

# Poetry
alias sp="
  source \$(poetry env info --path 2>/dev/null)/bin/activate &>/dev/null ||
  source venv/bin/activate &>/dev/null ||
  (echo 'sp: failed to activate virtualenv!' && return 1)
"
alias prp="poetry run python"
alias prs="poetry run start"

# Git aliases
alias G="git"
alias gco="git checkout"
alias gmo="git merge origin/main 2>/dev/null || git merge origin/master"
alias gfollow="git log --follow -p"
alias gsp="git stash pop"
alias gsl="git stash list"
alias gitcs="git log -n 1 --pretty=format:%H | tee >(pbcopy)"
alias gb="git branch --sort=-committerdate --format='%(HEAD) %(if)%(HEAD)%(then)%(color:green)%(end)%(refname:short) | %(committerdate:relative)'"
alias gbd="git branch -D"

# Run github copilot cli
alias how="brain --new"

alias code="/Applications/Visual\ Studio\ Code\ -\ Insiders.app/Contents/Resources/app/bin/code"

#-----------------------------------------------------------
# Prompt
#-----------------------------------------------------------

setopt prompt_subst       # Docs: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html

git_prompt_info() {
  local dirstatus="%B%F{green}✓%b%f"
  local dirty="%B%F{yellow}✗%b%f"

  if [[ -n $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
    dirstatus=$dirty
  fi

  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return

  echo " %B%F{blue}git:(%F{red}${ref#refs/heads/}%F{blue}) ${dirstatus}%f%b"
}

local exit_code_indicator="%B%(?.%F{green}%1{➜%}.%F{red}%1{➜%}) %b%f"
local dir_info="%B%F{cyan}%c%b%f"

# shellcheck disable=2016
# Enclose in single quotes since it is evaluated for each prompt - double quotes evaluates once
PROMPT='${exit_code_indicator} ${dir_info}$(git_prompt_info) '

#-----------------------------------------------------------
# Plugins
#-----------------------------------------------------------

# shellcheck disable=1091
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# shellcheck disable=1091
source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
# shellcheck disable=1091
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# shellcheck disable=1091
source "$HOMEBREW_PREFIX/etc/profile.d/z.sh"

# pnpm
export PNPM_HOME="/Users/andrewmarquez/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/Users/andrewmarquez/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/andrewmarquez/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="/Users/andrewmarquez/bin:$PATH"
