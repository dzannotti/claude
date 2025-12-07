---
description: Run CodeRabbit AI review and filter for legitimate issues
---

Run CodeRabbit CLI and evaluate its suggestions. CodeRabbit is an external LLM - different perspective from /code-review, may lack full context.

## Step 1: Run CodeRabbit

```bash
coderabbit review --plain --no-color
```

Takes 2-5 minutes.

## Step 2: Evaluate Each Suggestion

CodeRabbit is an LLM that may not have full context. For each suggestion, ask:

- Does this fix a real bug, security issue, or performance problem?
- Does the suggestion understand our codebase patterns?
- Is the added complexity worth it for this specific case?
- Would this matter in practice or is it theoretical?

**Things to think critically about** (not auto-reject, but scrutinize):
- Doc comments - is the code actually unclear, or is this boilerplate?
- "Consider adding..." - real edge case or hypothetical?
- Defensive validation - internal code or public API?
- New abstractions - used once or genuinely reusable?

## Step 3: Categorize

- **VALID**: Real bugs, security, performance, edge cases that will happen
- **SKIP**: Doesn't apply to our context, misunderstood the code
- **DISCUSS**: Has merit but tradeoffs, needs human judgment

## Output

```
# CodeRabbit Review - [branch-name]

**Stats**: Valid: X | Skipped: Y | Discuss: Z

## Valid Issues
1. [file:line] Issue description

## Skipped
- [file:line] Why it doesn't apply (one-liner)

## Discuss (Your Call)
1. [file:line] Suggestion - Tradeoff: [one-liner]
```

Offer: `fix 1` or `fix 1,3,5` or `fix all` for valid issues.
