#!/bin/bash
# ============================================================
# new_window.sh — New Window Task Dispatch
# Opens a new terminal window to execute a sub-task
# Simulates the /new command for parallel task execution
# Usage: bash scripts/new_window.sh <task_id> [--cli claude|codex]
# ============================================================

set -euo pipefail

TASK_ID="${1:-}"
CLI_TOOL="${2:-claude}"
PROJECT_DIR="$(pwd)"

if [ -z "$TASK_ID" ]; then
    echo "Usage: bash scripts/new_window.sh <task_id> [--cli claude|codex]"
    exit 1
fi

# Get task details
TASK_FILE=".dev/task.json"
if [ ! -f "$TASK_FILE" ]; then
    echo "Error: $TASK_FILE not found"
    exit 1
fi

TASK_TITLE=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .title // \"Unknown\"" "$TASK_FILE")
TASK_DESC=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .description // \"\"" "$TASK_FILE")

if [ "$TASK_TITLE" = "Unknown" ]; then
    echo "Error: Task $TASK_ID not found in $TASK_FILE"
    exit 1
fi

echo "Dispatching task $TASK_ID to new window..."
echo "  Title: $TASK_TITLE"
echo "  CLI: $CLI_TOOL"

# Build the prompt for the new window
PROMPT="<role>
You are an autonomous coding agent. You have been assigned a specific task to complete.
Read CLAUDE.md for full behavioral guidelines.
</role>

<task>
Task ID: $TASK_ID
Title: $TASK_TITLE
Description: $TASK_DESC
</task>

<instructions>
1. Read CLAUDE.md for development conventions
2. Read .dev/progress.txt for context
3. Mark task $TASK_ID as in_progress in .dev/task.json
4. Implement the task
5. Run tests: bash scripts/run_tests.sh
6. Update progress: bash scripts/update_progress.sh $TASK_ID completed \"<details>\"
7. Git commit with descriptive message
</instructions>"

# Open new terminal window based on OS
case "$(uname)" in
    Darwin)
        # macOS - use osascript to open new Terminal window
        osascript << APPLESCRIPT
tell application "Terminal"
    activate
    do script "cd '$PROJECT_DIR' && $CLI_TOOL --dangerously-skip-permissions -p '$PROMPT'"
end tell
APPLESCRIPT
        echo "✓ New Terminal window opened with task $TASK_ID"
        ;;
    Linux)
        # Linux - try common terminal emulators
        if command -v gnome-terminal &> /dev/null; then
            gnome-terminal -- bash -c "cd '$PROJECT_DIR' && $CLI_TOOL --dangerously-skip-permissions -p '$PROMPT'; exec bash"
        elif command -v xterm &> /dev/null; then
            xterm -e "cd '$PROJECT_DIR' && $CLI_TOOL --dangerously-skip-permissions -p '$PROMPT'" &
        else
            echo "Warning: No supported terminal emulator found. Running in background..."
            nohup bash -c "cd '$PROJECT_DIR' && $CLI_TOOL --dangerously-skip-permissions -p '$PROMPT'" > "logs/task_${TASK_ID}.log" 2>&1 &
        fi
        echo "✓ New window opened with task $TASK_ID"
        ;;
    *)
        echo "Unsupported OS. Running in background..."
        nohup bash -c "cd '$PROJECT_DIR' && $CLI_TOOL --dangerously-skip-permissions -p '$PROMPT'" > "logs/task_${TASK_ID}.log" 2>&1 &
        echo "✓ Background process started for task $TASK_ID (PID: $!)"
        ;;
esac
