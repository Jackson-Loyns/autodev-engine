# Token Optimization Rule

**Priority**: CRITICAL

## Core Principle

**Shorter context = Better reasoning + Lower cost**

Based on `references/token_optimization.md` and production best practices.

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
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: 50` | Compact at 50% context (not 95%) |

## Model Selection Strategy

### Use Sonnet (Default)
- Implementation tasks
- Code reviews
- Testing
- Refactoring
- Bug fixes (simple)

### Switch to Opus Only For
- Deep architectural design
- Complex debugging (>5 hypotheses)
- Performance optimization planning
- Security architecture review

**How to Switch**:
```
/model opus      # Temporarily use Opus
/model sonnet    # Switch back when done
```

## Strategic Compaction

### ✅ When to Compact
- After research/exploration, **before** implementation
- After completing a milestone, **before** starting next
- After debugging, **before** continuing feature work
- After a failed approach, **before** trying new one

### ❌ When NOT to Compact
- **Mid-implementation** (lose variable names, file paths, partial state)
- **During debugging** (lose reproduction steps, hypothesis tracking)
- **While writing tests** (lose context of what's being tested)
- **In the middle of a task** (breaks continuity)

### Manual Compaction
```
/compact    # Compact now at logical breakpoint
/clear      # Start completely fresh session
```

## MCP Tool Count Management

**Critical**: MCP tools consume context tokens.

### Limits
- **≤ 10 MCPs** enabled per project
- **≤ 80 tools** active total

### Why It Matters
Each MCP tool description uses tokens from 200K window.
Too many MCPs → effective context drops to ~70K.

### Check Tool Count
```bash
# Count active tools
claude tools list | wc -l

# Should show < 80
```

### Reduce Tool Count
```json
// In claude_desktop_config.json
{
  "mcpServers": {
    "filesystem": { ... },
    "puppeteer": { ... }
  },
  "disabledMcpServers": ["fetch", "github"]  // Disable unused
}
```

See `rules/mcp-routing.md` for MCP selection.

## Artifact Strategy (Context Compression)

### Use Artifacts for Long Content
Instead of keeping in chat:
- ✅ Write plans → `implementation_plan.md`
- ✅ Write summaries → `walkthrough.md`
- ✅ Track tasks → `task.md`
- ❌ Don't paste long code blocks in chat

### Reference, Don't Repeat
- ✅ "See implementation_plan.md lines 23-45"
- ❌ "The plan says: [paste 200 lines]"

### Why It Works
Artifacts are stored externally. Referencing them uses minimal tokens vs. repeating content inline.

## Agent Teams Warning

**Avoid Agent Teams for Sequential Work**

Agent Teams spawn multiple context windows:
- Each teammate consumes tokens independently
- Only use for truly parallel work (multi-module projects)
- For sequential tasks, sub-agents are more efficient

Monitor with `/cost` when using teams.

## autodev.sh Built-in Optimizations

The `scripts/autodev_engine.sh` includes:

| Feature | Setting |
|---------|---------|
| Session wait time | 30s between sessions (avoid rate limits) |
| Consecutive failure limit | 3 failures → auto-stop |
| Dry-run mode | `--dry-run` preview without executing |
| Auto mode | Stops when no pending tasks |

## Daily Workflow Commands

| Command | When to Use |
|---------|-------------|
| `/model sonnet` | Default for all work |
| `/model opus` | Deep architecture/complex debugging |
| `/clear` | Start fresh session (new feature) |
| `/compact` | At logical breakpoint |
| `/cost` | Check token usage periodically |

## Cost Monitoring

### Check Usage
```
/cost    # Shows current session token usage
```

### Estimate Project Cost
```bash
# Estimate based on task.json
tasks=$(jq '.tasks | length' .dev/task.json)
avg_tokens_per_task=50000  # Conservative estimate

total_tokens=$((tasks * avg_tokens_per_task))
cost_sonnet=$(echo "scale=2; $total_tokens / 1000000 * 3" | bc)  # $3 per 1M tokens
cost_opus=$(echo "scale=2; $total_tokens / 1000000 * 15" | bc)   # $15 per 1M tokens

echo "Estimated cost (Sonnet): \$$cost_sonnet"
echo "Estimated cost (Opus): \$$cost_opus"
```

## Context Length Best Practices

### Auto-Reset at Limits
From `rules/context-management.md`:
- Alert at 100K tokens
- Force summary + stop at 150K tokens

### Manual Reset
When context > 100K:
```
1. Create comprehensive summary artifact
2. Exit conversation
3. Start new conversation
4. Reference summary artifact from previous conversation
```

## Development Loop Optimization

### Per-Task Pattern
```
1. /claim              # Claim task (reads files)
2. [Implement]         # Write code
3. [Test]              # verify
4. /commit             # Git commit
5. COMPACT HERE        # Before next task
6. /claim              # Next task
```

### Why Compact Between Tasks
- Each task is independent
- Previous task details不需要 in context
- Keeps context focused on current work

## Skill & MCP Token Impact

### Skills Add Tools
Each installed skill may add 5-15 tools.
- Monitor total tool count
- Uninstall unused skills

### MCPs Add More Tools
Each MCP adds 3-20 tools depending on server.
- See `rules/mcp-routing.md`
- Disable project-specific MCPs globally

## Production Recommendations

From `everything-claude-code` best practices:

1. **Sonnet First**: Always start with Sonnet
2. **Compact Early**: At 50% context, not 95%
3. **Limit MCPs**: Strictly ≤ 10
4. **Artifacts Heavy**: Move all long content to artifacts
5. **Monitor /cost**: Check after each major task
6. **Fresh Sessions**: New conversation per feature (not per task)

## Integration with Other Rules

- `context-management.md`: Automatic context alerts
- `mcp-routing.md`: MCP selection to minimize tools
- `skill-integration.md`: When to use external skills

## Emergency: Context Overload

If effective context < 100K despite 200K limit:

1. **Check tool count**: `claude tools list | wc -l`
2. **Disable MCPs**: Keep only filesystem
3. **Uninstall skills**: Keep only essential
4. **Compact**: `/compact` immediately
5. **Fresh start**: `/clear` if necessary

See conversation logs and task.md for continuity.
