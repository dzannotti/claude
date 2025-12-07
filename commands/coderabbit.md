---
description: Run CodeRabbit AI review and filter for legitimate issues
---

Run CodeRabbit CLI and filter its output intelligently. CodeRabbit is an external LLM tool - different perspective from /code-review.

## Step 1: Run CodeRabbit

```bash
coderabbit review --plain --no-color
```

Takes 2-5 minutes. Wait for completion.

## Step 2: Filter with Critical Thinking

CodeRabbit is an LLM without full context. Apply critical thinking:

**Common Noise Patterns:**
- Doc comments for obvious code
- "Consider adding..." for hypothetical scenarios
- Defensive validation in internal-only code
- Abstractions for single-use cases
- Style preferences without bug fixes
- Complexity additions without fixing actual issues

**Core Rule**: If suggestion adds complexity without fixing a real bug, security hole, or performance issue = noise.

**Don't Auto-Reject**: Apply judgment. Some complexity is justified. Some "obvious" code isn't obvious. Context matters.

## Step 3: Categorize

- **VALID**: Bugs, security issues, performance problems, real edge cases
- **NOISE**: Doc bloat, over-engineering, unfounded hypotheticals, style nitpicks
- **DISCUSS**: Architectural suggestions with merit, needs human judgment

## Output Format

```
# CodeRabbit Review - [branch-name]

**Stats**: Valid: X | Noise: Y | Discuss: Z

## Valid Issues
1. [file:line] Issue description

## Noise (Rejected)
- [file:line] Why rejected (one-liner)

## Discuss (Your Call)
1. [file:line] Suggestion - Tradeoff: [one-liner]
```

Present summary. Offer: `fix 1` or `fix 1,3,5` or `fix all` for valid issues.
