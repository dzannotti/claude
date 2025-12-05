# Permissions Reference

## Permission Types

| Type | Effect | Precedence |
|------|--------|------------|
| `allow` | No approval needed | Lowest |
| `ask` | Prompts user | Medium |
| `deny` | Blocks tool | Highest |

## Modes

| Mode | Behavior |
|------|----------|
| `default` | Prompt on first use |
| `acceptEdits` | Auto-accept edits |
| `plan` | No modifications |
| `bypassPermissions` | Skip all prompts |

## Structure

```json
{
  "permissions": {
    "allow": ["Bash(npm run:*)"],
    "ask": ["Bash(git push:*)"],
    "deny": ["Read(.env)"],
    "additionalDirectories": ["../docs/"]
  }
}
```

## Bash Patterns

| Pattern | Matches |
|---------|---------|
| `Bash(npm run build)` | Exact |
| `Bash(npm:*)` | Prefix wildcard |

## Read/Edit Patterns

| Pattern | Meaning |
|---------|---------|
| `//path` | Absolute path |
| `~/path` | Home directory |
| `/path` | Relative to settings |
| `path` | Relative to cwd |

## MCP Patterns

| Pattern | Matches |
|---------|---------|
| `mcp__server` | All server tools |
| `mcp__server__tool` | Specific tool |

No wildcards for MCP.
