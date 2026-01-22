# Code Review Instructions for GitHub Copilot

## Purpose

Provide automated code review to identify bugs, compliance issues, and quality concerns.

## When to Review

Apply code review when:
- User requests code review
- Analyzing pull requests
- Checking code before commit
- Validating changes against guidelines

## Review Process

### 1. Context Gathering

Before reviewing:
- Read project guidelines (CLAUDE.md, CONTRIBUTING.md)
- Understand the intent of changes
- Identify relevant files and their purpose
- Check if trivial or already reviewed

### 2. Analysis Perspectives

Review from multiple angles:

#### Guideline Compliance
- Verify adherence to documented project rules
- Check naming conventions and code style
- Ensure architectural patterns are followed
- Only flag violations of explicit guidelines

#### Bug Detection
- Syntax errors and type mismatches
- Logic errors in conditionals/loops
- Null/undefined handling
- Resource leaks
- Missing error handling
- Security vulnerabilities

#### Code Quality
- Maintainability and clarity
- Performance implications
- Proper API usage
- Edge case handling

### 3. Confidence Scoring

Rate each issue 0-100:
- **76-100**: Very high confidence - definitely real
- **51-75**: High confidence - probably real
- **26-50**: Moderate - might be real
- **0-25**: Low confidence - likely false positive

**Only report issues with confidence ≥ 80**

## High Signal Focus

### DO Flag These

- Syntax errors, type errors, missing imports
- Clear logic errors producing wrong results
- Unambiguous guideline violations with explicit rules
- Security vulnerabilities (SQL injection, XSS, CSRF)
- Resource leaks (memory, connections, files)
- Missing error handling for critical operations
- Unsafe API usage

### DO NOT Flag These

- Code style preferences (unless in guidelines)
- Subjective quality suggestions
- Nitpicks that don't affect functionality
- Issues that linters will catch automatically
- Pre-existing problems not in current changes
- Potential issues depending on unknown state
- General quality concerns (unless required by guidelines)

## False Positive Prevention

Avoid flagging:
- Issues present before current changes
- Code that appears wrong but is actually correct
- Pedantic nitpicks a senior engineer would ignore
- General code quality unless explicitly in guidelines
- Issues with explicit suppression comments

## Report Format

### When Issues Found

For each issue, provide:

```markdown
### Issue: [Brief Title]
**Confidence:** [85]/100
**Category:** [Bug/Guideline/Security/Performance]

**Problem:**
[Clear explanation of the issue]

**Location:**
file.ext:L10-L15

**Evidence:**
[Quote the problematic code]

**Guideline Reference:** (if applicable)
[Quote the specific rule from CLAUDE.md or other guideline]

**Suggested Fix:**
[Provide concrete, actionable solution]
```

### When No Issues Found

```markdown
## Code Review

No issues found. Checked for:
- Bugs and logic errors
- Project guideline compliance  
- Security vulnerabilities
- Code quality concerns
```

## Best Practices

1. **Read Guidelines First**: Always check project-specific rules
2. **Be Specific**: Include exact file paths and line numbers
3. **Provide Context**: Explain why something is an issue
4. **Suggest Solutions**: Offer concrete fixes when possible
5. **Prioritize**: Focus on critical issues first
6. **Respect Intent**: Consider the stated goals of the changes
7. **Avoid Nitpicking**: Only flag issues that truly matter
8. **Verify Claims**: Double-check before flagging an issue

## Integration Patterns

### Inline Review
As code is written, flag critical issues immediately.

### Pre-Commit Review
Review staged changes before commit.

### Pull Request Review
Comprehensive review of all changes in PR.

### Continuous Review
Ongoing feedback as code evolves.

## Priority Levels

When multiple issues exist, prioritize:

1. **Critical**: Security vulnerabilities, data loss risks
2. **High**: Logic errors, crashes, compliance violations
3. **Medium**: Performance issues, maintainability concerns
4. **Low**: Minor quality improvements, style suggestions

Focus on Critical and High priority issues.

## Examples

### Good Review Comment

```markdown
### Issue: SQL Injection Vulnerability
**Confidence:** 95/100
**Category:** Security

**Problem:**
User input is directly interpolated into SQL query without sanitization.

**Location:**
database.ts:L45-L47

**Evidence:**
const query = `SELECT * FROM users WHERE id = ${userId}`

**Suggested Fix:**
Use parameterized queries:
const query = 'SELECT * FROM users WHERE id = ?'
db.execute(query, [userId])
```

### Poor Review Comment

```markdown
### Issue: Variable name could be better
**Confidence:** 30/100
**Category:** Style

**Problem:**
The variable name 'x' is not descriptive.

[This would be filtered out due to low confidence and being a nitpick]
```

## Configuration

- **Confidence Threshold**: 80 (only report issues ≥ 80)
- **Focus**: Bugs, guidelines, security, performance
- **Scope**: Current changes only (not pre-existing issues)
- **Style**: High signal, actionable feedback only
