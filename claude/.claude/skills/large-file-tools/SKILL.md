---
name: large-file-tools
description: Tools for working with large files (1GB+) without running out of memory. Use when processing JSON dumps, log files, or any file too large for JSON.parse/json.load.
---

# Large File Tools

This machine has 36GB RAM. Files in ~/Projects/pxm-db/data/ can be 50-100GB+. NEVER load them into memory with JSON.parse(), json.load(), or similar. Use these streaming tools instead.

## snip — Extract bytes around a pattern match

Location: `~/bin/snip`

Finds a regex match in a file using ripgrep (streaming, no memory issues), then extracts N bytes starting from the match offset using `dd`.

```bash
# Basic: find pattern and extract 1000 bytes around it
snip 'PATTERN' -f FILE

# Extract 2000 bytes from the 3rd match
snip '"file_size".*kB' -f data/staging/tbl_File.json -b 2000 -m 3

# Find a specific record by ID and see its full JSON
snip '"id":"abc123-uuid"' -f data/tbl_Topic.json -b 5000
```

Options:
- `-f, --file FILE` — file to search (required)
- `-b, --bytes N` — bytes to extract (default: 1000)
- `-m, --match N` — which match to use, 1-based (default: 1)

## statsize — Human + raw byte file sizes

Location: shell function (defined in .zshrc)

```bash
# Single file
statsize data/staging/tbl_Topic.json
# Output: 55G 59055800320 data/staging/tbl_Topic.json

# Multiple files / globs
statsize data/staging/rethinkdb_dump_*/amp_db/tbl_*.json
```

## key-presence (Rust, SIMD) — JSON field analysis

Location: `~/Projects/key-presence/target/release/key-presence` (symlinked to `~/bin/key-presence`)

SIMD-accelerated (memchr/NEON on Apple Silicon). Processes 100GB+ JSON files at 1.4 GB/s. Build: `cargo build --release --manifest-path ~/Projects/key-presence/Cargo.toml`

```bash
KP=~/bin/key-presence

# Stats mode: count field presence across all records
$KP data/tbl_Topic.json
# Output: field_name  count  percentage

# Column mode: sample values for a specific field
$KP --column attributes --example-count 5 data/tbl_Topic.json

# Verbose: full records containing a field
$KP --column rare_field --verbose data/tbl_Topic.json

# Missing: full records NOT containing a field
$KP --column expected_field --missing data/tbl_Topic.json
```

## General Rules

1. Check file size FIRST with `statsize` before deciding approach
2. Files < 500MB: `jq`, `python3`, `node` are fine
3. Files 500MB-5GB: Use `jq --stream`, `rg`, `snip`
4. Files > 5GB: Use `key-presence` (Rust tool), `rg`, `snip`, or custom streaming code
5. NEVER use `cat file.json | python3 -c "import json; json.load(sys.stdin)"` on large files
6. For ETL/data loading: always use streaming parsers (stream-json in Node, jq --stream in shell)
