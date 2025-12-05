# Settings.json Reference

## File Locations

| Location | Purpose | Precedence |
|----------|---------|------------|
| `~/.claude/settings.json` | User global | Lowest |
| `.claude/settings.json` | Project shared | Medium |
| `.claude/settings.local.json` | Project personal | High |
| Enterprise managed | Org policies | Highest |

## All Settings

| Key | Type | Description |
|-----|------|-------------|
| `apiKeyHelper` | string | Script to generate auth headers |
| `cleanupPeriodDays` | number | Days before session cleanup (default: 30) |
| `env` | object | Environment variables for sessions |
| `includeCoAuthoredBy` | boolean | Claude byline in commits (default: true) |
| `permissions` | object | Tool access rules |
| `hooks` | object | Event hooks |
| `disableAllHooks` | boolean | Disable all hooks |
| `model` | string | Override default model |
| `statusLine` | object | Custom status line |
| `outputStyle` | string | System prompt style |
| `alwaysThinkingEnabled` | boolean | Extended thinking |
| `enableAllProjectMcpServers` | boolean | Auto-approve MCP |
| `enabledMcpjsonServers` | array | MCP servers to approve |
| `disabledMcpjsonServers` | array | MCP servers to reject |

## Sandbox Settings

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker"],
    "network": {
      "allowUnixSockets": ["~/.ssh/agent-socket"],
      "allowLocalBinding": true
    }
  }
}
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API key |
| `BASH_DEFAULT_TIMEOUT_MS` | Bash timeout |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output |
| `DISABLE_TELEMETRY` | Opt out telemetry |
| `MAX_THINKING_TOKENS` | Thinking budget |
| `MCP_TIMEOUT` | MCP timeout (ms) |
