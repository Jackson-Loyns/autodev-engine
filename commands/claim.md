---
name: claim
description: "/claim — Claim a specific task from the task queue. Usage: /claim or /claim TASK-005"
---

# /claim Command

Claim a task from `.dev/task.json` for the current session.

## Usage

```
/claim
/claim TASK-005
```

## Behavior

Without arguments:
```bash
bash scripts/claim_task.sh
```
Auto-selects the highest-priority pending task with all dependencies satisfied.

With a task ID:
1. Verify the task exists and has status `pending`
2. Check all dependencies are `completed`
3. Set status to `in_progress` with current timestamp
4. Print the task details for implementation
