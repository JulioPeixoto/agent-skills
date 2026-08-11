# agent-skills

A workshop for writing [agent skills](https://code.claude.com/docs/en/skills) —
a template, scripts that scaffold and validate them, and the skills I have
written so far.

A skill is a Markdown file an agent loads instead of improvising: frontmatter
that says when to fire it, and a body that says what to do. This repo keeps one
format (`SKILL.md`) and one copy of each skill, and documents how to load that
same file on other platforms rather than duplicating it per tool.

## Install

As a Claude Code plugin, using this repo as its own marketplace:

```bash
/plugin marketplace add JulioPeixoto/agent-skills
/plugin install agent-skills@juliopeixoto
```

Or clone it and symlink every skill into your local skill directories
(`~/.claude/skills` and `~/.agents/skills`), so `git pull` keeps them current:

```bash
git clone https://github.com/JulioPeixoto/agent-skills
cd agent-skills && scripts/link-skills.sh
```

For Codex, Cursor, Copilot, and everything else, see
[docs/platforms.md](./docs/platforms.md).

## Skills

| Skill | What it does |
|---|---|
| [create-skill](./skills/create-skill/SKILL.md) | Author or revise a skill in this repo — establish the failure it fixes, the trigger phrases that reach it, and the boundary against neighbouring skills, then scaffold and validate it. |

## Writing a new one

```bash
scripts/new-skill.sh my-skill   # scaffold from templates/SKILL.md + register it
# write it, following docs/authoring-skills.md
scripts/validate-skills.sh      # name/description/length/manifest checks
```

Or just ask an agent to do it — `create-skill` runs the same process, with the
reasoning attached.

| Script | What it does |
|---|---|
| `scripts/new-skill.sh <name>` | Creates `skills/<name>/SKILL.md` from the template and adds it to the plugin manifest |
| `scripts/validate-skills.sh` | Fails on a name/directory mismatch, a weak or placeholder description, an oversized body, or a manifest out of sync |
| `scripts/list-skills.sh` | Prints every skill with its description |
| `scripts/link-skills.sh` | Symlinks the skills into `~/.claude/skills` and `~/.agents/skills` |

[docs/authoring-skills.md](./docs/authoring-skills.md) covers the part the
scripts cannot check: what makes a description actually fire, why the body
holds instructions rather than explanation, and how to tell a finished skill
from a written one.

## Layout

```
skills/<name>/SKILL.md   one skill per directory; supporting files sit beside it
templates/SKILL.md       the starting point for a new skill
scripts/                 scaffold, list, validate, link
docs/                    authoring guide, platform guide
.claude-plugin/          plugin + marketplace manifests
```

Conventions for agents working in this repo: [AGENTS.md](./AGENTS.md).
