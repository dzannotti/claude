#!/bin/bash

# Auto-lint hook for Stop
# Detects eslint/biome and fixes modified TS/JS files

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Get modified files (staged, unstaged, untracked) - only JS/TS
files=$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null)
lint_files=$(echo "$files" | grep -E '\.(js|jsx|ts|tsx|mjs|cjs)$' | sort -u)

if [ -z "$lint_files" ]; then
  exit 0
fi

# Detect package manager runner
run_pkg() {
  if [ -f "bun.lockb" ]; then
    bunx "$@"
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm exec "$@"
  else
    npx "$@"
  fi
}

# Detect linter: biome > eslint
if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
  # Biome lint + fix
  if command -v biome &>/dev/null; then
    echo "$lint_files" | xargs biome check --write 2>/dev/null || true
  else
    echo "$lint_files" | xargs run_pkg biome check --write 2>/dev/null || true
  fi
elif [ -f ".eslintrc" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.cjs" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ] || grep -q '"eslint"' package.json 2>/dev/null; then
  # ESLint fix
  if command -v eslint &>/dev/null; then
    echo "$lint_files" | xargs eslint --fix 2>/dev/null || true
  else
    echo "$lint_files" | xargs run_pkg eslint --fix 2>/dev/null || true
  fi
fi

exit 0
