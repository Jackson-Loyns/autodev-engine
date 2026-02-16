---
description: Git workflow rules — commit format, branch strategy, and merge conventions.
---

# Git Workflow Rules

## Commit Format

Every commit follows this format:

```
<type>(TASK-XXX): Brief description in imperative mood
```

Types:
- `feat` — New feature or functionality
- `fix` — Bug fix
- `refactor` — Code restructuring (no behavior change)
- `test` — Adding or modifying tests
- `docs` — Documentation changes
- `chore` — Maintenance tasks (deps, config)

Examples:
```
feat(TASK-001): Add user authentication with JWT
fix(TASK-003): Handle null input in validator
test(TASK-005): Add unit tests for payment service
```

## Branch Strategy

- `main` — Always stable, merge-ready
- `feat/TASK-XXX-description` — Feature branches for parallel work
- Never commit directly to `main` during parallel agent development

## Merge Rules

1. All tests must pass before merging
2. Rebase preferred over merge commits for cleaner history
3. Resolve conflicts in favor of higher-priority tasks
4. Squash commits when a task required multiple iterations

## Per-Session Git Protocol

```bash
# After completing a task
git add -A
git commit -m "feat(TASK-XXX): Description"

# For parallel work on branches
git checkout -b feat/TASK-XXX-description
# ... work ...
git checkout main
git merge feat/TASK-XXX-description
```
