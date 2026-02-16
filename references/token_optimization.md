# Token Optimization Guide

> Reference for managing Claude Code token consumption and cost. Strategies from production usage and everything-claude-code best practices.

## Recommended Settings

Add to `~/.claude/settings.json`:

```json
{
  "model": "sonnet",
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50"
  }
}
```

| Setting | Purpose |
|---------|---------|
| `model: sonnet` | Default to Sonnet for cost efficiency |
| `MAX_THINKING_TOKENS: 10000` | Cap extended thinking to reduce waste |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: 50` | Compact at 50% context instead of default 95% |

Switch to Opus only for deep architectural reasoning:
```
/model opus
```

## Daily Workflow Commands

| Command | When to Use |
|---------|-------------|
| `/model sonnet` | Default for implementation tasks |
| `/model opus` | Complex architecture, debugging deep issues |
| `/clear` | Start fresh session |
| `/compact` | Manually compact context at logical breakpoints |
| `/cost` | Check token usage |

## Strategic Compaction

Compact at logical breakpoints, NEVER mid-implementation:

### ✅ When to Compact
- After research/exploration, before implementation
- After completing a milestone, before starting the next
- After debugging, before continuing feature work
- After a failed approach, before trying a new one

### ❌ When NOT to Compact
- Mid-implementation (lose variable names, file paths, partial state)
- During debugging (lose reproduction steps and hypothesis tracking)
- While writing tests (lose context of what's being tested)

## Context Window Management

**Critical: MCP tools consume context tokens.**

- Keep under **10 MCPs** enabled per project
- Keep under **80 tools** active total
- Use `disabledMcpServers` in project config to disable unused ones

Each MCP tool description consumes tokens from the 200K context window. With too many MCPs, effective context can drop to ~70K.

## Agent Teams Warning

Agent Teams spawn multiple context windows. Each teammate consumes tokens independently.

- Only use for tasks where parallelism provides clear value (multi-module work)
- For sequential tasks, sub-agents are more token-efficient
- Monitor with `/cost` when using teams

## autodev.sh Optimization

The `autodev_engine.sh` script includes built-in cost controls:

| Feature | Setting |
|---------|---------|
| Session wait time | 30s between sessions (avoids rate limits) |
| Consecutive failure limit | 3 failures → auto-stop |
| Dry-run mode | `--dry-run` to preview commands without executing |
| Auto mode | Stops when no pending tasks remain |
