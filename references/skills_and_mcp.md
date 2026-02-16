# Skills and MCP Configuration Reference

> Complete reference for recommended Skills from skills.sh and MCP server configuration.

## Recommended Skills

### High Priority

| Skill | Source | Purpose |
|-------|--------|---------|
| systematic-debugging | obra/superpowers | Systematic debugging workflow |
| writing-plans | obra/superpowers | Structured development plans |
| test-driven-development | obra/superpowers | TDD workflow: tests first |
| verification-before-completion | obra/superpowers | Pre-completion verification |
| executing-plans | obra/superpowers | Systematic plan execution |
| agent-browser | vercel-labs/agent-browser | Browser automation for E2E |

### Medium Priority

| Skill | Source | Purpose |
|-------|--------|---------|
| webapp-testing | anthropics/skills | Web application testing |
| mcp-builder | anthropics/skills | Custom MCP tool creation |
| frontend-design | anthropics/skills | Frontend design patterns |
| web-design-guidelines | vercel-labs/agent-skills | Web design standards |
| git-advanced-workflows | community/skills | Advanced Git strategies |

### Low Priority

| Skill | Source | Purpose |
|-------|--------|---------|
| find-skills | vercel-labs/skills | Discover additional skills |

### Installation

```bash
# Install all recommended skills
bash scripts/setup_skills.sh --all

# Interactive selection
bash scripts/setup_skills.sh --select
```

### Compatibility Notes

All listed skills have been verified for compatibility:
- **obra/superpowers** suite: Complementary workflow skills, no conflicts
- **anthropics/skills**: Standalone domain skills
- **vercel-labs**: Design and testing focused, no overlap with obra skills

## MCP Server Configuration

### Required Servers

| Server | Command | Purpose |
|--------|---------|---------|
| Puppeteer | `npx -y @modelcontextprotocol/server-puppeteer` | Browser automation, E2E testing |
| Filesystem | `npx -y @modelcontextprotocol/server-filesystem <path>` | File operations |

### Recommended Servers

| Server | Command | Purpose |
|--------|---------|---------|
| Git | `uvx mcp-server-git --repository <path>` | Git operations |
| GitHub | `npx -y @modelcontextprotocol/server-github` | GitHub API access |
| Sequential Thinking | `npx -y @modelcontextprotocol/server-sequential-thinking` | Structured reasoning |
| Fetch | `uvx mcp-server-fetch` | HTTP content retrieval |

### Configuration Methods

**Method 1: Claude Desktop**
Edit `~/Library/Application Support/Claude/claude_desktop_config.json`

**Method 2: Project Settings**
Add to `.claude/settings.json` in the project root

**Method 3: CLI**
```bash
claude mcp add puppeteer npx -y @modelcontextprotocol/server-puppeteer
claude mcp add github npx -y @modelcontextprotocol/server-github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<token>
```

### Prerequisites

```bash
# Node.js 18+ required for MCP servers
node --version

# uv required for Python-based MCP servers
curl -LsSf https://astral.sh/uv/install.sh | sh
```
