# Working in this repo

This repo holds agent skills and the tooling to author them. Its output is
`SKILL.md` files, not application code.

## Layout

```
skills/<name>/SKILL.md   one skill per directory; supporting files sit beside it
templates/SKILL.md       the starting point for a new skill
scripts/                 scaffold, list, validate, and link the skills
docs/                    how to write a skill, and how to load one per platform
.claude-plugin/          plugin + marketplace manifests
```

## Rules

- **One `SKILL.md` per skill, one format.** The Agent Skills format (YAML
  frontmatter + Markdown) is the only source. Never duplicate a skill into
  `.cursorrules`, `.github/copilot-instructions.md`, or any other per-platform
  file — [docs/platforms.md](./docs/platforms.md) explains how each harness
  loads the same file.
- **The frontmatter `name` matches the directory name.** Lowercase,
  hyphen-separated.
- **Every skill is listed in `.claude-plugin/plugin.json`**, in
  [`README.md`](./README.md), and in [`skills/README.md`](./skills/README.md).
  `scripts/new-skill.sh` handles the manifest; the two READMEs are on you.
- **Run `scripts/validate-skills.sh` before committing.** It is the gate: name
  and directory agreement, description quality, length budget, manifest sync.
- **Do not vendor skills that ship elsewhere.** A skill lives here only if it
  is written here. If an upstream plugin already provides it, install that
  instead and link it from the README.

## Adding a skill

Use the [create-skill](./skills/create-skill/SKILL.md) skill, or by hand:

```bash
scripts/new-skill.sh <skill-name>   # scaffolds + registers
# write it, following docs/authoring-skills.md
scripts/validate-skills.sh
```
