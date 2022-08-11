# doom emacs

## Setup

- Install emacs
```sh
  brew install emacs-plus --with-native-comp
```
- Install doom emacs (and add bin in cloned repo to PATH)
```sh
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
  doom install
```
- Link dotfiles and sync
```sh
  ln -s ~/Projects/.dotfiles/doomemacs/.doom.d .doom.d
  doom sync
```
