#!/usr/bin/env bash
# Scaffolds a new skill from templates/SKILL.md and registers it in the plugin manifest.
# Usage: scripts/new-skill.sh <skill-name>
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:-}"

if [ -z "$NAME" ]; then
  echo "usage: scripts/new-skill.sh <skill-name>" >&2
  exit 1
fi

if ! printf '%s' "$NAME" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "error: '$NAME' must be lowercase and hyphen-separated (e.g. resolving-merge-conflicts)" >&2
  exit 1
fi

DIR="$REPO/skills/$NAME"
if [ -e "$DIR" ]; then
  echo "error: skills/$NAME already exists" >&2
  exit 1
fi

mkdir -p "$DIR"
sed "s/<skill-name>/$NAME/" "$REPO/templates/SKILL.md" > "$DIR/SKILL.md"

# Register the skill in the plugin manifest, keeping the array sorted.
MANIFEST="$REPO/.claude-plugin/plugin.json"
if ! grep -q "\"\./skills/$NAME\"" "$MANIFEST"; then
  tmp="$(mktemp)"
  awk -v entry="\"./skills/$NAME\"" '
    /^  "skills": \[/ { in_skills = 1; print; next }
    in_skills && /^  \]/ {
      lines[++n] = entry
      for (i = 2; i <= n; i++) {
        v = lines[i]; j = i - 1
        while (j > 0 && lines[j] > v) { lines[j + 1] = lines[j]; j-- }
        lines[j + 1] = v
      }
      for (i = 1; i <= n; i++) printf "    %s%s\n", lines[i], (i < n ? "," : "")
      in_skills = 0
      print
      next
    }
    in_skills {
      line = $0
      sub(/^[ \t]+/, "", line)
      sub(/,[ \t]*$/, "", line)
      lines[++n] = line
      next
    }
    { print }
  ' "$MANIFEST" > "$tmp"
  mv "$tmp" "$MANIFEST"
fi

echo "created skills/$NAME/SKILL.md"
echo "next: fill in the frontmatter, then run scripts/validate-skills.sh"
