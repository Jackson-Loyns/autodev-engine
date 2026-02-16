#!/bin/bash
# ============================================================
# init.sh — 全流程自动化开发 Skills 系统初始化脚本
# 用途: 初始化开发环境、安装依赖、创建必要文件
# 用法: bash init.sh [项目名称] [需求描述]
# ============================================================

set -euo pipefail

# ---- 颜色定义 ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ---- 工具函数 ----
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[⚠]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }
log_step()    { echo -e "${CYAN}${BOLD}[STEP]${NC} $1"; }

# ---- 获取脚本所在目录 ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="${1:-$(basename "$PROJECT_DIR")}"
REQUIREMENT="${2:-}"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   🚀 全流程自动化开发 Skills 系统 — 初始化      ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================
# STEP 1: 检查依赖
# ============================================================
log_step "1/7 — 检查系统依赖"

check_command() {
    if command -v "$1" &> /dev/null; then
        local version
        version=$($1 --version 2>/dev/null | head -n 1 || echo "已安装")
        log_success "$1: $version"
        return 0
    else
        log_error "$1: 未安装"
        return 1
    fi
}

MISSING_DEPS=0

check_command "node" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "npm" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "git" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "jq" || MISSING_DEPS=$((MISSING_DEPS + 1))

# 检查 AI CLI 工具（至少要有一个）
AI_CLI_FOUND=0
if command -v claude &> /dev/null; then
    log_success "claude CLI: $(claude --version 2>/dev/null | head -n 1 || echo '已安装')"
    AI_CLI_FOUND=1
fi
if command -v codex &> /dev/null; then
    log_success "codex CLI: 已安装"
    AI_CLI_FOUND=1
fi

if [ $AI_CLI_FOUND -eq 0 ]; then
    log_warn "未检测到 AI CLI 工具（claude/codex），自动开发模式将不可用"
fi

if [ $MISSING_DEPS -gt 0 ]; then
    log_error "缺少 $MISSING_DEPS 个必要依赖，请先安装后重试"
    exit 1
fi

echo ""

# ============================================================
# STEP 2: 初始化 Git 仓库
# ============================================================
log_step "2/7 — 初始化 Git 仓库"

if [ -d ".git" ]; then
    log_success "Git 仓库已存在"
else
    git init
    log_success "Git 仓库已初始化"
fi

# 创建 .gitignore（如果不存在）
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/
.npm

# Build
dist/
build/
.next/
out/

# Environment
.env
.env.local
.env.*.local

# Logs
logs/
*.log
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Dev artifacts (保留在版本控制中)
# .dev/ 目录是有意保留的
GITIGNORE
    log_success ".gitignore 已创建"
else
    log_success ".gitignore 已存在"
fi

echo ""

# ============================================================
# STEP 3: 创建 .dev/ 目录及初始文件
# ============================================================
log_step "3/7 — 创建 .dev/ 开发工件目录"

mkdir -p .dev
mkdir -p logs

# 创建 task.json（如果不存在）
if [ ! -f ".dev/task.json" ]; then
    cat > .dev/task.json << TASKJSON
{
  "project": "$PROJECT_NAME",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "total_tasks": 0,
  "completed_tasks": 0,
  "tasks": []
}
TASKJSON
    log_success ".dev/task.json 已创建"
else
    log_success ".dev/task.json 已存在"
fi

# 创建 progress.txt（如果不存在）
if [ ! -f ".dev/progress.txt" ]; then
    cat > .dev/progress.txt << PROGRESS
# 全流程自动化开发 — 进度日志
# 项目: $PROJECT_NAME
# 创建时间: $(date "+%Y-%m-%d %H:%M:%S")
# ============================================

=== Session: $(date "+%Y-%m-%d %H:%M:%S") ===
任务: 初始化
状态: completed
详情: 项目环境初始化完成
===================================
PROGRESS
    log_success ".dev/progress.txt 已创建"
else
    log_success ".dev/progress.txt 已存在"
fi

# 创建 human_review.md（如果不存在）
if [ ! -f ".dev/human_review.md" ]; then
    cat > .dev/human_review.md << 'HUMANREVIEW'
# 🙋 人工待处理事项

> 当 AI 遇到需要人类介入的问题时，会记录在此文件中。
> 人类处理完毕后，将状态改为"已解决"，AI 会在下次 session 中继续。

---

