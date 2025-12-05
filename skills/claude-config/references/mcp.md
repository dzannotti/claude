# MCP Configuration Reference

## Transport Types

| Type | Command |
|------|---------|
| HTTP | `claude mcp add --transport http <name> <url>` |
| Stdio | `claude mcp add --transport stdio <name> -- <cmd>` |

## Scopes

| Scope | Storage | Use |
|-------|---------|-----|
| Local | `~/.claude.json` | Current project |
| Project | `.mcp.json` | Team shared |
| User | `~/.claude.json` | All projects |

**Precedence:** Local > Project > User

## .mcp.json Structure

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@org/server"],
      "env": {
        "API_KEY": "${MY_KEY:-default}"
      }
    }
  }
}
```

## Environment Variables

- `${VAR}` - Direct substitution
- `${VAR:-default}` - With fallback

Works in: command, args, env, url, headers

## Commands

```bash
claude mcp list
claude mcp get <name>
claude mcp remove <name>
claude mcp add-json <name> '<json>'
/mcp  # in Claude
```

## Settings Integration

```json
{
  "enabledMcpjsonServers": ["memory"],
  "disabledMcpjsonServers": ["filesystem"]
}
```
