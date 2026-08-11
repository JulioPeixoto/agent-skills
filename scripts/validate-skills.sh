#!/usr/bin/env bash
# Checks every skill in skills/ against the repo's conventions.
# Exits non-zero if anything is wrong, so it works as a CI or pre-commit gate.
set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$REPO/.claude-plugin/plugin.json"
errors=0

fail() {
  echo "FAIL $1" >&2
  errors=$((errors + 1))
}

shopt -s nullglob
for dir in "$REPO"/skills/*/; do
  name="$(basename "$dir")"
  skill_md="$dir/SKILL.md"

  if [ ! -f "$skill_md" ]; then
    fail "skills/$name: no SKILL.md"
    continue
  fi

  if [ "$(head -1 "$skill_md")" != "---" ]; then
    fail "skills/$name: SKILL.md must open with YAML frontmatter (---)"
    continue
  fi

  front="$(awk 'NR > 1 { if ($0 == "---") exit; print }' "$skill_md")"
  declared="$(printf '%s\n' "$front" | sed -n 's/^name: *//p' | head -1)"
  desc="$(printf '%s\n' "$front" | sed -n 's/^description: *//p' | head -1)"

  if [ -z "$declared" ]; then
    fail "skills/$name: frontmatter has no 'name'"
  elif [ "$declared" != "$name" ]; then
    fail "skills/$name: frontmatter name '$declared' does not match the directory"
  fi

  if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    fail "skills/$name: directory must be lowercase and hyphen-separated"
  fi

  if [ -z "$desc" ]; then
    fail "skills/$name: frontmatter has no 'description'"
  else
    if [ "${#desc}" -gt 1024 ]; then
      fail "skills/$name: description is ${#desc} chars (max 1024)"
    fi
    if ! printf '%s' "$desc" | grep -qi 'use when'; then
      fail "skills/$name: description must say when to use the skill (\"Use when ...\")"
    fi
    if printf '%s' "$desc" | grep -q '<[^>]*>'; then
      fail "skills/$name: description still contains a <placeholder> from the template"
    fi
  fi

  lines="$(wc -l < "$skill_md")"
  if [ "$lines" -gt 250 ]; then
    fail "skills/$name: SKILL.md is $lines lines (max 250) - move detail into a linked file"
  fi

  if ! grep -q "\"\./skills/$name\"" "$MANIFEST"; then
    fail "skills/$name: not listed in .claude-plugin/plugin.json"
  fi
done

for entry in $(sed -n 's|^ *"\./skills/\([a-z0-9-]*\)".*|\1|p' "$MANIFEST"); do
  if [ ! -f "$REPO/skills/$entry/SKILL.md" ]; then
    fail "plugin.json lists ./skills/$entry, which has no SKILL.md"
  fi
done

if [ "$errors" -gt 0 ]; then
  echo "$errors problem(s) found" >&2
  exit 1
fi

echo "all skills valid"
