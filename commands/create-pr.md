---
description: Create a PR from current changes (checks for main commits, uses conventional branches)
---

# Create Pull Request

## Pre-flight

1. Check for `docs/git-etiquette.md` - follow if exists
2. If on `main` with unpushed commits:
   - Determine conventional branch name: `feat/`, `fix/`, `docs/`, `refactor/`, `chore/`
   - Create branch and move commits: `git checkout -b <branch>` then reset main
3. Never push directly to main

## Create PR

Use `gh pr create` with conventional commit style title and body.

**Body**: Use `.github/PULL_REQUEST_TEMPLATE.md` if exists, otherwise:

```
## Summary
<Brief description>

## Changes
- <bullet points>

## Testing
- [ ] Tests pass
- [ ] Manually verified
```

## Steps

```bash
git status && git log origin/main..HEAD --oneline  # Check state
# If on main with commits: create feature branch
git push -u origin <branch>
gh pr create --title "..." --body "..."
```
