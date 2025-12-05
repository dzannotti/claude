#!/bin/bash

# Auto-format hook for Stop
# Detects biome/prettier and formats modified TS/JS files

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Get modified files (staged, unstaged, untracked) - only JS/TS/JSON
files=$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null)
format_files=$(echo "$files" | grep -E '\.(js|jsx|ts|tsx|mjs|cjs|json)$' | sort -u)

if [ -z "$format_files" ]; then
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

# Detect formatter: biome > prettier
if [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then
  # Biome (Rust binary - doesn't need node/bun runtime)
  if command -v biome &>/dev/null; then
    echo "$format_files" | xargs biome format --write 2>/dev/null || true
  else
    echo "$format_files" | xargs run_pkg biome format --write 2>/dev/null || true
  fi
elif [ -f ".prettierrc" ] || [ -f ".prettierrc.js" ] || [ -f ".prettierrc.json" ] || [ -f "prettier.config.js" ] || [ -f "prettier.config.mjs" ] || grep -q '"prettier"' package.json 2>/dev/null; then
  # Prettier (JS - needs correct runtime)
  if command -v prettier &>/dev/null; then
    echo "$format_files" | xargs prettier --write 2>/dev/null || true
  else
    echo "$format_files" | xargs run_pkg prettier --write 2>/dev/null || true
  fi
fi

exit 0
