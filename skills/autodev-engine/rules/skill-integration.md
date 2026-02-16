# Skill Integration Rule

**Priority**: HIGH

## When to Use Third-Party Skills

Based on `references/decision_matrix.md` and `references/skills_and_mcp.md`, integrate external skills for specific scenarios.

## Recommended Skills from obra/superpowers

### 1. `systematic-debugging` 🐛
**Trigger When**:
- Bug cannot be located by simple code reading
- Intermittent or hard-to-reproduce errors
- User says: "debug", "can't find the bug", "mysterious error"

**Usage**:
```
1. Reproduce the error reliably
2. Form hypothesis about root cause
3. Design minimal test to verify hypothesis
4. Fix and verify
5. Add regression test
```

**Install**: `npx skills add obra/superpowers --skill systematic-debugging`

### 2. `writing-plans` 📝
**Trigger When**:
- Complex feature needs architecture design
- User asks for "plan", "design", or "architecture"
- Task estimated > 2 hours

**Usage**:
```
1. Write structured plan in artifact
2. Break into phases
3. Identify dependencies
4. Get user approval
5. Hand off to executing-plans
```

**Install**: `npx skills add obra/superpowers --skill writing-plans`

### 3. `executing-plans` ⚙️
**Trigger When**:
- A plan artifact exists
- Need systematic implementation
- Multi-step execution required

**Usage**:
```
1. Read plan artifact
2. Execute step-by-step
3. Verify each step before proceeding
4. Update progress in plan
5. Mark complete when all steps done
```

**Install**: `npx skills add obra/superpowers --skill executing-plans`

### 4. `test-driven-development` ✅
**Trigger When**:
- Implementing complex logic
- User requests "TDD" or "write tests first"
- Bug fix needed (write failing test first)

**Usage**:
```
RED → GREEN → REFACTOR cycle:
1. Write failing test
2. Run test (confirm it fails)
3. Write minimal code to pass
4. Run test (confirm it passes)
5. Refactor code
6. Run test (confirm still passes)
```

**Install**: `npx skills add obra/superpowers --skill test-driven-development`

### 5. `verification-before-completion` 🔍
**Trigger When**:
- About to mark task as complete
- Before delivering to user
- After major changes

**Usage**:
```
1. Run all tests
2. Check all acceptance criteria
3. Verify no regressions
4. Review code quality
5. Confirm documentation updated
6. Only then mark complete
```

**Install**: `npx skills add obra/superpowers --skill verification-before-completion`

## Anthropic Skills

### 6. `webapp-testing` 🌐
**Trigger When**:
- Frontend development (React/Vue/Next.js)
- E2E testing needed
- Visual regression testing

**Install**: `npx skills add anthropics/skills --skill webapp-testing`

### 7. `mcp-builder` 🔧
**Trigger When**:
- Need custom MCP tool
- Extending Claude capabilities
- Integrating with custom API

**Install**: `npx skills add anthropics/skills --skill mcp-builder`

### 8. `frontend-design` 🎨
**Trigger When**:
- UI/UX decisions needed
- Design patterns for web
- Accessibility considerations

**Install**: `npx skills add anthropics/skills --skill frontend-design`

## Vercel Labs Skills

### 9. `agent-browser` 🖥️
**Trigger When**:
- Browser automation needed
- Screenshots/testing web apps
- Form filling/scraping

**Install**: `npx skills add vercel-labs/agent-browser`

## Skill Selection Logic

### Decision Flow
```
User Request
  ├─ "debug" → systematic-debugging
  ├─ "plan" → writing-plans
  ├─ "implement plan" → executing-plans
  ├─ "write tests" → test-driven-development
  ├─ "verify" → verification-before-completion
  ├─ "test web app" → webapp-testing
  ├─ "create MCP" → mcp-builder
  ├─ "design UI" → frontend-design
  └─ "browser automation" → agent-browser
```

### Auto-Detection in Hooks

Update `hooks/on-user-message.md`:
```markdown
## Skill Trigger Check
Before routing to internal agents, check if external skill is better suited:

IF message contains ["debug", "can't find bug"] THEN
  Suggest: "I'll use systematic-debugging skill for this"
  Invoke: systematic-debugging
```

## Compatibility

### obra/superpowers Suite
All 5 skills are **complementary** and can be used together:
- systematic-debugging + test-driven-development = Perfect for bug fixes
- writing-plans + executing-plans = Complete feature workflow
- verification-before-completion = Always use before task complete

### No Conflicts
- Anthropic skills are standalone (domain-specific)
- Vercel labs skills don't overlap with obra
- Safe to install all recommended skills

## Integration with Autodev Engine

### With Planner Agent
```
1. User: "Plan login feature"
2. Check: Should I use writing-plans skill?
3. YES → Invoke writing-plans
4. Create structured plan artifact
5. Hand to Implementer or executing-plans
```

### With Implementer Agent
```
1. User: "Implement user registration"
2. Check: Is there a plan? → Invoke executing-plans
3. Check: Complex logic? → Add test-driven-development
4. Implement
5. Before complete → verification-before-completion
```

### With TDD Guide
```
1. User: "Fix password validation bug"
2. Invoke: test-driven-development
3. Write failing test
4. Fix code
5. Verify with verification-before-completion
```

## Installation Automation

Create helper in `helpers/setup-skills.sh`:
```bash
#!/bin/bash
# Install all recommended skills

npx skills add obra/superpowers --skill systematic-debugging
npx skills add obra/superpowers --skill writing-plans
npx skills add obra/superpowers --skill executing-plans
npx skills add obra/superpowers --skill test-driven-development
npx skills add obra/superpowers --skill verification-before-completion

npx skills add anthropics/skills --skill webapp-testing
npx skills add anthropics/skills --skill mcp-builder
npx skills add anthropics/skills --skill frontend-design

npx skills add vercel-labs/agent-browser
```

## Token Optimization

**Important**: Each skill adds tools which consume context.
- Monitor: Keep total tools < 80
- Priority: Install high-priority skills first
- On-Demand: Install low-priority skills only when needed

See `rules/token-optimization.md` for details.
