# macos installation tips

## Setup

A few loose notes while setting up a new MBP

### homebrew packages

- bitwarden chrome docker imagemagick jq maccy obsidian postman ripgrep slack tmux tree
- nightly neovim
```sh
  brew install --HEAD neovim
```
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
