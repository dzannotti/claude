---
name: claude-config
description: ALWAYS use this skill when the user asks to manage Claude Code configuration, including MCP servers, permissions, hooks, skills, slash commands, or application preferences. Provides guidance for ~/.claude/settings.json (user config), .mcp.json (MCP servers), CLAUDE.md (memory), and custom commands/skills. Triggers include "configure Claude", "add MCP", "setup hooks", "permissions", "settings", "CLAUDE.md", "slash commands", "skills", or any config management request.
---

# Claude Configuration Skill

## First: Check Reference Freshness

Run `scripts/update-docs.sh` before proceeding. If it exits non-zero, update the stale references first using the URLs provided, then run `date +%s > references/.last-updated`.

## Configuration Files

| File | Purpose | Editable |
|------|---------|----------|
| `~/.claude/settings.json` | User settings, permissions, hooks | Yes |
| `.claude/settings.json` | Project shared settings | Yes |
| `.claude/settings.local.json` | Project personal settings | Yes |
| `.mcp.json` | MCP server definitions | Yes |
| `~/.claude/CLAUDE.md` | User memory/instructions | Yes |
| `./CLAUDE.md` | Project memory/instructions | Yes |

## Quick Reference

### Settings → `~/.claude/settings.json`
- Permissions (allow/ask/deny rules)
- Hooks (PreToolUse, PostToolUse, Stop, etc.)
- Output style, thinking mode
- MCP server enable/disable lists

### MCP → `.mcp.json`
- Server definitions with command/args/env
- Environment variable expansion: `${VAR:-default}`
- Scopes: Local > Project > User

### Memory → `CLAUDE.md`
- Project instructions and context
- File imports with `@path/to/file`
- Locations: `~/.claude/CLAUDE.md` (global), `./CLAUDE.md` (project)

### Commands → `.claude/commands/`
- Custom slash commands as markdown files
- Frontmatter: allowed-tools, description, model
- Arguments: `$1`, `$2`, `$ARGUMENTS`

### Skills → `.claude/skills/`
- SKILL.md with name + description frontmatter
- Optional: scripts/, references/, assets/
- Model-invoked based on description triggers

## Critical Rules

1. **ALWAYS read before editing** - Get current state first
2. **Validate JSON** - Use `jq '.' <file>` after changes
3. **Use Edit tool precisely** - Match exact strings
4. **Check precedence** - Higher scope settings override lower

## Precedence (Highest → Lowest)

**Settings:** Enterprise → CLI → Local Project → Shared Project → User
**MCP:** Local → Project → User → Enterprise

## Reference Documentation

Load these as needed for detailed info:

- **settings.md** - All settings.json options
- **hooks.md** - Hook events and configuration
- **mcp.md** - MCP server setup
- **permissions.md** - Permission patterns
- **memory.md** - CLAUDE.md usage
- **slash-commands.md** - Custom commands
- **skills.md** - Skills configuration
- **statusline.md** - Status line setup
