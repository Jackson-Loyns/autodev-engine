# MCP Routing Rule

**Priority**: HIGH

## When to Enable Which MCP

Based on `references/decision_matrix.md` and `references/token_optimization.md`.

## Critical Constraint

⚠️ **Token Limit**: Keep ≤ 10 MCPs, ≤ 80 total tools
- Each MCP tool description consumes context tokens
- Too many MCPs compress 200K context → ~70K effective
- Enable only what's needed for current project

## Required MCPs (Always Enable)

### 1. Filesystem
**When**: Working on any project
**Command**: `npx -y @modelcontextprotocol/server-filesystem /path/to/project`
**Purpose**: File operations outside current directory

### 2. Puppeteer
**When**: Frontend project detected (package.json has react/vue/next)
**Command**: `npx -y @modelcontextprotocol/server-puppeteer`
**Purpose**: Browser automation, E2E testing, screenshots

**Auto-Detection**:
```bash
if grep -q '"react"\|"vue"\|"next"' package.json; then
  echo "Frontend project → Enable Puppeteer MCP"
fi
```

## Recommended MCPs (Project-Specific)

### 3. Sequential Thinking
**When**: Complex architecture decisions, multi-step reasoning
**Command**: `npx -y @modelcontextprotocol/server-sequential-thinking`
**Purpose**: Structured thinking for complex problems

**Trigger**:
- User asks for "architecture design"
- Complex debugging (>3 hypotheses)
- Performance optimization planning

### 4. Git MCP
**When**: Advanced git operations needed
**Command**: `uvx mcp-server-git --repository /path/to/repo`
**Purpose**: Advanced git (rebase, cherry-pick, bisect)

**Trigger**:
- User says "rebase", "cherry-pick", "git bisect"
- Multi-repo project
- Complex git history manipulation

### 5. GitHub MCP
**When**: GitHub API integration needed
**Command**: `npx -y @modelcontextprotocol/server-github`
**Env**: `GITHUB_PERSONAL_ACCESS_TOKEN=<token>`
**Purpose**: PRs, Issues, Actions, Workflows

**Auto-Detection**:
```bash
if [ -d ".github" ]; then
  echo "GitHub project → Suggest GitHub MCP"
fi
```

### 6. Fetch MCP
**When**: Need to scrape docs/APIs
**Command**: `uvx mcp-server-fetch`
**Purpose**: HTTP content retrieval

**Trigger**:
- User asks to "fetch documentation"
- Need to read external API docs
- Web scraping needed

## Optional MCPs (On-Demand)

### 7. Database MCPs
- `mcp-server-postgres` - PostgreSQL operations
- `mcp-server-sqlite` - SQLite operations

**When**: Direct database manipulation needed (rare)

### 8. Cloud Provider MCPs
- `mcp-server-aws` - AWS operations
- `mcp-server-gcp` - Google Cloud

**When**: Cloud infrastructure management

## MCP Selection Matrix

| Project Type | Required MCPs | Recommended MCPs |
|--------------|---------------|------------------|
| Frontend (React/Vue/Next) | Filesystem, Puppeteer | Sequential Thinking |
| Backend API | Filesystem | Git, Sequential Thinking |
| Full-Stack | Filesystem, Puppeteer | Git, GitHub, Sequential Thinking |
| GitHub Integration | Filesystem | Git, GitHub |
| Documentation Site | Filesystem, Puppeteer | Fetch |
| CLI Tool | Filesystem | Git |

## Auto-Detection Logic

Add to `hooks/on-task-start.md`:

```markdown
### MCP Detection
Check project type and suggest MCPs:

1. Read package.json
2. Check for .github/
3. Check for frontend frameworks
4. Suggest appropriate MCPs
5. Warn if >10 MCPs enabled
```

### Detection Script
```bash
#!/bin/bash
# Detect and suggest MCPs

suggest_mcps() {
    local mcps=("filesystem")  # Always needed
    
    # Frontend?
    if grep -q '"react"\|"vue"\|"next"\|"svelte"' package.json 2>/dev/null; then
        mcps+=("puppeteer")
    fi
    
    # GitHub project?
    if [ -d ".github" ]; then
        mcps+=("github" "git")
    fi
    
    # Complex architecture?
    if [ -f ".dev/task.json" ]; then
        local complex=$(jq '[.tasks[] | select(.category == "architecture")] | length' .dev/task.json)
        if [ "$complex" -gt 0 ]; then
            mcps+=("sequential-thinking")
        fi
    fi
    
    echo "Suggested MCPs: ${mcps[@]}"
}
```

## Configuration Methods

### Method 1: Claude Desktop Config
Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/project/path"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

### Method 2: Project-Specific
Create `.claude/mcp_config.json` in project root (covered by autodev init).

### Method 3: CLI
```bash
claude mcp add filesystem npx -y @modelcontextprotocol/server-filesystem .
claude mcp add puppeteer npx -y @modelcontextprotocol/server-puppeteer
```

## Token Optimization

### Monitor Tool Count
```bash
# List all active tools
claude tools list | wc -l

# Should be < 80
```

### Disable Unused MCPs
If tool count > 80:
```json
{
  "mcpServers": {
    "filesystem": { ... },
    "puppeteer": { ... }
  },
  "disabledMcpServers": ["fetch", "github"]  // Disable temporarily
}
```

### Per-Project Config
Don't enable globally if only needed for specific projects.

## Integration with skill-integration.md

Some skills require specific MCPs:

| Skill | Required MCP |
|-------|--------------|
| webapp-testing | Puppeteer |
| agent-browser | Puppeteer |
| mcp-builder | (Creates new MCP) |

Auto-enable MCP when skill is used.

## Verification

After MCP config changes:
1. Restart Claude Code
2. Run `/mcp` to check connected servers
3. Confirm tool count < 80
4. Test MCP functionality

## Troubleshooting

### MCP not connecting
```bash
# Test MCP manually
npx -y @modelcontextprotocol/server-puppeteer

# Check Claude logs
~/.claude/logs/
```

### Too many tools
```bash
# List all MCPs
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | jq '.mcpServers | keys'

# Disable least-used
```

### Performance degradation
Likely too many MCPs. Reduce to ≤ 10.

## Best Practices

1. **Start Minimal**: Enable only filesystem + project-specific
2. **Add On-Demand**: Enable others when needed
3. **Monitor Context**: Watch for context compression
4. **Per-Project**: Use project configs, not global
5. **Disable When Done**: Remove MCPs after use

See `rules/token-optimization.md` for cost management.
