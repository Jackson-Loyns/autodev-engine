---
description: Core development loop rules — enforced in every development session.
---

# Development Loop Rules

## Session Cycle

Every AI development session MUST follow this exact sequence:

```
ORIENT → VERIFY → CLAIM → IMPLEMENT → TEST → LOG → COMMIT → NEXT
```

Skipping steps is NOT permitted.

## Rules

1. **ONE TASK PER SESSION** — Complete only one task from `.dev/task.json` per session. Never attempt multiple tasks in a single invocation.

2. **ORIENT FIRST** — Always read `.dev/progress.txt`, `.dev/task.json`, and `git log --oneline -10` before doing anything else.

3. **VERIFY ENVIRONMENT** — Run `bash scripts/init_project.sh` if `.dev/` directory is missing. Run smoke tests on existing features.

4. **CLAIM BEFORE IMPLEMENT** — Use `bash scripts/claim_task.sh` or manually update `task.json` to mark a task `in_progress` before writing any code.

5. **CLEAN STATE** — After every session, the codebase must be in a merge-ready state. No half-finished features, no broken tests.

6. **NO PREMATURE COMPLETION** — Before declaring the project complete, verify every task in `task.json` has status `completed`.

7. **BLOCKER PROTOCOL** — If a task cannot be completed, document the blocker in `.dev/human_review.md` with full context and skip to the next pending task.
