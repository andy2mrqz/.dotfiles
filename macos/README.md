# macos installation tips

## Setup

A few loose notes while setting up a new MBP

### homebrew packages

- bat
- bitwarden
- bitwarden-cli
- chrome
- docker
- fd (better find, written in rust)
- font setup
```sh
  brew tap homebrew/cask-fonts
  brew install --cask font-meslo-lg-nerd-font
```
- git-delta
- golang
- hugo
- imagemagick
- jq
- neovim (nightly)
```sh
  brew install --HEAD neovim
```
- obsidian
- postman
- raindropio (bookmark keeper)
- raycast (spotlight alternative)
- ripgrep
- shellcheck
- shfmt
- slack
- stylua
- tmux
- tree

### AWS Development

- brew install awscli
- brew tap aws/tap
  - brew install aws-sam-cli
- brew install --cask docker
- brew install --cask session-manager-plugin
- sudo pip3 install aws-ssm-tools

#### Clojure Development

- leiningen (installs openjdk at the same time)
- borkdude/brew/clj-kondo
- emacs (optionally --with-no-titlebar)
```sh
  brew tap d12frosted/emacs-plus
  brew install emacs-plus --with-native-comp
```

### other

- setup new ssh key, [add to github](https://github.com/settings/keys)
- get bitwarden extension setup
- clone and setup [dotfiles](https://github.com/andy2mrqz/.dotfiles)
  - don't forget to set git config --local to personal
