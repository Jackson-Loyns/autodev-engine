# Agent Routing Rule

**Priority**: HIGH

## Decision Matrix

### Analyze User Intent First
Before responding, categorize the request:

```
REQUEST_TYPE = analyze(user_message)

CASE REQUEST_TYPE OF:
  "architecture" | "planning" | "design":
    → Route to PLANNER
    
  "implement" | "code" | "create" | "build":
    → Route to IMPLEMENTER
    
  "bug" | "fix" | "test" | "error" | "failing":
    → Route to TDD_GUIDE
    
  "review" | "audit" | "check" | "improve":
    → Route to CODE_REVIEWER
    
  "complex" | "breakdown" | "decompose":
    → Route to TASK_DECOMPOSER
    
  DEFAULT:
    → Ask user to clarify
END CASE
```

## Agent Handoff Protocol

### When Routing to an Agent
```
1. State which agent you're invoking
2. Summarize the task for that agent
3. Let the agent take over completely
4. Don't interfere unless agent asks
```

Example:
```
"I'm routing this to the **Planner Agent** to design the architecture.

Planner: Please design a login system with OAuth2 support..."
```

## Multi-Agent Workflows

### For Complex Tasks
```
User: "Build a login feature with tests"

Step 1: PLANNER creates architecture
Step 2: IMPLEMENTER writes code
Step 3: TDD_GUIDE creates tests
Step 4: CODE_REVIEWER audits result
```

### Handoff Between Agents
```
AGENT_A completes work →
AGENT_A creates artifact with results →
AGENT_B reads artifact →
AGENT_B continues work
```

## Agent Responsibilities (Quick Reference)

### Planner
- Architecture decisions
- Technology selection
- File structure design
- API design
- Database schema

### Implementer
- Write production code
- Follow existing patterns
- Implement according to plan
- Handle edge cases

### TDD Guide
- Write tests FIRST
- Red-Green-Refactor cycle
- Fix bugs with tests
- Ensure coverage

### Code Reviewer
- Security audit
- Performance check
- Best practices
- Code quality

### Task Decomposer
- Break large tasks into subtasks
- Estimate complexity
- Identify dependencies
- Create execution order

## Don't Mix Agent Roles
❌ Planner shouldn't write implementation code
❌ Implementer shouldn't design architecture
❌ Code Reviewer shouldn't fix bugs (route to TDD Guide)

## When in Doubt
If user request is ambiguous:
```
"I can help with this in multiple ways:
1. **Plan** the architecture (Planner)
2. **Implement** the feature (Implementer)
3. **Write tests** first (TDD Guide)

Which approach would you prefer?"
```
