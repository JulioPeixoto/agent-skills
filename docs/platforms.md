# Loading a skill on each platform

Every skill here is a single `SKILL.md` in the [Agent Skills][spec] format.
Harnesses that support the format read it directly; the rest need the same file
pointed at from wherever they take instructions. Nothing below requires editing
or duplicating the skill.

[spec]: https://code.claude.com/docs/en/skills

## Claude Code

Install the whole set as a plugin, from this repo as its own marketplace:

```bash
/plugin marketplace add JulioPeixoto/agent-skills
/plugin install agent-skills@juliopeixoto
```

Or use individual skills without the plugin by placing (or symlinking) a skill
directory in one of:

| Location | Scope |
|---|---|
| `.claude/skills/<name>/SKILL.md` | this project, shared with the team via git |
| `~/.claude/skills/<name>/SKILL.md` | every project on your machine |

`scripts/link-skills.sh` symlinks every skill in this repo into
`~/.claude/skills`, so `git pull` keeps them current.

Skills load lazily: the agent sees only names and descriptions until one
matches, then reads the body. Type `/<name>` to fire one explicitly.

## Codex and other Agent Skills harnesses

Codex reads skills from `.codex/skills/<name>/SKILL.md` (repo-scoped) or
`~/.codex/skills/<name>/SKILL.md` (user-scoped). Several other harnesses follow
the cross-agent `~/.agents/skills` convention, which
`scripts/link-skills.sh` also populates.

The frontmatter is the same `name` + `description` pair, so the file is
portable as-is. Restart the harness after adding a skill.

## Cursor

Cursor uses project rules in `.cursor/rules/*.mdc` — Markdown with frontmatter,
close enough to a skill that the body transfers unchanged:

```markdown
---
description: Same trigger sentence as the skill's description
alwaysApply: false
---

<the SKILL.md body>
```

Set `alwaysApply: true` only for rules that should be in context on every
request; a skill is by definition situational, so leave it false and let the
description do the routing. The legacy single-file `.cursorrules` still works
but is deprecated — prefer one `.mdc` per skill.

## GitHub Copilot

Copilot reads `.github/copilot-instructions.md` for repo-wide guidance and
`.github/instructions/*.instructions.md` for path-scoped rules (an
`applyTo:` glob in the frontmatter). Neither is trigger-routed: whatever you
put there is always in context, so port only skills that should apply to every
change in the paths they cover, and keep them short.

## ChatGPT and other chat UIs

No file convention — paste the skill body into the conversation, or into a
project's custom instructions. Custom instructions have a character limit and
apply globally, so trim to the rules that survive without their triggers.

## Choosing where a skill goes

| Situation | Where |
|---|---|
| You want it in every repo you work in | `~/.claude/skills`, or install the plugin |
| The team should get it from the repo | `.claude/skills/` committed to git |
| It only makes sense for one project | that project's `.claude/skills/` |
| The harness has no skill support | paste the body, or map it to that harness's rules file |
