# brew

Declarative Homebrew setup via
[Brewfile](https://github.com/Homebrew/homebrew-bundle).

## New machine setup

```sh
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install everything in the Brewfile
brew bundle install --file=~/Projects/.dotfiles/brew/Brewfile

# Install neovim nightly (not in Brewfile — requires --HEAD)
brew install --HEAD neovim

# Install mise
curl https://mise.run | sh
```

## Maintenance

```sh
# Check what's in the Brewfile but not installed
brew bundle check --file=~/Projects/.dotfiles/brew/Brewfile

# Install missing items
brew bundle install --file=~/Projects/.dotfiles/brew/Brewfile

# See what's installed but NOT in the Brewfile
brew bundle cleanup --file=~/Projects/.dotfiles/brew/Brewfile

# Actually uninstall things not in the Brewfile (careful!)
brew bundle cleanup --force --file=~/Projects/.dotfiles/brew/Brewfile
```

## Notes

- The "Other Package Managers" section (go, cargo, uv) is for reference only —
  `brew bundle` won't install those unless the respective tools are available.
- `macos/setup.sh` is the older install script. This Brewfile supersedes its
  package installation sections.
