# macos installation

## Setup

A few loose notes while setting up a new MBP

### homebrew packages / aws development

See the script ./setup.sh for details.

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
