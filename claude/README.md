# Claude Code

Configuration for [Claude Code](https://claude.ai/code).

## Setup

```bash
ln -sf ~/Projects/.dotfiles/claude/.claude/settings.json ~/.claude/settings.json
ln -sf ~/Projects/.dotfiles/claude/.claude/keybindings.json ~/.claude/keybindings.json
ln -sf ~/Projects/.dotfiles/claude/.claude/statusline-command.sh ~/.claude/statusline-command.sh

# Skills (symlink each individually — directory symlinks are not followed)
mkdir -p ~/.claude/skills
ln -sf ~/Projects/.dotfiles/claude/.claude/skills/agent-browser ~/.claude/skills/agent-browser
```

## Notes

- `settings.local.json` is intentionally NOT tracked — it contains machine-specific permissions.
- Project-level configs (per-repo `CLAUDE.md`, memory, sessions) live in `~/.claude/projects/` and are not tracked here.
