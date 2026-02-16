---
name: review
description: "/review — Trigger code review or check human review items. Usage: /review code, /review human"
---

# /review Command

Trigger code review or manage human review items.

## Usage

```
/review code         # Run code review on recent changes
/review human        # Show items needing human intervention
/review resolve      # Mark a human review item as resolved
```

## Behavior

### /review code
Delegate to `agents/code-reviewer.md`:
1. Identify recently changed files via `git diff --name-only HEAD~1`
2. Run the 5-point review checklist (correctness, security, performance, quality, testing)
3. Output structured review with verdict: APPROVE or REQUEST_CHANGES

### /review human
```bash
cat .dev/human_review.md
```
Display all items that require human decision.

### /review resolve
Interactively mark a human review item as resolved and update the file.
