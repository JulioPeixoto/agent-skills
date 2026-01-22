---
name: code-review
description: Performs automated code review to identify bugs, compliance issues, and quality concerns with confidence scoring
---

# Code Review Skill for Codex

## Purpose

Provide thorough code review focusing on high-signal issues with confidence-based filtering.

## When to Use

Trigger this skill when:
- Reviewing pull requests
- Checking code before commit
- Auditing code changes
- Validating guideline compliance

## Review Process

### Step 1: Assess Scope

Determine what to review:
- Skip closed or draft PRs
- Skip trivial changes
- Skip automated PRs
- Identify relevant project guidelines

### Step 2: Gather Context

Collect information:
- Read CLAUDE.md and project guidelines
- Review PR description and intent
- Understand modified files
- Check git history if needed

### Step 3: Multi-Perspective Analysis

#### Guideline Compliance
Check for violations of:
- CLAUDE.md rules
- CONTRIBUTING.md requirements
- Code style guidelines
- Architectural patterns

Only flag documented violations.

#### Bug Detection
Look for:
- Syntax and type errors
- Logic errors
- Null/undefined issues
- Resource leaks
- Missing error handling
- Security vulnerabilities

#### Quality Assessment
Evaluate:
- Code clarity
- Performance implications
- API usage
- Edge case handling

### Step 4: Confidence Scoring

Rate each issue 0-100:
- 0-25: Low confidence
- 26-50: Moderate confidence
- 51-75: High confidence
- 76-100: Very high confidence

**Threshold: Only report issues ≥ 80 confidence**

### Step 5: Report Issues

For each valid issue:

```markdown
### Issue: [Title]
Confidence: [85]/100
Category: [Bug/Guideline/Security/Performance]

Problem: [Explanation]
Location: file.ext:L10-L15
Evidence: [Code quote]
Guideline: [Rule reference if applicable]
Fix: [Suggested solution]
```

## High Signal Criteria

**DO flag:**
- Syntax/type errors, missing imports
- Clear logic errors
- Unambiguous guideline violations
- Security vulnerabilities
- Resource leaks
- Missing critical error handling

**DO NOT flag:**
- Style preferences (unless documented)
- Subjective suggestions
- Nitpicks
- Linter-catchable issues
- Pre-existing problems
- State-dependent issues

## False Positive Prevention

Avoid:
- Issues not in current changes
- Code that looks wrong but isn't
- Pedantic nitpicks
- Quality concerns unless required
- Suppressed issues

## Output Format

### Issues Found
```markdown
## Code Review

Found [N] issues:

[For each issue: Title, Confidence, Category, Problem, Location, Evidence, Fix]
```

### No Issues
```markdown
## Code Review

No issues found. Checked for bugs, guidelines, and quality.
```

## Best Practices

1. Read guidelines first
2. Be specific with locations
3. Explain reasoning
4. Provide concrete fixes
5. Prioritize severity
6. Respect intent
7. Avoid nitpicking
8. Verify claims

## Requirements

- Project guidelines (CLAUDE.md, etc.)
- Code repository access
- Understanding of project language/framework
