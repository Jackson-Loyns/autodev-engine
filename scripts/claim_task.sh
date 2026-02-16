#!/bin/bash
# ============================================================
# claim_task.sh — Task Claiming Script
# Selects the highest-priority pending task from task.json
# and marks it as in_progress
# Usage: bash scripts/claim_task.sh
# ============================================================

set -euo pipefail

TASK_FILE=".dev/task.json"

if [ ! -f "$TASK_FILE" ]; then
    echo "Error: $TASK_FILE not found"
    exit 1
fi

# Find first pending task (sorted by priority: high > medium > low)
TASK_ID=$(jq -r '
  [.tasks[] | select(.status == "pending")] |
  sort_by(
    if .priority == "high" then 0
    elif .priority == "medium" then 1
    else 2 end
  ) |
  .[0].id // empty
' "$TASK_FILE")

if [ -z "$TASK_ID" ]; then
    echo "No pending tasks available."
    exit 0
fi

# Get task details
TASK_TITLE=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .title" "$TASK_FILE")

# Check dependencies
DEPS=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .dependencies // [] | .[]" "$TASK_FILE")
if [ -n "$DEPS" ]; then
    for DEP in $DEPS; do
        DEP_STATUS=$(jq -r ".tasks[] | select(.id == \"$DEP\") | .status" "$TASK_FILE")
        if [ "$DEP_STATUS" != "completed" ]; then
            echo "Warning: Task $TASK_ID depends on $DEP (status: $DEP_STATUS)"
            echo "Skipping to next available task..."

            # Try next task without unmet dependencies
            TASK_ID=$(jq -r '
              [.tasks[] | select(.status == "pending")] |
              sort_by(if .priority == "high" then 0 elif .priority == "medium" then 1 else 2 end) |
              map(select(
                (.dependencies // []) as $deps |
                all($deps[]; . as $d | [input.tasks[] | select(.id == $d and .status == "completed")] | length > 0)
                or ($deps | length == 0)
              )) |
              .[0].id // empty
            ' "$TASK_FILE")

            if [ -z "$TASK_ID" ]; then
                echo "No tasks with satisfied dependencies available."
                exit 0
            fi
            TASK_TITLE=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .title" "$TASK_FILE")
            break
        fi
    done
fi

# Mark as in_progress
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
jq "(.tasks[] | select(.id == \"$TASK_ID\")) |= . + {\"status\": \"in_progress\", \"assigned_session\": \"$TIMESTAMP\"}" "$TASK_FILE" > "${TASK_FILE}.tmp" && mv "${TASK_FILE}.tmp" "$TASK_FILE"

echo "✓ Claimed task: $TASK_ID - $TASK_TITLE"
echo "  Status: in_progress"
echo "  Assigned at: $TIMESTAMP"
