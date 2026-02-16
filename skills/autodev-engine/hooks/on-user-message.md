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

## Context Check
Before routing, check if context length > 100k tokens:
- If YES: Summarize conversation and reset context
- If NO: Proceed with routing

## Always Apply
- Check which tools are available
- Verify file paths exist before editing
- Use task_boundary for complex work
