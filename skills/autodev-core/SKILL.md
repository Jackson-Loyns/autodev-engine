---
name: autodev-core
description: 自主开发核心循环 — 任务驱动的增量开发工作流。当需要理解完整的开发循环流程、任务管理规则、或设置自动开发环境时使用此 Skill。
---

# Autodev Core — 自主开发核心

## 核心开发循环

每个 AI 开发会话必须遵循这个严格顺序：

```
ORIENT → VERIFY → CLAIM → IMPLEMENT → TEST → LOG → COMMIT → NEXT
```

### 1. ORIENT（定位）
```bash
cat .dev/progress.txt
cat .dev/task.json
git log --oneline -10
```

### 2. VERIFY（验证）
- 运行现有功能的冒烟测试
- 检查环境是否正常

### 3. CLAIM（领取任务）
```bash
bash scripts/claim_task.sh
```
或手动更新 `task.json`，将最高优先级的 `pending` 任务标记为 `in_progress`。

### 4. IMPLEMENT（实现）
- **只完成一个任务**
- 生产级代码质量
- 遵循现有代码风格

### 5. TEST（测试）
```bash
bash scripts/run_tests.sh
```
顺序：lint → type-check → unit tests → build → E2E

### 6. LOG（记录）
```bash
bash scripts/update_progress.sh TASK-XXX completed "description"
```

### 7. COMMIT（提交）
```bash
git add -A
git commit -m "feat(TASK-XXX): description"
```

### 8. NEXT（下一个）
- 如果有更多 `pending` 任务 → 回到 CLAIM
- 如果所有任务 `completed` → 输出项目总结
- 如果遇到阻塞 → 写入 `.dev/human_review.md`，跳到下一个任务

## 关键规则

| 规则 | 说明 |
|------|------|
| **ONE TASK PER SESSION** | 每次 AI 调用只完成一个任务 |
| **TEST BEFORE COMPLETE** | 所有测试通过才能标记完成 |
| **CLEAN STATE** | 每次会话后代码必须可合并 |
| **IMMUTABLE TASKS** | 不修改 task.json 中的任务描述 |
| **LOG EVERYTHING** | 每次会话追加到 progress.txt |

## 文件作用

| 文件 | 作用 |
|------|------|
| `.dev/task.json` | 任务队列和状态 |
| `.dev/progress.txt` | 会话历史日志 |
| `.dev/human_review.md` | 需要人工介入的事项 |
| `.dev/requirement.txt` | 项目需求 |
| `logs/session_*.log` | 原始 AI 输出 |

## 任务状态转换

```
pending → in_progress → completed
pending → in_progress → failed → pending (retry)
pending → blocked (依赖未满足)
```

## Git 工作流

### Commit 格式

```
<type>(TASK-XXX): brief description
```

类型：
- `feat` — 新功能
- `fix` — Bug 修复
- `refactor` — 重构
- `test` — 添加/修改测试
- `docs` — 文档更改
- `chore` — 维护任务

### 示例

```bash
feat(TASK-001): Add user authentication with JWT
fix(TASK-003): Handle null input in validator
test(TASK-005): Add unit tests for payment service
```

## 初始化新项目

```bash
bash scripts/init_project.sh "project-name" "project description"
```

自动执行：
1. 依赖检查（Node.js, npm, git, jq）
2. Git 初始化
3. 创建 `.dev/` 目录和初始文件
4. 设置脚本权限

## 自动开发循环

```bash
# 自动模式（所有任务完成后停止）
bash scripts/autodev_engine.sh auto

# 固定迭代次数
bash scripts/autodev_engine.sh 5

# 无限循环
bash scripts/autodev_engine.sh infinite
```

## 并行开发

```bash
# 在新终端窗口中运行指定任务
bash scripts/new_window.sh TASK-005 --cli claude
```

参见 `references/multi_agent.md` 了解并行协作约定。
