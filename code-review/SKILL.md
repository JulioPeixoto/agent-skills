# Code Review Skill

Universal skill for automated code review using AI agents to identify bugs, compliance issues, and quality concerns.

## Compatible Platforms

This skill works with: Claude, Cursor, Codex, GitHub Copilot, and other LLM-based assistants.

## Overview

This skill enables AI-powered code review that:
- Checks code compliance with project guidelines
- Identifies potential bugs and logic errors
- Provides confidence-scored feedback to reduce false positives
- Links directly to problematic code sections
- Integrates with pull request workflows

## How to Use

### Quick Setup
Copy the content below and paste it into:
- **Claude**: Project Knowledge or use as command
- **Cursor**: `.cursorrules` file or as instructions
- **Codex**: `.codex/skills/code-review/SKILL.md`
- **Copilot**: `.github/copilot-instructions.md`

---

## Skill Content

### Purpose

Perform thorough code review focusing on:
1. **Guidelines Compliance**: Check adherence to project-specific guidelines (CLAUDE.md, CONTRIBUTING.md, style guides)
2. **Bug Detection**: Identify obvious bugs, logic errors, and potential runtime issues
3. **Quality Assurance**: Ensure code quality meets project standards
4. **Context Analysis**: Consider git history and related changes

### Review Process

When performing code review, follow these steps:

#### 1. Initial Assessment

Determine if review is needed:
- Skip closed or draft pull requests
- Skip trivial changes (typos, formatting only)
- Skip automated PRs (dependency updates, generated code)
- Check if already reviewed

#### 2. Gather Context

Collect relevant information:
- Read project guidelines (CLAUDE.md, CONTRIBUTING.md, etc.)
- Review PR description and intent
- Understand modified files and their purpose
- Check related git history if needed

#### 3. Multi-Perspective Analysis

Review from multiple angles:

**Guideline Compliance:**
- Check for violations of documented project rules
- Verify naming conventions and code style
- Ensure architectural patterns are followed
- Validate that guidelines apply to modified files

**Bug Detection:**
- Look for syntax errors and type mismatches
- Identify logic errors in conditionals and loops
- Check for null/undefined handling issues
- Spot resource leaks (memory, connections, files)
- Verify error handling and edge cases

**Quality Assessment:**
- Evaluate code clarity and maintainability
- Check for security vulnerabilities
- Assess performance implications
- Verify proper use of APIs and libraries

#### 4. Confidence Scoring

For each issue found, assign a confidence score (0-100):

- **0-25**: Low confidence, likely false positive
- **26-50**: Moderate confidence, might be real
- **51-75**: High confidence, probably real
- **76-100**: Very high confidence, definitely real

**Only report issues with confidence ≥ 80**

#### 5. Issue Reporting

For each valid issue, provide:

**Description:**
```
Brief explanation of the problem
```

**Evidence:**
- Quote the problematic code
- Reference specific guideline if applicable
- Explain why it's an issue

**Location:**
- File path and line numbers
- Link to code (use format: `file.ext:L10-L15`)

**Suggested Fix:**
- Provide concrete solution when possible
- Keep suggestions small and actionable
- Only suggest if you're confident in the fix

### High Signal Focus

**DO flag these issues:**
- Syntax errors, type errors, missing imports
- Clear logic errors that will produce wrong results
- Unambiguous guideline violations with explicit rules
- Security vulnerabilities (SQL injection, XSS, etc.)
- Resource leaks and memory issues
- Missing error handling for critical operations

**DO NOT flag these:**
- Code style preferences (unless in guidelines)
- Subjective quality suggestions
- Nitpicks that don't affect functionality
- Issues linters will automatically catch
- Pre-existing problems not in the changes
- Potential issues that depend on unknown state

### False Positive Prevention

Avoid flagging:
- Pre-existing issues not introduced in this change
- Code that looks wrong but is actually correct
- Pedantic nitpicks a senior engineer would ignore
- General quality concerns unless required by guidelines
- Issues with explicit suppression comments

### Output Format

#### When Issues Found

```markdown
## Code Review Results

Found [N] issues:

### Issue 1: [Brief Title]
**Confidence:** [85]/100
**Category:** [Bug/Guideline/Security/Performance]

**Problem:**
[Clear explanation of the issue]

**Location:**
file.ext:L10-L15

**Evidence:**
```
[relevant code snippet]
```

**Guideline Reference:** (if applicable)
[Quote from CLAUDE.md or other guideline]

**Suggested Fix:**
[Concrete solution]

---

[Repeat for each issue]
```

#### When No Issues Found

```markdown
## Code Review Results

No issues found. Checked for:
- Bugs and logic errors
- Project guideline compliance
- Security vulnerabilities
- Code quality concerns
```

### Platform-Specific Notes

#### For Claude
- Can launch parallel agents for comprehensive review
- Use gh CLI for GitHub integration
- Support for inline comments on PRs

#### For Cursor
- Review on-demand as you write code
- Integrate with IDE linting and testing
- Focus on current file or selection

#### For Codex
- Structured skill with YAML frontmatter
- Triggered automatically on relevant tasks
- Can invoke scripts for deeper analysis

#### For Copilot
- Continuous review as code is written
- Focus on immediate context
- Suggestions inline with editing

### Best Practices

1. **Read Guidelines First**: Always check project-specific rules before reviewing
2. **Be Specific**: Reference exact lines and files
3. **Provide Context**: Explain why something is an issue
4. **Suggest Solutions**: Offer concrete fixes when possible
5. **Prioritize Severity**: Focus on critical issues first
6. **Respect Intent**: Consider the PR's stated goals
7. **Avoid Nitpicking**: Only flag issues that matter
8. **Verify Claims**: Double-check before flagging

### Integration Examples

#### With Git Workflow
```bash
git checkout feature-branch
[request code review from AI]
[make fixes based on feedback]
git commit -m "Address review feedback"
```

#### In Pull Requests
```
Review checklist:
- [ ] Follows project guidelines
- [ ] No obvious bugs
- [ ] Proper error handling
- [ ] Security concerns addressed
- [ ] Performance considerations
```

### Configuration

Adjust these parameters as needed:
- **Confidence Threshold**: Default 80 (range: 0-100)
- **Focus Areas**: Bugs, guidelines, security, performance
- **Scope**: Full PR, specific files, or code selection
- **Depth**: Quick scan vs. comprehensive review

### Requirements

- Access to code repository
- Project guidelines (CLAUDE.md, CONTRIBUTING.md, etc.)
- Understanding of project's language and frameworks
- For GitHub integration: gh CLI installed

---

## Credits

Based on work by Boris Cherny (Anthropic)
Adapted for universal AI agent compatibility
