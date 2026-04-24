#!/usr/bin/env bash
# Runs `bun run typecheck` at the end of an agent turn (Stop hook).
# Self-gates: silently skips unless the project has a package.json with a
# "typecheck" script and `bun` is on PATH. Exits non-zero with a visible
# error list if TS complains, so the assistant can't claim "done" on
# broken code.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR"

cat >/dev/null || true

[ -f package.json ] || exit 0
command -v bun >/dev/null 2>&1 || exit 0
grep -q '"typecheck"[[:space:]]*:' package.json || exit 0

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
