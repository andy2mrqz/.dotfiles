# User Preferences

## Large File Handling

Avoid using `python3` or `node` to load large files (>1GB) into memory. This
machine has 36GB RAM and files can be 50-100GB+.

Instead, use streaming tools:

- **Grep tool** (ripgrep): For pattern matching in large files
- **`snip`** (`~/bin/snip`): Extract bytes around a regex match in any file.
  Uses rg for matching + dd for extraction. Example:
  `snip '"file_size".*kB' -f bigfile.json -b 2000`
- **`statsize`** (shell function): Show human-readable + raw byte size for
  files. Example: `statsize *.json`
- **Rust key-presence tool** (`~/Projects/key-presence/target/release/key-presence`):
  SIMD-accelerated JSON field analysis. Handles 100GB+ files at 1.4 GB/s. Modes:
  stats, `--column`, `--verbose`, `--missing`. Run `key-presence --help` for usage.

For JSON specifically: use `jq --stream` or the Rust key-presence tool, never
`json.load()` or `JSON.parse()` on files over ~500MB.

For detailed usage, size thresholds, and examples: read `~/.claude/docs/large-file-tools.md`

## Work-Specific Config

Work-specific settings (AWS profiles, account IDs, internal endpoints) are in
`~/.claude/work.md`. Read that file when you need AWS auth or
company-specific context.

## Tool Preferences

- Prefer `rg` (ripgrep) over `grep` — always
- Prefer the Grep tool over Bash grep — it has proper permissions and access
- Use `statsize` to check file sizes before deciding how to process them
- Use `snip` to extract targeted byte slices from large files instead of loading
  them
- Always run `shellcheck` on bash/sh scripts after writing or editing them
