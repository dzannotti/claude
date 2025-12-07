---
description: Run CodeRabbit AI review and filter for legitimate issues
---

# CodeRabbit AI Code Review

Use the Task tool with subagent_type="code-reviewer" to run this review. This keeps the verbose CodeRabbit output out of the main session context.

## Task Agent Instructions

Pass the following prompt to the Task agent:

---

Run CodeRabbit AI code review and categorize findings. This takes 2-5 minutes.

### Step 1: Run CodeRabbit

```bash
coderabbit review --plain --no-color --config CLAUDE.md .github/copilot-instructions.md
```

### Step 2: Apply Skepticism Filter

CodeRabbit is an LLM that loves unnecessary complexity. Filter accordingly:

**VALID (~25%)**: Actual bugs, edge cases, security issues, performance problems
**NOISE (~50%)**: Documentation bloat, verbose comments, defensive validation, over-engineering
**DISCUSS (~25%)**: Might be valid, needs human judgment

#### Auto-decline patterns (violate coding standards):
- JSDoc/GoDoc comments explaining obvious code
- Verbose error messages
- Defensive validation in internal packages
- Abstractions for single-use cases
- Comments that repeat code
- Splitting simple functions into layers
- "Consider adding..." for hypothetical scenarios

**Rule**: If the suggestion makes code longer or more complex - it's wrong.

### Step 3: Categorize Each Finding

**VALID**: Logic errors, silent failures, security vulns, performance issues, race conditions, real edge cases

**NOISE**: Doc comments, unnecessary error context, clarity-reducing extractions, defensive internal validation

**DISCUSS**: Architectural suggestions with merit, legitimate test gaps, API design improvements

### Step 4: Return Summary Report

Return ONLY this format (keep it concise):

```
## CodeRabbit Review - [branch-name]

### Quick Stats
- Valid: X | Noise filtered: Y | Discuss: Z

### VALID Issues (Fixable)
1. [file:line] Brief issue description
2. [file:line] Brief issue description
...

### DISCUSS (Your Call)
1. [brief suggestion] - Tradeoff: [one-liner]
...

### Noise Filtered
[X suggestions ignored - doc comments, over-engineering, etc.]
```

---

## After Agent Returns

Present the summary to the user. DO NOT auto-fix anything.

For VALID issues, offer:
> "Say `fix 1` or `fix 1,3,5` to apply fixes, or `fix all` for everything."

For DISCUSS items, let the user decide - present tradeoffs neutrally.

**Remember**: We're lazy but not incompetent. We report problems, user decides what to fix.
