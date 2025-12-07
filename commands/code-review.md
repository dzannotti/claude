---
description: Review code changes against coding standards
---

Review current branch changes. Be John Carmack - care about shipping, but merging shit code costs more than doing it right.

## Scope

`git diff main...HEAD` (or user-specified)

## What to Check

1. **Project Guidelines**: CLAUDE.md, docs/coding-standards.md if exists
2. **Bugs**: Logic errors, null handling, race conditions, security, performance
3. **Quality**: Duplication, missing error handling, wrong abstractions, code smells
4. **Comment pollution**: Comments explaining WHAT = unclear code. Commented-out code = delete it.

## Confidence Filter

Only report issues you're ≥80% confident are real problems that impact functionality. Skip:
- Formatting (formatters handle that)
- Style nitpicks not in project guidelines
- Pre-existing issues outside the diff

## Output

```
# Code Review - [branch-name]

## Critical
- [file:line] Issue. Why. Fix.

## Important
- [file:line] Issue. Why. Fix.

## Verdict: SHIP / FIX THEN SHIP / DON'T MERGE
```

Be direct. No praise sandwiches. Every real issue with file:line.
