# Authoring skills

A skill is a document an agent loads *instead of* improvising. That framing
decides everything else: it earns its place only by changing behaviour on a
task the agent would otherwise get wrong, and every sentence that does not
change behaviour is dilution.

## Anatomy

```markdown
---
name: resolving-merge-conflicts
description: Resolve an in-progress git merge or rebase conflict hunk by hunk. Use when the user is mid-merge, mid-rebase, or says "fix the conflicts".
---

# Resolving merge conflicts

...instructions to the agent...
```

Two frontmatter fields are required:

| Field | Rules |
|---|---|
| `name` | Lowercase, hyphen-separated, matches the directory name. This is what the user types as `/name`. |
| `description` | One or two sentences: what it does, then `Use when …`. Max 1024 characters. |

Optional, harness-specific:

| Field | Effect |
|---|---|
| `disable-model-invocation: true` | Claude Code only fires the skill when the user types it. Use it for skills with side effects the agent should not choose on its own. |
| `allowed-tools` | Restricts the tools available while the skill runs. |

## The description is the whole routing decision

Before loading a skill, the agent sees only its name and description. If the
description does not overlap the words the user actually typed, the skill never
fires — and an unfired skill is indistinguishable from one that does not exist.

Write triggers, not categories:

- **No** — `description: Helps with testing.`
- **Yes** — `description: Test-driven development. Use when the user wants to
  build a feature or fix a bug test-first, mentions "red-green-refactor", or
  asks for integration tests.`

Include the phrasings a user would type, including sloppy ones. If two skills
could plausibly match the same request, one of them is wrong: sharpen both
boundaries, or merge them.

## Write instructions, not explanation

The body addresses the agent. Imperative, second person, present tense.

- Cut anything the model already does correctly. Background about a language,
  library, or concept is context spent to teach nothing.
- Give rules with reasons. An unexplained constraint gets dropped the first
  time it is inconvenient.
- Name anti-patterns explicitly — "never X, because Y" is easier to comply with
  than a positive rule alone.
- End with a **Done when** section: checkable statements about the finished
  artifact, so the agent has something to verify against instead of declaring
  success by vibes.

## Keep the body small, link the rest

`SKILL.md` is loaded in full whenever the skill fires, so it stays under ~200
lines (the validator caps it at 250). Anything long — reference tables, worked
examples, output templates, scripts — moves into a sibling file that the body
links, and gets read only by the step that needs it.

```
skills/wizard/
├── SKILL.md        loaded on trigger
├── template.sh     read at the step that generates the script
└── examples.md     read only when the agent needs a worked example
```

## One skill, one job

A skill covering three workflows cannot describe all three sharply, so it
fires for none of them. Split by trigger: if you would describe the situations
with different words, they are different skills.

## Test it

A skill is not finished when it is written. Open a fresh session, type
something a real user would type, and check two things: that it fires at all,
and that the result differs from what you get without it. If it fires but the
output is unchanged, the body is describing the model's default behaviour —
cut it down to the part that is genuinely corrective.

## Checklist

- `name` matches the directory; `description` names concrete triggers.
- No sentence would be true of the agent without the skill.
- Long material lives in linked files, not in the body.
- A **Done when** section states what "finished" means.
- `scripts/validate-skills.sh` passes.
- The skill has fired from a fresh session and changed the outcome.
