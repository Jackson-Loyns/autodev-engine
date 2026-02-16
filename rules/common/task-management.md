---
description: Task management rules — task.json conventions, status transitions, and immutability constraints.
---

# Task Management Rules

## Task Status Transitions

Valid status transitions:

```
pending → in_progress → completed
pending → in_progress → failed → pending (retry)
pending → blocked (dependency not met)
```

## Immutability

**NEVER modify these fields after creation:**
- `id` — Unique task identifier
- `title` — Task title
- `description` — Task instructions
- `acceptance_criteria` — Success criteria
- `dependencies` — Task dependencies

**Allowed to modify:**
- `status` — Current state
- `assigned_session` — Session timestamp
- `completed_at` — Completion timestamp
- `notes` — Session notes and outcomes

## Task Claiming Protocol

1. Select the highest-priority task with status `pending`
2. Verify ALL dependencies have status `completed`
3. Set `status` to `in_progress`
4. Set `assigned_session` to current ISO timestamp
5. Begin implementation

## Completion Protocol

1. Verify ALL acceptance criteria are met
2. Verify ALL tests pass
3. Set `status` to `completed`
4. Set `completed_at` to current ISO timestamp
5. Add `notes` with summary of work done and files modified

## Failure Protocol

1. Set `status` to `failed`
2. Add `notes` explaining what went wrong
3. Document in `.dev/human_review.md` if human intervention needed
4. Proceed to next available task

## File Location

All task data lives in `.dev/task.json`. Use `scripts/claim_task.sh` and `scripts/update_progress.sh` for safe atomic updates.
