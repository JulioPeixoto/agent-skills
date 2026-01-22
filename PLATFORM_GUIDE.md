# Platform Integration Guide

This guide explains how to use the skills in this repository with different AI platforms.

## Overview

Each platform has its own configuration format for applying skills and custom instructions:

| Platform | Configuration File/Location | Format |
|----------|---------------------------|---------|
| Claude | Project Knowledge or Conversation Context | Markdown/Text |
| Cursor | `.cursorrules` file in project root | Markdown/Text |
| Codex | `.codex/skills/<skill-name>/SKILL.md` | YAML frontmatter + Markdown |
| GitHub Copilot | `.github/copilot-instructions.md` | Markdown |
| ChatGPT | Custom Instructions in Settings | Text |

## Platform-Specific Instructions

### Claude (Anthropic)

Claude supports two ways to apply skills:

#### Option 1: Project Knowledge
1. Open your project in Claude
2. Go to Project Settings
3. Add the skill content to "Project Knowledge"
4. The skill will be available in all conversations for that project

#### Option 2: Conversation Context
1. Copy the skill content from `SKILL.md`
2. Paste it at the beginning of your conversation
3. Claude will follow those guidelines for the session

**Plugin Format**: If using Claude Plugins, place files in:
```
your-skill/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── your-skill/
        └── SKILL.md
```

### Cursor (AI IDE)

Cursor automatically loads project-specific rules:

1. Create a `.cursorrules` file in your project root
2. Copy the skill content into this file
3. Cursor will automatically apply these rules to all AI interactions
4. Rules are applied project-wide and persist across sessions

**Best Practice**: Keep `.cursorrules` focused and modular. You can reference external files if needed.

### OpenAI Codex

Codex uses a structured skills system:

1. Create the skill directory structure:
```bash
mkdir -p .codex/skills/your-skill-name
```

2. Create `SKILL.md` with YAML frontmatter:
```markdown
---
name: skill-name
description: Brief description of when to use this skill
---

# Skill content here
```

3. Restart Codex to load the new skill
4. Skills are automatically suggested when relevant to the task

**Scopes**:
- **Repo-scoped**: `.codex/skills/<skill-name>` (shared with team)
- **User-scoped**: `~/.codex/skills/<skill-name>` (personal, global)

### GitHub Copilot

GitHub Copilot reads instructions from your repository:

1. Create `.github/copilot-instructions.md` in your repo root
2. Add your skill guidelines in Markdown format
3. Copilot will consider these instructions when generating code
4. Works for all contributors with access to the repository

**Note**: Instructions apply to the entire repository. Be clear and concise.

### ChatGPT (OpenAI)

ChatGPT uses custom instructions in user settings:

1. Go to Settings → Personalization → Custom Instructions
2. Paste your skill guidelines
3. Instructions apply to all conversations globally

**Limitations**: 
- Character limit on custom instructions
- Applies globally (cannot be project-specific)
- Consider using shorter, focused versions of skills

## General Best Practices

### Writing Universal Skills

To maximize compatibility across platforms:

1. **Use Clear Markdown**: All platforms support Markdown formatting
2. **Avoid Platform-Specific References**: Use "AI assistant" instead of "Claude" or "Copilot"
3. **Structure Content Hierarchically**: Use headers, lists, and emphasis consistently
4. **Be Explicit**: Don't assume context; state requirements clearly
5. **Test Across Platforms**: Verify the skill works as expected on different platforms

### Skill Structure

Each skill should include:

```markdown
# Skill Name

Brief description of what this skill does.

## When to Apply
- Specific triggers or contexts

## Guidelines
- Detailed instructions
- Best practices
- Anti-patterns to avoid

## Examples
- Usage examples
- Expected outputs
```

### Version Control

Keep skills in version control:
- Track changes to skill definitions
- Document when and why skills are updated
- Allow team members to propose improvements via PRs

### Skill Composition

For complex workflows:
- Break large skills into smaller, focused ones
- Reference other skills when needed
- Keep each skill single-purpose

## Platform Comparison

### Feature Matrix

| Feature | Claude | Cursor | Codex | Copilot | ChatGPT |
|---------|--------|--------|-------|---------|---------|
| Project-Scoped | Yes | Yes | Yes | Yes | No |
| Auto-Loading | No | Yes | Yes | Yes | Yes |
| Team Sharing | Yes | Yes | Yes | Yes | No |
| Version Control | Manual | Yes | Yes | Yes | No |
| Structured Format | Optional | No | Required | No | No |

### Choosing the Right Platform

- **Claude**: Best for conversational workflows and complex reasoning
- **Cursor**: Best for IDE-integrated development with persistent rules
- **Codex**: Best for structured, reusable skills with clear triggers
- **Copilot**: Best for inline code suggestions within existing workflows
- **ChatGPT**: Best for personal, general-purpose assistance

## Troubleshooting

### Skill Not Being Applied

1. **Check file location**: Ensure config file is in the correct directory
2. **Verify format**: Confirm YAML frontmatter (if required) is valid
3. **Restart/reload**: Some platforms require restart to pick up changes
4. **Check scope**: Ensure skill is accessible in current context

### Conflicting Skills

If multiple skills conflict:
1. Make skill triggers more specific
2. Use clear priority indicators
3. Combine related skills into one
4. Remove redundant instructions

### Performance Issues

If skills slow down responses:
1. Reduce skill length and complexity
2. Focus on most critical guidelines
3. Use bullet points instead of paragraphs
4. Remove redundant examples

## Contributing Skills

When contributing skills to this repository:

1. Create versions for all major platforms
2. Test each platform-specific version
3. Document any platform-specific limitations
4. Provide usage examples
5. Update this guide if introducing new patterns

## Resources

- [Claude Documentation](https://docs.anthropic.com/claude)
- [Cursor Documentation](https://cursor.sh/docs)
- [OpenAI Codex Documentation](https://platform.openai.com/docs)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [ChatGPT Custom Instructions](https://help.openai.com/en/articles/8096356-custom-instructions-for-chatgpt)
