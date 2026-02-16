# Agent Behavioral Guide

> Reference documentation for AI agents operating within the autodev-engine framework.
> This is the core behavioral guide that should be referenced as CLAUDE.md in target projects.

## Role and Identity

The AI agent operates as an autonomous coding agent within a full-stack automated development system. Each invocation constitutes a single development session focused on completing exactly one task.

## Startup Protocol

Execute these steps at the beginning of every session, in order:

1. Verify working directory: `pwd`
2. Read progress log: `cat .dev/progress.txt`
3. Read task list: `cat .dev/task.json`
4. Check recent history: `git log --oneline -10`
5. Run initialization if needed: `bash init.sh`
6. Execute smoke tests on existing features
7. Claim the next available task

## Development Loop

Follow this strict cycle for each session:

```
CLAIM TASK → IMPLEMENT → TEST → UPDATE PROGRESS → GIT COMMIT → NEXT TASK
```

### Task Claiming

- Select the highest-priority task with status `pending`
- Check all dependencies are satisfied (status `completed`)
- Set status to `in_progress` with current timestamp
- Use `bash scripts/claim_task.sh` for automated claiming

### Implementation

- Focus on ONE task only per session
- Write clean, production-quality code with proper comments
- Follow existing codebase patterns and conventions
- Never modify task descriptions in task.json

### Testing Requirements

Execute tests in this order:
1. `npm run lint` (if applicable)
2. `npm run build` (if applicable)
3. End-to-end verification of the implemented feature
4. Regression check — verify previously working features
5. Use `bash scripts/run_tests.sh` for automated test execution

### Progress Updates

After each task, append a session record to `.dev/progress.txt`:

```
=== Session: YYYY-MM-DD HH:MM:SS ===
Task: TASK-XXX - Task Title
Status: completed/failed
Details: What was accomplished
Files Modified: list of files
Git Commit: commit hash
===================================
```

Use `bash scripts/update_progress.sh TASK-XXX <status> "<details>"` for automated updates.

### Git Workflow

```bash
git add -A
git commit -m "feat(TASK-XXX): Brief description"
```

Commit message format:
- `feat(TASK-XXX):` for new features
- `fix(TASK-XXX):` for bug fixes
- `refactor(TASK-XXX):` for refactoring
- `test(TASK-XXX):` for test additions

### Blocker Handling

When encountering issues requiring human intervention:
1. Document the issue in `.dev/human_review.md` with full context
2. Include the recommended solution
3. Skip the blocked task
4. Continue with the next available task

## File Conventions

| File | Format | Purpose |
|------|--------|---------|
| `.dev/task.json` | JSON | Task management with priority, dependencies, status |
| `.dev/progress.txt` | Plain text | Chronological session logs |
| `.dev/human_review.md` | Markdown | Issues requiring human decision |
| `.dev/feature_list.json` | JSON | Feature completion tracking |
| `.dev/requirement.txt` | Plain text | Original project requirements |

## Critical Rules

1. **INCREMENTAL**: Complete only ONE task per session
2. **IMMUTABLE TASKS**: Never modify task descriptions
3. **TEST FIRST**: Never mark complete without passing tests
4. **CLEAN STATE**: Always leave codebase merge-ready
5. **LOG EVERYTHING**: Record every session outcome
6. **NO PREMATURE COMPLETION**: Verify full task list before declaring done
