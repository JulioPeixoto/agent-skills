---
name: create-skill
description: Author or revise an agent skill (a SKILL.md) in this repository. Use when the user wants to create a new skill, turn a repeated workflow or prompt into a skill, or rewrite an existing SKILL.md that is vague, bloated, or never fires.
---

# Create a skill

A skill is a document the agent loads *instead of* improvising. It earns its
place only if it changes behaviour on a task the agent would otherwise get
wrong. Writing one is mostly subtraction: everything the model already does
correctly is noise that dilutes the parts that matter.

Read [docs/authoring-skills.md](../../docs/authoring-skills.md) before writing —
it holds the reasoning behind the rules below.

## Before writing anything

Establish these three, asking the user where you cannot infer them:

1. **The failure.** What does the agent do today, without the skill, that is
   wrong? If there is no concrete failure, there is no skill — say so and stop.
2. **The trigger.** What will the user be doing or typing when this should
   fire? These words become the `description`, verbatim where possible.
3. **The boundary.** What is deliberately out of scope, and which existing
   skill covers the neighbouring case? Run `scripts/list-skills.sh` first — a
   skill that overlaps an existing one makes both unreachable.

## Process

1. Scaffold the directory: `scripts/new-skill.sh <skill-name>`. It copies
   `templates/SKILL.md` into `skills/<skill-name>/` and registers the skill in
   `.claude-plugin/plugin.json`.
2. Write the frontmatter first. `name` must match the directory name exactly:
   lowercase, hyphen-separated. `description` is one or two sentences —
   what it does, then `Use when …` with the real trigger phrases. The
   description is the *only* part the agent sees when deciding whether to load
   the skill, so it carries the entire routing decision.
3. Write the body as instructions to the agent, not prose about the topic.
   Imperative, second person, present tense. Cut every sentence the model would
   have followed anyway.
4. Move anything long — reference tables, templates, worked examples, scripts —
   into a sibling file (`reference.md`, `template.sh`) and link it from
   `SKILL.md`. The body stays under ~200 lines so it is cheap to load; the
   linked files are read only when the step that needs them runs.
5. Close with a **Done when** section: checkable statements about the finished
   artifact. This is what the agent verifies against before reporting success.
6. Run `scripts/validate-skills.sh`. Fix what it reports.
7. Add the skill to the table in `README.md` and to `skills/README.md`.

## Rules

- **One skill, one job.** A skill that handles three workflows fires for none
  of them, because its description cannot describe all three sharply.
- **Never write background explanation.** "React is a UI library" costs context
  and teaches nothing. Write only what changes what the agent does.
- **Prefer a rule with a reason over a rule alone.** An unexplained constraint
  gets dropped the moment it is inconvenient.
- **No platform-specific duplication.** One `SKILL.md` per skill. Harnesses
  that need another format are handled in
  [docs/platforms.md](../../docs/platforms.md), not by copying the file.
- **Test it before declaring it done.** Start a fresh session, type something a
  real user would type, and check the skill fires and changes the outcome. A
  skill that never fires is a skill that does not exist.

## Done when

- `skills/<name>/SKILL.md` exists, its `name` matches the directory, and
  `scripts/validate-skills.sh` passes.
- The description names concrete trigger situations, not a category.
- The body contains no sentence that would be true of the agent without the
  skill.
- The skill is listed in `.claude-plugin/plugin.json`, `README.md`, and
  `skills/README.md`.
- It has been fired at least once from a fresh session and demonstrably changed
  the result.
