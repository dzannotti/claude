#!/bin/bash
# Check if Claude Code docs need updating
# Exit 0 (silent) = fresh, Exit 1 with URLs = stale

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REFS_DIR="$SCRIPT_DIR/../references"
MARKER_FILE="$REFS_DIR/.last-updated"
MAX_AGE_DAYS=14

# Force update if --force passed
if [[ "$1" == "--force" ]]; then
  rm -f "$MARKER_FILE"
fi

# Check staleness
if [[ -f "$MARKER_FILE" ]]; then
  last_update=$(cat "$MARKER_FILE")
  now=$(date +%s)
  age_days=$(( (now - last_update) / 86400 ))

  if [[ $age_days -lt $MAX_AGE_DAYS ]]; then
    exit 0  # Fresh, silent success
  fi
fi

# Stale or no marker - output URLs and exit 1
cat << 'EOF'
⚠️ Claude Code documentation references are stale (>14 days).

Update references by fetching these URLs and updating the corresponding files:

| URL | Reference File |
|-----|----------------|
| https://code.claude.com/docs/en/settings | references/settings.md |
| https://code.claude.com/docs/en/hooks | references/hooks.md |
| https://code.claude.com/docs/en/mcp | references/mcp.md |
| https://code.claude.com/docs/en/iam | references/permissions.md |
| https://code.claude.com/docs/en/memory | references/memory.md |
| https://code.claude.com/docs/en/slash-commands | references/slash-commands.md |
| https://code.claude.com/docs/en/skills | references/skills.md |
| https://code.claude.com/docs/en/statusline | references/statusline.md |

After updating, run: date +%s > ~/.claude/skills/claude-config/references/.last-updated
EOF

exit 1