<!-- 示例格式：
## [待处理] 问题标题
- 日期: YYYY-MM-DD
- 相关任务: TASK-XXX
- 问题描述: 描述需要人工处理的内容
- 建议方案: AI 给出的建议
- 状态: 待回复
-->
HUMANREVIEW
    log_success ".dev/human_review.md 已创建"
else
    log_success ".dev/human_review.md 已存在"
fi

# 创建 feature_list.json（如果不存在）
if [ ! -f ".dev/feature_list.json" ]; then
    cat > .dev/feature_list.json << 'FEATURES'
{
  "features": [],
  "last_updated": null,
  "total": 0,
  "passed": 0
}
FEATURES
    log_success ".dev/feature_list.json 已创建"
else
    log_success ".dev/feature_list.json 已存在"
fi

echo ""

# ============================================================
# STEP 4: 确保脚本可执行
# ============================================================
log_step "4/7 — 设置脚本权限"

# 设置当前目录下所有 .sh 文件可执行
find "$SCRIPT_DIR" -name "*.sh" -exec chmod +x {} \;
if [ -d "$SCRIPT_DIR/scripts" ]; then
    find "$SCRIPT_DIR/scripts" -name "*.sh" -exec chmod +x {} \;
fi
log_success "所有 Shell 脚本已设置为可执行"

echo ""

# ============================================================
# STEP 5: 检查并安装推荐 Skills
# ============================================================
log_step "5/7 — 检查推荐 Skills"

if command -v claude &> /dev/null; then
    log_info "推荐安装以下 Skills（从 skills.sh）："
    echo "  • systematic-debugging   — obra/superpowers"
    echo "  • writing-plans          — obra/superpowers"
    echo "  • test-driven-development — obra/superpowers"
    echo "  • webapp-testing         — anthropics/skills"
    echo "  • mcp-builder            — anthropics/skills"
    echo "  • frontend-design        — anthropics/skills"
    echo "  • verification-before-completion — obra/superpowers"
    echo "  • executing-plans        — obra/superpowers"
    echo ""
    log_info "安装命令: bash scripts/setup_skills.sh"
else
    log_warn "未检测到 claude CLI，跳过 Skills 检查"
fi

echo ""

# ============================================================
# STEP 6: 检查 MCP 配置
# ============================================================
log_step "6/7 — 检查 MCP 配置"

MCP_CONFIG="$HOME/.claude/claude_desktop_config.json"
if [ -f "$MCP_CONFIG" ]; then
    log_success "MCP 配置文件已存在: $MCP_CONFIG"
else
    log_info "MCP 配置模板位于: config/mcp_config.json"
    log_info "请参考 docs/mcp_guide.md 进行配置"
fi

echo ""

# ============================================================
# STEP 7: 初始提交
# ============================================================
log_step "7/7 — 创建初始 Git 提交"

# 检查是否有初始提交
if git rev-parse HEAD &>/dev/null 2>&1; then
    log_success "Git 仓库已有提交历史"
else
    git add -A
    git commit -m "chore: 初始化全流程自动化开发 Skills 系统

- 创建 CLAUDE.md 主提示词文档
- 创建 AGENTS.md 多 Agent 兼容文档
- 创建 init.sh 初始化脚本
- 创建 .dev/ 开发工件目录
- 创建 scripts/ 自动化脚本目录
- 创建 config/ 配置目录
- 创建 templates/ 模板目录
- 创建 docs/ 文档目录"
    log_success "初始 Git 提交已创建"
fi

echo ""

# ============================================================
# 完成提示
# ============================================================
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   ✅ 初始化完成！                                ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "📋 下一步操作:"
echo -e "  1. 安装 Skills:  ${CYAN}bash scripts/setup_skills.sh${NC}"
echo -e "  2. 配置 MCP:     ${CYAN}参考 docs/mcp_guide.md${NC}"
echo -e "  3. 输入需求拆解: ${CYAN}bash autodev.sh 1${NC} (首次运行会进行需求拆解)"
echo -e "  4. 无限开发:     ${CYAN}bash autodev.sh infinite${NC}"
echo ""

# 如果提供了需求描述，提示可以开始拆解
if [ -n "$REQUIREMENT" ]; then
    log_info "检测到需求描述: $REQUIREMENT"
    log_info "将在首次 autodev.sh 运行时进行需求拆解"
    echo "$REQUIREMENT" > .dev/requirement.txt
    log_success "需求描述已保存至 .dev/requirement.txt"
fi
