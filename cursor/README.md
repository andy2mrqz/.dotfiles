# cursor

## Setup

```sh
ln -sf ~/Projects/.dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf ~/Projects/.dotfiles/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
cat ~/Projects/.dotfiles/cursor/extensions.txt | xargs -L 1 cursor --install-extension
```
