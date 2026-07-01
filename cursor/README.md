# cursor

## Setup

```sh
ln -sf ~/Projects/.dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf ~/Projects/.dotfiles/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -sf ~/Projects/.dotfiles/claude/.claude/statusline-command.sh ~/.cursor/statusline-command.sh
cat ~/Projects/.dotfiles/cursor/extensions.txt | xargs -L 1 cursor --install-extension
```

Add to `~/.config/cursor/cli-config.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash /Users/andrewmarquez/.cursor/statusline-command.sh"
}
```

Restart the `agent` CLI after changing config. The statusline script is shared with Claude Code (same dotfiles source).
