#!/usr/bin/env bash
# Runs `bun run typecheck` at the end of an agent turn (Stop hook).
# Exits non-zero with a visible error list if TS complains, so the
# assistant can't claim "done" on broken code.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR"

# Drain stdin (Claude Code passes hook payload; we don't need it here).
cat >/dev/null || true

echo "[tsc-check] bun run typecheck" >&2
if OUTPUT=$(bun run typecheck 2>&1); then
	echo "[tsc-check] OK" >&2
	exit 0
fi

{
	echo ""
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo "🚨 TypeScript errors — fix before claiming done."
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo "$OUTPUT" | grep -E 'error TS|error:' | head -20
	COUNT=$(echo "$OUTPUT" | grep -cE 'error TS' || true)
	if [ "${COUNT:-0}" -gt 20 ]; then
		echo "... and $((COUNT - 20)) more"
	fi
} >&2

exit 1
