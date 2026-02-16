# Autodev Engine

Full-stack autonomous development engine — transforms AI coding agents into self-directed developers.

> Inspired by [Anthropic Effective Harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents), [GitHub Spec-Kit](https://github.com/github/spec-kit), and [Everything Claude Code](https://github.com/affaan-m/everything-claude-code).

## 🚀 Quick Start

```bash
# Step 1: Add marketplace
/plugin marketplace add <your-github>/autodev-engine

# Step 2: Install plugin (includes agents/commands/skills)
/plugin install autodev-engine@autodev-engine

# Step 3: Install rules (required — plugins cannot auto-distribute rules)
git clone https://github.com/<your-repo>/autodev-engine.git
cd autodev-engine
./install.sh

# Step 4: (Optional) Copy scripts to project and initialize
./install.sh --project --scripts
cd <your-project>
bash scripts/init_project.sh "my-app"
```

## 📥 Installation

### Method 1: Plugin Installation (Recommended)

```bash
# Add marketplace
/plugin marketplace add <github-user>/autodev-engine

# Install plugin
/plugin install autodev-engine@autodev-engine

# Manually install rules (Claude Code plugin system limitation)
git clone <repo-url>
cd autodev-engine
./install.sh              # Install rules globally to ~/.claude/rules/
./install.sh --project    # Install rules to project .claude/rules/
./install.sh --project --scripts  # Also copy scripts/
```

### Method 2: Manual Installation

```bash
git clone <repo-url>
cd autodev-engine

# Copy rules
cp -r rules/common/* ~/.claude/rules/

# Copy agents
cp agents/*.md ~/.claude/agents/

# Copy commands
cp commands/*.md ~/.claude/commands/

# Copy skills
cp -r skills/* ~/.claude/skills/

# (Optional) Copy scripts
cp -r scripts <your-project>/
```

## 📦 Contents

| Component | Count | Description |
|-----------|-------|-------------|
| **Agents** | 5 | `planner`, `implementer`, `tdd-guide`, `code-reviewer`, `task-decomposer` |
| **Commands** | 6 | `/plan`, `/dev`, `/claim`, `/test`, `/progress`, `/review` |
| **Skills** | 2 | `decision-matrix` (AI decision guide), `autodev-core` (core dev loop) |
| **Rules** | 4 | `dev-loop`, `git-workflow`, `testing`, `task-management` |
| **Scripts** | 7 | `init_project.sh`, `autodev_engine.sh`, `claim_task.sh`, `update_progress.sh`, `run_tests.sh`, `setup_skills.sh`, `new_window.sh` |

## ⚡ Usage

### Claude Code Slash Commands

| Command | Description |
|---------|-------------|
| `/plan "feature"` | Create implementation plan |
| `/plan decompose` | Decompose requirements into tasks |
| `/dev` | Auto-claim and execute next task |
| `/claim TASK-005` | Claim specific task |
| `/test run` | Run all tests |
| `/test tdd` | TDD workflow |
| `/progress` | View development progress |
| `/review code` | Code review |
| `/review human` | View human review items |

### Automation Scripts (if scripts installed)

```bash
# Initialize project
bash scripts/init_project.sh "my-app" "Build a task management web app"

# Start autonomous development loop
bash scripts/autodev_engine.sh auto           # Stop when all tasks complete
bash scripts/autodev_engine.sh 5              # Run 5 iterations
bash scripts/autodev_engine.sh infinite       # Infinite loop

# Manual operations
bash scripts/claim_task.sh                    # Claim next task
bash scripts/run_tests.sh                     # Run tests
bash scripts/update_progress.sh TASK-001 completed "Implementation complete"
```

## 🧠 AI Decision Intelligence

### Auto-Agent Selection (see `skills/decision-matrix`)

| Scenario | Auto-Execute |
|----------|--------------|
| User says "add feature" | `planner` → `task-decomposer` → `implementer` |
| User says "fix bug" | `tdd-guide` → `implementer` |
| Code complete | `code-reviewer` |
| Requirements but no tasks | `task-decomposer` |
| Pending tasks exist | `implementer` auto-claim |

### Recommended Third-Party Skills

Installation commands (in Claude Code):

```bash
# Required
claude skill add anthropics/courses --skill systematic-debugging
claude skill add anthropics/courses --skill writing-plans
claude skill add anthropics/courses --skill test-driven-development
claude skill add anthropics/courses --skill verification-before-completion

# Optional
claude skill add anthropics/skills --skill webapp-testing
claude skill add anthropics/skills --skill mcp-builder
claude skill add vercel-labs/agent-browser --skill agent-browser
```

See `skills/decision-matrix` for when to use which skill.

### Recommended MCP Services

Auto-configured:

```bash
# Puppeteer — Frontend dev, E2E testing
claude mcp add puppeteer -- npx -y @modelcontextprotocol/server-puppeteer

# Sequential Thinking — Complex architecture decisions
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

## 🛡️ Core Rules

1. **One Task Per Session** — Single AI invocation completes only one task
2. **Test First** — All tests must pass before task completion
3. **Clean State** — Codebase must be merge-ready after every session
4. **Log Everything** — Every session appends to progress.txt
5. **Immutable Tasks** — Never modify task descriptions in task.json

See `rules/common/` for details.

## 📁 Project Structure

```
autodev-engine/
├── .claude-plugin/
│   └── plugin.json              # Plugin declaration
├── agents/ (5)                  # AI sub-agents
├── commands/ (6)                # Claude Code slash commands
├── skills/ (2)                  # Skills (decision-matrix, autodev-core)
├── rules/common/ (4)            # Development rules (cannot distribute via plugin)
├── scripts/ (7)                 # Automation scripts
├── assets/                      # Templates and config examples
├── references/                  # Reference documentation
├── install.sh                   # Rules installation script
└── README.md
```

## 📖 Complete Usage Flow

```
Step 1: /plugin marketplace add <repo>
Step 2: /plugin install autodev-engine@autodev-engine
Step 3: ./install.sh --project --scripts (one-time)
Step 4: bash scripts/init_project.sh "my-app"
Step 5: echo "requirements" > .dev/requirement.txt
Step 6: /plan decompose            (AI decomposes tasks)
Step 7: bash scripts/autodev_engine.sh auto  (AI autonomous loop)
Step 8: /review code               (Code review)
Step 9: Project complete 🎉
```

## 📚 References

- [Anthropic Effective Harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [GitHub Spec-Kit](https://github.com/github/spec-kit)
- [Everything Claude Code](https://github.com/affaan-m/everything-claude-code)
- [Claude Code Plugin Documentation](https://code.claude.com/docs/en/plugins)
