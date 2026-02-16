---
name: progress
description: "/progress — Display current development progress, task completion status, and session history."
---

# /progress Command

Display development progress dashboard.

## Usage

```
/progress
/progress detail
```

## Behavior

### /progress (default)
Read and display summary from `.dev/` files:

```bash
echo "=== Task Summary ==="
jq '{total: (.tasks | length), completed: [.tasks[] | select(.status=="completed")] | length, in_progress: [.tasks[] | select(.status=="in_progress")] | length, pending: [.tasks[] | select(.status=="pending")] | length}' .dev/task.json

echo "=== Recent Sessions ==="
tail -30 .dev/progress.txt

echo "=== Human Review Items ==="
cat .dev/human_review.md
```

### /progress detail
Show full task list with statuses, dependencies, and completion timestamps.
