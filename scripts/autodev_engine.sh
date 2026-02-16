
set -euo pipefail

# ---- 颜色定义 ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ---- 默认配置 ----
CLI_TOOL="claude"
MODEL=""
LOG_DIR="logs"
DRY_RUN=false
MAX_ITERATIONS=0   # 0 = 由参数决定
INFINITE=false

# ---- 解析参数 ----
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --cli)
            CLI_TOOL="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --log-dir)
            LOG_DIR="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

# 获取循环次数参数
if [ ${#POSITIONAL[@]} -gt 0 ]; then
    ITER_ARG="${POSITIONAL[0]}"
    if [ "$ITER_ARG" = "infinite" ]; then
        INFINITE=true
    elif [ "$ITER_ARG" = "auto" ]; then
        # 自动根据剩余任务数决定
        MAX_ITERATIONS=0
    else
        MAX_ITERATIONS=$ITER_ARG
    fi
else
    echo "用法: ./autodev.sh <次数|infinite|auto> [--cli claude|codex] [--model <model>]"
    exit 1
fi

# ---- 工具函数 ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"

log_info()    { echo -e "${BLUE}[INFO]${NC} $(date '+%H:%M:%S') $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $(date '+%H:%M:%S') $1"; }
log_warn()    { echo -e "${YELLOW}[⚠]${NC} $(date '+%H:%M:%S') $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $(date '+%H:%M:%S') $1"; }
log_session() { echo -e "${MAGENTA}${BOLD}[SESSION]${NC} $1"; }

# 获取剩余任务数
get_remaining_tasks() {
    if [ -f ".dev/task.json" ]; then
        jq '[.tasks[] | select(.status == "pending" or .status == "in_progress")] | length' .dev/task.json 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# 获取已完成任务数
get_completed_tasks() {
    if [ -f ".dev/task.json" ]; then
        jq '[.tasks[] | select(.status == "completed")] | length' .dev/task.json 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# 获取总任务数
get_total_tasks() {
    if [ -f ".dev/task.json" ]; then
        jq '.tasks | length' .dev/task.json 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# 创建日志目录
mkdir -p "$LOG_DIR"

# ---- Build AI Prompt ----
build_prompt() {
    local session_num=$1
    local remaining=$2
    local completed=$3
    local total=$4

    cat << PROMPT
<role>
You are an autonomous coding agent in a full-stack automated development system. This is development session #${session_num}.
You MUST follow CLAUDE.md in the project root for complete behavioral guidelines.
</role>

<current_state>
- Remaining tasks: ${remaining}/${total}
- Completed tasks: ${completed}/${total}
- Working directory: $(pwd)
</current_state>

<instructions>
Execute the following steps IN ORDER. Do not skip any step.

STEP 1: Orient yourself
Run these commands to understand the current state of the project:
  pwd
  cat .dev/progress.txt
  cat .dev/task.json
  git log --oneline -10

STEP 2: Verify environment
If init.sh exists, run it to ensure the development environment is ready.
Run basic smoke tests to verify existing features still work.

STEP 3: Claim a task
Find the highest-priority task with status "pending" in .dev/task.json.
Change its status to "in_progress" and set assigned_session to the current timestamp.

If there are NO pending tasks but .dev/requirement.txt exists and task.json has no tasks:
- Read the requirement file
- Decompose the requirements into very granular, small tasks (each completable in one session)
- Generate a detailed task.json with all tasks
- Then claim the first task

STEP 4: Implement
- Focus on ONE task only — never attempt to complete everything at once
- Write clean, production-quality code with proper comments
- Follow existing codebase patterns and conventions

STEP 5: Test and verify
Execute in order:
- npm run lint (if applicable)
- npm run build (if applicable)
- End-to-end verification of the implemented feature
- Regression check — ensure previously working features are not broken
It is UNACCEPTABLE to mark a task as completed without passing ALL tests.

STEP 6: Update progress
- Change task status to "completed" (all tests pass) or "failed" (any test fails)
- Append a session record to .dev/progress.txt in this format:

=== Session: $(date "+%Y-%m-%d %H:%M:%S") ===
Task: TASK-XXX - Task Title
Status: completed/failed
Details: What was accomplished or why it failed
Files Modified: list of files
Git Commit: commit hash
===================================

STEP 7: Git commit
  git add -A
  git commit -m "feat(TASK-XXX): Brief description of completed work"

STEP 8: Handle blockers
If you encounter an issue that requires human intervention, write it to .dev/human_review.md with full context and your recommended solution, then skip to the next available task.
</instructions>

<critical_rules>
- INCREMENTAL: Complete only ONE task per session. Never try to do everything at once.
- IMMUTABLE TASKS: Do NOT delete or modify task descriptions in task.json. Only change status, completed_at, notes, and assigned_session fields.
- TEST FIRST: Never mark a task completed without running and passing all relevant tests.
- CLEAN STATE: Leave the codebase in a merge-ready state at the end of every session.
- LOG EVERYTHING: Every completion or failure MUST be recorded in progress.txt.
- DO NOT DECLARE DONE PREMATURELY: Check the full task list before considering the project complete.
</critical_rules>
PROMPT
}

# ============================================================
# 主循环
# ============================================================

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   🤖 全流程自动化开发引擎 — 启动                ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  CLI 工具:  ${CYAN}$CLI_TOOL${NC}"
echo -e "  模型:      ${CYAN}${MODEL:-默认}${NC}"
echo -e "  日志目录:  ${CYAN}$LOG_DIR${NC}"

if $INFINITE; then
    echo -e "  循环模式:  ${YELLOW}无限循环${NC}"
elif [ $MAX_ITERATIONS -eq 0 ]; then
    echo -e "  循环模式:  ${CYAN}自动（根据剩余任务数）${NC}"
else
    echo -e "  循环次数:  ${CYAN}$MAX_ITERATIONS${NC}"
fi

echo ""

SESSION_NUM=0
CONSECUTIVE_FAILURES=0
MAX_FAILURES=3

while true; do
    SESSION_NUM=$((SESSION_NUM + 1))

    # ---- 计算剩余任务 ----
    REMAINING=$(get_remaining_tasks)
    COMPLETED=$(get_completed_tasks)
    TOTAL=$(get_total_tasks)

    # ---- 判断是否继续 ----
    if ! $INFINITE; then
        if [ $MAX_ITERATIONS -gt 0 ] && [ $SESSION_NUM -gt $MAX_ITERATIONS ]; then
            log_info "已达到指定的循环次数 ($MAX_ITERATIONS)，退出"
            break
        fi
        if [ "$ITER_ARG" = "auto" ] && [ $REMAINING -eq 0 ] && [ $TOTAL -gt 0 ]; then
            log_success "所有任务已完成！退出循环"
            break
        fi
    fi

    # ---- 连续失败保护 ----
    if [ $CONSECUTIVE_FAILURES -ge $MAX_FAILURES ]; then
        log_error "连续失败 $MAX_FAILURES 次，暂停循环。请检查 .dev/progress.txt 和 .dev/human_review.md"
        break
    fi

    # ---- Session 信息 ----
    SESSION_TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
    SESSION_LOG="$LOG_DIR/session_${SESSION_TIMESTAMP}.log"

    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log_session "Session #$SESSION_NUM 开始"
    echo -e "  任务进度: ${CYAN}$COMPLETED/$TOTAL${NC} 已完成, ${YELLOW}$REMAINING${NC} 待处理"
    echo -e "  日志文件: ${DIM}$SESSION_LOG${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # ---- 构建 Prompt ----
    PROMPT=$(build_prompt "$SESSION_NUM" "$REMAINING" "$COMPLETED" "$TOTAL")

    # ---- 构建命令 ----
    CMD=""
    case "$CLI_TOOL" in
        claude)
            CMD="claude --dangerously-skip-permissions"
            if [ -n "$MODEL" ]; then
                CMD="$CMD --model $MODEL"
            fi
            CMD="$CMD -p \"$PROMPT\""
            CMD="$CMD --output-format stream-json"
            ;;
        codex)
            CMD="codex --full-auto"
            if [ -n "$MODEL" ]; then
                CMD="$CMD --model $MODEL"
            fi
            CMD="$CMD -q \"$PROMPT\""
            ;;
        *)
            log_error "不支持的 CLI 工具: $CLI_TOOL"
            exit 1
            ;;
    esac

    # ---- 执行 ----
    if $DRY_RUN; then
        log_info "[DRY RUN] 将执行: $CMD"
        log_info "[DRY RUN] 日志将保存至: $SESSION_LOG"
        break
    fi

    log_info "调用 $CLI_TOOL CLI..."

    # 将 prompt 保存到临时文件以避免 shell 转义问题
    PROMPT_FILE=$(mktemp)
    echo "$PROMPT" > "$PROMPT_FILE"

    # 执行 AI CLI 并记录日志
    EXIT_CODE=0
    case "$CLI_TOOL" in
        claude)
            if [ -n "$MODEL" ]; then
                claude --dangerously-skip-permissions \
                    --model "$MODEL" \
                    -p "$(cat "$PROMPT_FILE")" \
                    --output-format stream-json \
                    2>&1 | tee "$SESSION_LOG" || EXIT_CODE=$?
            else
                claude --dangerously-skip-permissions \
                    -p "$(cat "$PROMPT_FILE")" \
                    --output-format stream-json \
                    2>&1 | tee "$SESSION_LOG" || EXIT_CODE=$?
            fi
            ;;
        codex)
            if [ -n "$MODEL" ]; then
                codex --full-auto \
                    --model "$MODEL" \
                    -q "$(cat "$PROMPT_FILE")" \
                    2>&1 | tee "$SESSION_LOG" || EXIT_CODE=$?
            else
                codex --full-auto \
                    -q "$(cat "$PROMPT_FILE")" \
                    2>&1 | tee "$SESSION_LOG" || EXIT_CODE=$?
            fi
            ;;
    esac

    # 清理临时文件
    rm -f "$PROMPT_FILE"

    # ---- 评估结果 ----
    if [ $EXIT_CODE -eq 0 ]; then
        log_success "Session #$SESSION_NUM 完成"
        CONSECUTIVE_FAILURES=0
    else
        log_error "Session #$SESSION_NUM 异常退出 (exit code: $EXIT_CODE)"
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    fi

    # ---- 更新动态循环次数 ----
    NEW_REMAINING=$(get_remaining_tasks)
    NEW_COMPLETED=$(get_completed_tasks)
    NEW_TOTAL=$(get_total_tasks)

    log_info "Session 后状态: $NEW_COMPLETED/$NEW_TOTAL 已完成, $NEW_REMAINING 待处理"

    # 如果使用 auto 模式，动态更新
    if [ "$ITER_ARG" = "auto" ]; then
        log_info "自动模式: 剩余 $NEW_REMAINING 个任务"
    fi

    # ---- 短暂休息避免速率限制 ----
    log_info "等待 5 秒后开始下一个 session..."
    sleep 5
done

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   📊 开发引擎运行总结                            ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  总 Session 数: ${CYAN}$SESSION_NUM${NC}"
echo -e "  任务完成:      ${GREEN}$(get_completed_tasks)/$(get_total_tasks)${NC}"
echo -e "  剩余任务:      ${YELLOW}$(get_remaining_tasks)${NC}"
echo -e "  日志目录:      ${DIM}$LOG_DIR/${NC}"
echo ""

# 最终状态
if [ "$(get_remaining_tasks)" -eq 0 ] && [ "$(get_total_tasks)" -gt 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 所有任务已完成！${NC}"
else
    echo -e "${YELLOW}还有 $(get_remaining_tasks) 个任务待处理${NC}"
    echo -e "继续运行: ${CYAN}./autodev.sh auto${NC}"
fi
