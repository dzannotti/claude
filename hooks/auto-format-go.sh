#!/bin/bash

# Auto-format + lint hook for Go files
# Runs gofmt and golangci-lint on modified .go files

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Get modified .go files (staged, unstaged, untracked)
files=$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null)
go_files=$(echo "$files" | grep -E '\.go$' | sort -u)

if [ -z "$go_files" ]; then
  exit 0
fi

# gofmt - always available with Go
if command -v gofmt &>/dev/null; then
  echo "$go_files" | xargs gofmt -w 2>/dev/null || true
fi

# golangci-lint - if available
if command -v golangci-lint &>/dev/null; then
  # Get unique directories containing modified go files
  go_dirs=$(echo "$go_files" | xargs -I{} dirname {} | sort -u)
  for dir in $go_dirs; do
    golangci-lint run --fix "$dir/..." 2>/dev/null || true
  done
fi

exit 0
