# Multi-Agent Collaboration Conventions

> Reference for parallel AI agent collaboration within the autodev-engine framework.

## Supported AI Tools

| Tool | Launch Command | Permission Mode |
|------|---------------|-----------------|
| Claude Code | `claude --dangerously-skip-permissions` | Full auto |
| Codex CLI | `codex --full-auto` | Full auto |
| Gemini CLI | `gemini` | Standard |
| GitHub Copilot | `gh copilot` | Standard |

## Parallel Collaboration Rules

### Task Claiming

- Each agent claims tasks exclusively through `.dev/task.json` status field
- Before claiming, verify no other agent has claimed the same task
- Set `assigned_session` to a unique timestamp when claiming
- Never claim a task already marked as `in_progress`

### Branch Management

For parallel development on separate branches:

```bash
# Agent A
git checkout -b feat/TASK-001-feature-name

# Agent B
git checkout -b feat/TASK-002-another-feature
```

### Conflict Resolution

- The agent that commits first to a shared branch wins
- Other agents rebase or merge before pushing
- If file conflicts arise, the task with higher priority takes precedence
- Document all conflicts in `.dev/progress.txt`

### File Locking

To prevent race conditions on shared files:

```bash
# Before modifying a shared file
echo "LOCKED by TASK-XXX at $(date)" > .dev/locks/<filename>.lock

# After completing modifications
rm .dev/locks/<filename>.lock
```

### Communication Between Agents

Agents communicate exclusively through files:
- `.dev/task.json` — Task status coordination
- `.dev/progress.txt` — Session history and context
- `.dev/human_review.md` — Escalation to humans
- `.dev/locks/` — File lock coordination
