#!/usr/bin/env bash
# Lists every skill in the repo with its description.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

shopt -s nullglob
for skill_md in "$REPO"/skills/*/SKILL.md; do
  name="$(basename "$(dirname "$skill_md")")"
  desc="$(sed -n 's/^description: //p' "$skill_md" | head -1)"
  printf '%-24s %s\n' "$name" "$desc"
done
