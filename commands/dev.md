---
name: dev
description: "/dev — Start autonomous development loop. Claims next task, implements, tests, commits."
---

# /dev Command

Start the autonomous development loop for the current project.

## Usage

```
/dev
/dev TASK-005
```

## Behavior

Without arguments:
1. Read `.dev/progress.txt` and `.dev/task.json` for current state
2. Run `bash scripts/claim_task.sh` to auto-select the highest-priority pending task
3. Delegate to `agents/implementer.md` to execute the full development cycle
4. Repeat: claim → implement → test → progress → commit

With a specific task ID:
1. Claim the specified task directly
2. Execute the development cycle for that task only

## Prerequisites

- `.dev/task.json` must exist with pending tasks
- `init_project.sh` must have been run
