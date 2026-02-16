# On User Message Hook

**Trigger**: Every user message

## Decision Matrix (Intelligent Routing)

Before responding, analyze the user's request and route to the appropriate agent:

### 1. Feature/Architecture Requests
**Indicators**: "plan", "design", "architecture", "new feature", "how should I"
**Action**: Route to **Planner Agent**
```
Invoke: /plan [feature description]
```

### 2. Implementation/Coding Tasks
**Indicators**: "implement", "write code", "create", "build", "add function"
**Action**: Route to **Implementer Agent**
```
Invoke: /dev [implementation task]
```

### 3. Bug Fixes/Testing
**Indicators**: "bug", "error", "test", "fix", "not working"
**Action**: Route to **TDD Guide Agent**
```
Invoke: /test [bug description]
```

### 4. Code Review Requests
**Indicators**: "review", "check", "audit", "improve", "optimize"
**Action**: Route to **Code Reviewer Agent**
```
Invoke: /review [file or description]
```

### 5. Complex/Multi-Step Tasks
**Indicators**: "complex", "multiple", "large", "decompose"
**Action**: Route to **Task Decomposer Agent**
```
Invoke: Ask Task Decomposer to break down the work
```

## Web Search Decision
Before routing to an agent, check if web search is needed:

### Trigger Web Search For:
- **Latest Info**: "latest", "current", "recent", "2024", "new"
- **Documentation**: "how to use", "API", "documentation", "docs"
- **Examples**: "example", "tutorial", "guide", "show me"
- **Troubleshooting**: "error", "fix", "why", "not working", "issue"
- **Comparison**: "vs", "compare", "better", "which"

### Search Pattern:
```
IF user_request contains search_trigger THEN
  1. search_web(refined_query)
  2. [optionally] read_url_content(specific_url)
  3. Synthesize results
  4. THEN continue with agent routing
END IF
```

### Examples:
- "What's the latest React version?" → search_web THEN answer
- "How to use Stripe API?" → search_web + read_url_content THEN Implementer
- "Fix CORS error" → search_web THEN TDD Guide

## Context Check
Before routing, check if context length > 100k tokens:
- If YES: Summarize conversation and reset context
- If NO: Proceed with routing

## Always Apply
- Check which tools are available
- Verify file paths exist before editing
- Use task_boundary for complex work
