# Skills Reference

## Locations

| Location | Scope |
|----------|-------|
| `~/.claude/skills/name/` | Personal |
| `.claude/skills/name/` | Project |

## SKILL.md Structure

```yaml
---
name: my-skill
description: What and when to use
allowed-tools: Read, Grep
---

# Content
```

## Requirements

| Field | Rules |
|-------|-------|
| `name` | lowercase, hyphens, max 64 |
| `description` | max 1024, include triggers |

## Directory Structure

```
my-skill/
├── SKILL.md (required)
├── references/
├── scripts/
└── assets/
```

## Activation

Model-invoked based on description match.
Different from slash commands (user-triggered).

## Example

```yaml
---
name: api-docs
description: Generate API docs. Use when documenting endpoints or creating OpenAPI specs.
---

# API Documentation

See references/format.md for details.
```
