# Slash Commands Reference

## Locations

| Location | Scope |
|----------|-------|
| `.claude/commands/` | Project |
| `~/.claude/commands/` | Personal |

## File Format

```markdown
---
allowed-tools: Bash(git:*), Read
description: My command description
model: claude-3-5-haiku-20241022
---

Command content here.
```

## Frontmatter

| Key | Purpose |
|-----|---------|
| `allowed-tools` | Tool restrictions |
| `description` | Shown in list |
| `model` | Override model |
| `argument-hint` | Hint for args |

## Arguments

| Syntax | Meaning |
|--------|---------|
| `$ARGUMENTS` | All args |
| `$1`, `$2` | Positional |

## Special Syntax

**Bash:** `!`git status``
**Files:** `@src/file.js`

## Example

`.claude/commands/review.md`:
```markdown
---
description: Review changes
allowed-tools: Read, Grep
---

Review !`git diff` for issues.
```

Usage: `/review`
