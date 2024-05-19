#!/bin/bash


if ! command -v brew &> /dev/null; then
  echo 'installing homebrew...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'installing brew casks...'

brew tap homebrew/cask-fonts

brew install --cask \
  docker \
  github \
  google-chrome \
  karabiner-elements \
  kitty \
  obsidian \
  postman \
  raindropio \
  raycast \
  slack \
  visual-studio-code


echo 'installing brew base packages...'

brew install \
  bat \
  bitwarden-cli \
  fd \
  font-meslo-lg-nerd-font \
  git-delta \
  imagemagick \
  jq \
  redis \
  ripgrep \
  shellcheck \
  shfmt \
  stylua \
  tree

echo 'installing neovim nightly...'

brew install --HEAD neovim

echo 'installing aws tooling...'

brew tap aws/tap

brew install awscli
brew install aws-sam-cli
brew install --cask session-manager-plugin
pip3 install aws-ssm-tools


if ! command -v rtx &> /dev/null; then
  echo 'installing rtx (runtime executor)...'
  brew install jdxcode/tap/rtx
  echo 'eval "$(~/bin/rtx activate zsh)"' >> ~/.zshrc
fi

if ! command -v omz &> /dev/null; then
  echo 'installing omz...'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d  "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  echo 'installing zsh-autosuggestions'
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  echo 'installing zsh-syntax-highlighting'
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi


cat << EOF

  Package installation complete 🎉

  At this point you are probably ready to create a new ssh key for github/ssh access.  Do that here: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key

EOF
