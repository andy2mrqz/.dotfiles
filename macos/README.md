# macos installation tips

## Setup

A few loose notes while setting up a new MBP

### homebrew packages

- bitwarden
- chrome
- docker
- emacs (optionally --with-no-titlebar)
```sh
  brew tap d12frosted/emacs-plus
  brew install emacs-plus --with-native-comp
```
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
- slack
- tmux
- tree

### other

- setup new ssh key, [add to github](https://github.com/settings/keys)
- get bitwarden extension setup
- clone and setup [dotfiles](https://github.com/andy2mrqz/.dotfiles)
  - don't forget to set git config --local to personal
