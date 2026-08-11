#!/usr/bin/env bash
# Symlinks every skill in this repo into the local harness skill directories,
# so a `git pull` is enough to keep the installed copies current.
#   ~/.claude/skills - Claude Code
#   ~/.agents/skills - Codex and other Agent Skills-compatible harnesses
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

shopt -s nullglob
for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"
  for skill_md in "$REPO"/skills/*/SKILL.md; do
    src="$(dirname "$skill_md")"
    name="$(basename "$src")"
    target="$dest/$name"

    # Replace a previous link, but never clobber a real directory this repo
    # did not create.
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skipped $name - $target exists and is not a symlink" >&2
      continue
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $target"
  done
done
