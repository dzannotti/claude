# Status Line Reference

## Configuration

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

## Input (stdin JSON)

```json
{
  "session_id": "abc123",
  "cwd": "/path",
  "model": {
    "id": "claude-opus-4-1",
    "display_name": "Opus"
  },
  "cost": {
    "total_cost_usd": 0.01,
    "total_duration_ms": 45000
  }
}
```

## Example Script

```bash
#!/bin/bash
read input
model=$(echo "$input" | jq -r '.model.display_name')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd')
echo "[$model] \$$cost"
```

## Notes

- Updates max every 300ms
- ANSI colors supported
- Script must be executable
- Output to stdout
