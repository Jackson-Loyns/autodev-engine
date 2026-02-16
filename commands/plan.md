---
name: plan
description: "/plan — Create implementation plan for a feature. Usage: /plan \"feature description\" or /plan decompose"
---

# /plan Command

Create an implementation plan or decompose requirements into tasks.

## Usage

```
/plan "Add user authentication with OAuth"
/plan decompose
```

## Behavior

When invoked with a feature description:
1. Delegate to `agents/planner.md` to analyze the requirement
2. Research existing codebase for related patterns
3. Produce a phased implementation plan in `.dev/plan.md`
4. Decompose the plan into tasks in `.dev/task.json` using `agents/task-decomposer.md`

When invoked with `decompose`:
1. Read `.dev/requirement.txt`
2. Delegate to `agents/task-decomposer.md`
3. Generate `.dev/task.json` with all tasks
