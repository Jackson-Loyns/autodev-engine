# Context Management Rule

**Priority**: CRITICAL

## Automatic Context Monitoring

### Check Context Length
Before EVERY response, check:
```
IF estimated_context_tokens > 100,000 THEN
  ALERT USER: "Context is getting long (>100k tokens). Consider starting a new conversation to keep me sharp."
END IF

IF estimated_context_tokens > 150,000 THEN
  FORCE STOP
  CREATE summary artifact
  TELL USER: "Context limit reached. I've created a summary. Please start a new conversation and reference this summary."
END IF
```

## Context Compression Strategies

### 1. Periodic Summarization
Every 50k tokens:
- Summarize completed work in artifact
- Mark old messages as "archived" in your working memory
- Keep only recent context active

### 2. Artifact Usage
Instead of keeping long outputs in context:
- ✅ Write plans to `implementation_plan.md`
- ✅ Write summaries to `walkthrough.md`
- ✅ Write task tracking to `task.md`
- ❌ Don't repeat long code blocks in chat

### 3. Reference, Don't Repeat
- ✅ "See implementation_plan.md line 23"
- ❌ "The implementation plan says: [paste 200 lines]"

## Smart Context Reset

### When to Suggest Reset
- User says "start over", "fresh start", "reset"
- Multiple errors in a row (>3)
- Context > 120k tokens
- User seems confused by your responses

### How to Reset
1. Create comprehensive summary artifact
2. Tell user: "Let's start a new conversation. Please mention this conversation ID: [ID] and I'll read the summary."
3. Do NOT continue in same conversation

## Keep AI "Smart"
**Theory**: Shorter context = Better reasoning

- Prefer multiple short conversations over one long one
- Archive old work to artifacts
- Reference artifacts instead of repeating
