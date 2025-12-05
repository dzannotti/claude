# PR Review Triage

Fetch, evaluate, and respond to all review comments on the current branch's PR.

## Phase 1: Get PR Context

```bash
gh pr view --json number,url,headRefName
```

If no PR exists for this branch, stop and tell me.

## Phase 2: Fetch Review Comments

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments
```

Filter to comments that haven't been replied to yet (check `in_reply_to_id` is null and no replies exist).

## Phase 3: Load Project Standards

Read these files to understand what's acceptable:

- `docs/coding-standards.md` - project style rules
- `.github/copilot-instructions.md` - what reviewers should NOT suggest

## Phase 4: Triage Each Comment

For each comment, categorize it:

### AUTO-DECLINE (reply "Declined - {reason}")

These are explicitly against our standards:

- JSDoc/documentation comments → "Declined - no JSDoc per coding standards"
- Verbose error messages → "Declined - concise errors preferred (coding-standards.md §6)"
- Defensive validation in internal functions → "Declined - validate at boundaries only (coding-standards.md §7)"
- Extracting base types for small unions → "Declined - unnecessary abstraction"
- Adding comments explaining what code does → "Declined - code should be self-documenting (coding-standards.md §1)"

### IMPLEMENT (fix, then reply "Fixed in {sha}")

Valid issues worth fixing:

- Actual bugs or incorrect behavior
- Grammar/naming issues (like "dices" → "die")
- Logic errors the tests don't catch
- Valid edge cases we missed

### NEEDS DISCUSSION (don't reply, flag for me)

Ambiguous cases:

- Human reviewer makes a point that's technically against standards but raises a real concern
- Architectural suggestions that might have merit
- Anything you're genuinely unsure about

## Phase 5: Implement Fixes

For all IMPLEMENT items:

1. Make the fix properly (not just what the comment suggests - sometimes the comment is right about the problem but wrong about the solution)
2. Stage all changes
3. Run `bun run ci` to verify nothing broke

If CI passes, create ONE commit:

```
fix: address PR review feedback

- item 1
- item 2
```

## Phase 6: Reply to Comments

For each comment:

- IMPLEMENT → reply "Fixed in {sha}"
- AUTO-DECLINE → reply with the decline reason
- NEEDS DISCUSSION → list these for me to review

Push the commit and replies.

## Skepticism Guidelines

**Copilot/bot comments**: Extreme skepticism. Most are noise. Look for the 10% that are actually valid.

**Human comments**: Take more seriously, but still validate against our standards. Humans can be wrong too.

**The golden rule**: If implementing the suggestion would make the code longer, more complex, or add unnecessary abstraction - it's probably wrong.
