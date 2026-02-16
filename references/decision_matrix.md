# 智能决策矩阵 — AI 自动判断指南

> 本文档告诉 AI Agent **何时使用哪个 Agent/Skill/MCP**。
> 在每个开发会话开始时，Agent 应读取此矩阵来决定最优执行路径。

## 1. Agent 选择矩阵

根据当前场景，自动选择对应的 Agent：

```
用户请求
  │
  ├─ "添加功能 / 实现 xxx / 建一个 xxx"
  │   └→ planner.md → task-decomposer.md → implementer.md
  │
  ├─ "修 Bug / 为什么不工作 / 出错了"
  │   └→ tdd-guide.md (写失败测试) → implementer.md (修复)
  │
  ├─ "审查代码 / 检查质量"
  │   └→ code-reviewer.md
  │
  ├─ "分解需求 / 拆分任务"
  │   └→ task-decomposer.md
  │
  ├─ "运行开发循环 / 继续开发"
  │   └→ implementer.md (直接领取下一个任务)
  │
  └─ 无明确指令，但有 pending 任务
      └→ implementer.md (自动领取最高优先级任务)
```

### 自动检测逻辑

| 条件 | 执行 |
|------|------|
| `.dev/requirement.txt` 存在但 `.dev/task.json` 为空 | → task-decomposer 分解需求 |
| `.dev/task.json` 有 `pending` 任务 | → implementer 领取并执行 |
| `.dev/task.json` 有 `in_progress` 任务 | → implementer 继续执行 |
| `.dev/task.json` 所有任务 `completed` | → 项目完成，输出总结 |
| `.dev/human_review.md` 有未解决项 | → 提醒用户先处理人工审查 |

## 2. 第三方 Skills 使用矩阵

### 何时使用哪个 Skill

| 场景触发条件 | 使用 Skill | 安装来源 |
|-------------|-----------|---------|
| 遇到 Bug 无法通过简单阅读代码定位 | `systematic-debugging` | `anthropics/courses` |
| 需要先写计划再实现 | `writing-plans` | `anthropics/courses` |
| 需要按计划逐步执行 | `executing-plans` | `anthropics/courses` |
| 功能实现应先写测试 | `test-driven-development` | `anthropics/courses` |
| 实现完成后交付前验证 | `verification-before-completion` | `anthropics/courses` |
| 需要浏览器自动化或 E2E 测试 | `agent-browser` | `vercel-labs/agent-browser` |
| 需要测试 Web 应用 | `webapp-testing` | `anthropics/skills` |
| 需要创建自定义 MCP 工具 | `mcp-builder` | `anthropics/skills` |
| 需要前端设计指导 | `frontend-design` | `anthropics/skills` |
| 需要高级 Git 操作（rebase、cherry-pick） | `git-advanced-workflows` | Community |

### 安装命令

```bash
# 初始化时自动安装（已包含在 npx autodev init 中）
claude skill add anthropics/courses --skill systematic-debugging
claude skill add anthropics/courses --skill writing-plans
claude skill add anthropics/courses --skill test-driven-development
claude skill add anthropics/courses --skill verification-before-completion
claude skill add anthropics/skills --skill webapp-testing
claude skill add anthropics/skills --skill mcp-builder

# 按需手动安装
claude skill add vercel-labs/agent-browser --skill agent-browser
claude skill add anthropics/skills --skill frontend-design
```

### Skill 使用流程图

```
开始新功能
  │
  ├─ 需要计划吗？──YES──→ writing-plans → executing-plans
  │                NO
  │                ↓
  ├─ 复杂逻辑？──YES──→ test-driven-development (RED → GREEN → REFACTOR)
  │              NO
  │              ↓
  ├─ 直接实现 → implementer.md
  │
  ├─ 遇到 Bug？──→ systematic-debugging
  │
  ├─ 实现完成 → verification-before-completion
  │
  ├─ 有前端？──YES──→ webapp-testing + agent-browser
  │
  └─ 完成 ✅
```

## 3. MCP 服务决策矩阵

### 何时启动哪个 MCP

| 任务场景 | MCP 服务 | 启动命令 | 自动/手动 |
|----------|---------|---------|----------|
| 前端开发 / E2E 测试 / 截图验证 | **Puppeteer** | `npx -y @modelcontextprotocol/server-puppeteer` | ✅ 自动安装 |
| 复杂架构决策 / 多步推理 | **Sequential Thinking** | `npx -y @modelcontextprotocol/server-sequential-thinking` | ✅ 自动安装 |
| 需要读写项目外文件 | **Filesystem** | `npx -y @modelcontextprotocol/server-filesystem <path>` | 手动 |
| 需要 Git 高级操作（跨仓库） | **Git MCP** | `uvx mcp-server-git --repository <path>` | 手动 |
| 需要 GitHub API（PR/Issue/Action） | **GitHub MCP** | `npx -y @modelcontextprotocol/server-github` | 手动 |
| 需要抓取网页/API 文档 | **Fetch** | `uvx mcp-server-fetch` | 手动 |

### MCP 自动检测逻辑

```
项目类型检测
  │
  ├─ 有 package.json 且含 react/vue/next？
  │   └→ 自动启用 Puppeteer（需要 E2E 测试）
  │
  ├─ 有 .github/ 目录？
  │   └→ 建议启用 GitHub MCP
  │
  ├─ 需要访问 $HOME 下的其他文件？
  │   └→ 建议启用 Filesystem MCP
  │
  └─ 涉及复杂架构设计？
      └→ 自动启用 Sequential Thinking
```

### ⚠️ MCP 数量警告

> **关键：不要同时启用太多 MCP！**
> 每个 MCP 的工具描述会消耗 context window tokens。
> - 保持 ≤ 10 个 MCP
> - 保持 ≤ 80 个 tools
> - 过多 MCP 会将 200K context 压缩到 ~70K

## 4. 完整使用流程

```
┌─────────────────────────────────────────────────────┐
│                完整使用流程                           │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Step 1: 安装                                       │
│    npx autodev init my-project                      │
│    (自动: 复制Skill + 安装Skills + 配置MCP + 创建.dev/)│
│                                                     │
│  Step 2: 写需求                                     │
│    echo "需求描述" > .dev/requirement.txt             │
│                                                     │
│  Step 3: 分解任务 (在 Claude Code 中)                 │
│    /plan decompose                                  │
│    → task-decomposer 自动生成 .dev/task.json          │
│                                                     │
│  Step 4: 自动开发                                    │
│    npx autodev dev auto                             │
│    → 或在 Claude Code 中: /dev                       │
│    → implementer 自动循环:                           │
│      领取任务 → 实现 → 测试 → 提交 → 下一个           │
│                                                     │
│  Step 5: 监控                                       │
│    npx autodev status                               │
│    → 或: /progress                                  │
│                                                     │
│  Step 6: 人工审查 (如果有)                            │
│    /review human                                    │
│    → 处理 .dev/human_review.md 中的项目               │
│                                                     │
│  Step 7: 代码审查                                    │
│    /review code                                     │
│    → code-reviewer 自动审查                          │
│                                                     │
│  Step 8: 完成 🎉                                    │
│    所有任务 completed → 项目交付                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```
