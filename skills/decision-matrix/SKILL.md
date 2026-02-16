---
name: decision-matrix
description: AI Decision Matrix — guides when to use which Agent/Skill/MCP service. Use this skill at the start of each development session to determine the optimal execution path.
---

# AI Decision Matrix — Intelligent Decision Guide

> This document tells AI Agents **when to use which Agent/Skill/MCP**.
> At the start of each development session, agents should read this matrix to decide the optimal execution path.

## 1. Agent Selection Matrix

Based on the current scenario, automatically select the corresponding agent:

```
User Request
  │
  ├─ "Add feature / Implement xxx / Build xxx"
  │   └→ planner.md → task-decomposer.md → implementer.md
  │
  ├─ "Fix bug / Why doesn't it work / Error occurred"
  │   └→ tdd-guide.md (write failing test) → implementer.md (fix)
  │
  ├─ "Review code / Check quality"
  │   └→ code-reviewer.md
  │
  ├─ "Decompose requirements / Split tasks"
  │   └→ task-decomposer.md
  │
  ├─ "Run dev loop / Continue development"
  │   └→ implementer.md (directly claim next task)
  │
  └─ No explicit instruction but pending tasks exist
      └→ implementer.md (auto-claim highest priority task)
```

### Auto-Detection Logic

| Condition | Action |
|-----------|--------|
| `.dev/requirement.txt` exists but `.dev/task.json` is empty | → task-decomposer decomposes requirements |
| `.dev/task.json` has `pending` tasks | → implementer claims and executes |
| `.dev/task.json` has `in_progress` task | → implementer continues execution |
| All tasks in `.dev/task.json` are `completed` | → Project complete, output summary |
| `.dev/human_review.md` has unresolved items | → Alert user to handle human review first |

## 2. Third-Party Skills Usage Matrix

### When to Use Which Skill

| Scenario Trigger | Use Skill | Install Source |
|------------------|-----------|----------------|
| Bug cannot be located by simple code reading | `systematic-debugging` | `anthropics/courses` |
| Need to write plan before implementation | `writing-plans` | `anthropics/courses` |
| Need to execute plan step-by-step | `executing-plans` | `anthropics/courses` |
| Feature implementation should write tests first | `test-driven-development` | `anthropics/courses` |
| Verification before delivery after implementation | `verification-before-completion` | `anthropics/courses` |
| Need browser automation or E2E testing | `agent-browser` | `vercel-labs/agent-browser` |
| Need to test web application | `webapp-testing` | `anthropics/skills` |
| Need to create custom MCP tool | `mcp-builder` | `anthropics/skills` |
| Need frontend design guidance | `frontend-design` | `anthropics/skills` |
| Need advanced Git operations (rebase, cherry-pick) | `git-advanced-workflows` | Community |

### Installation Commands

```bash
# Auto-installed during initialization (included in plugin install)
claude skill add anthropics/courses --skill systematic-debugging
claude skill add anthropics/courses --skill writing-plans
claude skill add anthropics/courses --skill test-driven-development
claude skill add anthropics/courses --skill verification-before-completion
claude skill add anthropics/skills --skill webapp-testing
claude skill add anthropics/skills --skill mcp-builder

# Install manually as needed
claude skill add vercel-labs/agent-browser --skill agent-browser
claude skill add anthropics/skills --skill frontend-design
```

### Skill Usage Flow Chart

```
Start New Feature
  │
  ├─ Need planning? ──YES──→ writing-plans → executing-plans
  │                  NO
  │                  ↓
  ├─ Complex logic? ──YES──→ test-driven-development (RED → GREEN → REFACTOR)
  │                  NO
  │                  ↓
  ├─ Direct implementation → implementer.md
  │
  ├─ Encounter bug? ──→ systematic-debugging
  │
  ├─ Implementation complete → verification-before-completion
  │
  ├─ Has frontend? ──YES──→ webapp-testing + agent-browser
  │
  └─ Complete ✅
```

## 3. MCP Service Decision Matrix

### When to Start Which MCP

| Task Scenario | MCP Service | Startup Command | Auto/Manual |
|---------------|-------------|-----------------|-------------|
| Frontend dev / E2E testing / Screenshot verification | **Puppeteer** | `npx -y @modelcontextprotocol/server-puppeteer` | ✅ Auto-install |
| Complex architecture decisions / Multi-step reasoning | **Sequential Thinking** | `npx -y @modelcontextprotocol/server-sequential-thinking` | ✅ Auto-install |
| Need to read/write files outside project | **Filesystem** | `npx -y @modelcontextprotocol/server-filesystem <path>` | Manual |
| Need advanced Git operations (cross-repo) | **Git MCP** | `uvx mcp-server-git --repository <path>` | Manual |
| Need GitHub API (PR/Issue/Action) | **GitHub MCP** | `npx -y @modelcontextprotocol/server-github` | Manual |
| Need to fetch web pages/API docs | **Fetch** | `uvx mcp-server-fetch` | Manual |

### MCP Auto-Detection Logic

```
Project Type Detection
  │
  ├─ Has package.json with react/vue/next?
  │   └→ Auto-enable Puppeteer (E2E testing needed)
  │
  ├─ Has .github/ directory?
  │   └→ Recommend enabling GitHub MCP
  │
  ├─ Need to access other files in $HOME?
  │   └→ Recommend enabling Filesystem MCP
  │
  └─ Involves complex architecture design?
      └→ Auto-enable Sequential Thinking
```

### ⚠️ MCP Count Warning

> **Critical: Don't enable too many MCPs simultaneously!**
> Each MCP's tool descriptions consume context window tokens.
> - Keep ≤ 10 MCPs
> - Keep ≤ 80 tools
> - Too many MCPs compress 200K context to ~70K

## 4. Complete Usage Flow

```
┌─────────────────────────────────────────────────────┐
│              Complete Usage Flow                    │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Step 1: Installation                               │
│    /plugin marketplace add <repo>                   │
│    /plugin install autodev-engine@autodev-engine    │
│    ./install.sh                                     │
│                                                     │
│  Step 2: Write Requirements                         │
│    echo "requirements" > .dev/requirement.txt       │
│                                                     │
│  Step 3: Decompose Tasks (in Claude Code)           │
│    /plan decompose                                  │
│    → task-decomposer auto-generates .dev/task.json  │
│                                                     │
│  Step 4: Autonomous Development                     │
│    bash scripts/autodev_engine.sh auto              │
│    → Or in Claude Code: /dev                        │
│    → implementer auto-loops:                        │
│      claim task → implement → test → commit → next  │
│                                                     │
│  Step 5: Monitor                                    │
│    /progress                                        │
│                                                     │
│  Step 6: Human Review (if any)                      │
│    /review human                                    │
│    → Handle items in .dev/human_review.md           │
│                                                     │
│  Step 7: Code Review                                │
│    /review code                                     │
│    → code-reviewer auto-reviews                     │
│                                                     │
│  Step 8: Complete 🎉                                │
│    All tasks completed → Project delivery           │
│                                                     │
└─────────────────────────────────────────────────────┘
```
