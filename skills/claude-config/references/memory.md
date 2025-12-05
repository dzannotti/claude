# Memory (CLAUDE.md) Reference

## Locations

| Location | Purpose |
|----------|---------|
| `~/.claude/CLAUDE.md` | User global |
| `./CLAUDE.md` | Project shared |
| `./.claude/CLAUDE.md` | Alt project |
| `./CLAUDE.local.md` | Personal (gitignored) |

## File Imports

```markdown
# My Project

@./docs/standards.md
@./docs/api.md
```

Not evaluated inside code blocks.

## Commands

| Command | Action |
|---------|--------|
| Start with `#` | Quick-add memory |
| `/memory` | Edit memory files |
| `/init` | Bootstrap CLAUDE.md |

## Example

```markdown
# Project Guidelines

## Code Style
- 2-space indentation
- TypeScript strict mode

## Testing
- Run `npm test` before commits

@./docs/architecture.md
```
