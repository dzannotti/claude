# Hooks Reference

## Events

| Event | When | Use Case |
|-------|------|----------|
| `PreToolUse` | Before tool execution | Validate/modify input |
| `PostToolUse` | After tool success | React to results |
| `PermissionRequest` | Permission dialog | Auto-approve/deny |
| `Notification` | Notifications sent | Custom alerts |
| `UserPromptSubmit` | Before processing prompt | Inject context |
| `Stop` | Agent finishes | Post-response actions |
| `SubagentStop` | Subagent completes | Subagent cleanup |
| `SessionStart` | Session init | Setup environment |
| `SessionEnd` | Session end | Cleanup/logging |

## Structure

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "my-script.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## Matcher Patterns (PreToolUse, PostToolUse)

| Pattern | Matches |
|---------|---------|
| `Write` | Exact tool |
| `Edit\|Write` | Regex OR |
| `*` | All tools |
| `mcp__server__tool` | MCP tool |

## Exit Codes

| Code | Behavior |
|------|----------|
| 0 | Success |
| 2 | Blocking error |
| Other | Non-blocking |

## Environment Variables

- `$CLAUDE_PROJECT_DIR` - Project root
- `$CLAUDE_CODE_REMOTE` - "true" for web

## JSON Response

```json
{
  "continue": true,
  "decision": "allow|deny|block",
  "additionalContext": "info for Claude",
  "updatedInput": {}
}
```
