#!/bin/bash
# ============================================================
# update_progress.sh — Progress Update Script
# Updates progress.txt and task.json after task completion/failure
# Usage: bash scripts/update_progress.sh <task_id> <status> <details> [commit_hash]
# ============================================================

set -euo pipefail

TASK_FILE=".dev/task.json"
PROGRESS_FILE=".dev/progress.txt"

# Validate arguments
if [ $# -lt 3 ]; then
    echo "Usage: bash scripts/update_progress.sh <task_id> <status> <details> [commit_hash]"
    echo "  status: completed | failed | blocked"
    echo "  details: description of what was done"
    exit 1
fi

TASK_ID="$1"
STATUS="$2"
DETAILS="$3"
COMMIT_HASH="${4:-$(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Validate status
if [[ "$STATUS" != "completed" && "$STATUS" != "failed" && "$STATUS" != "blocked" ]]; then
    echo "Error: Invalid status '$STATUS'. Must be: completed, failed, or blocked"
    exit 1
fi

# Get task info
if [ ! -f "$TASK_FILE" ]; then
    echo "Error: $TASK_FILE not found"
    exit 1
fi

TASK_TITLE=$(jq -r ".tasks[] | select(.id == \"$TASK_ID\") | .title // \"Unknown\"" "$TASK_FILE")

# Update task.json
COMPLETED_AT=""
if [ "$STATUS" = "completed" ]; then
    COMPLETED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq "(.tasks[] | select(.id == \"$TASK_ID\")) |= . + {\"status\": \"$STATUS\", \"completed_at\": \"$COMPLETED_AT\", \"notes\": \"$DETAILS\"}" "$TASK_FILE" > "${TASK_FILE}.tmp" && mv "${TASK_FILE}.tmp" "$TASK_FILE"
else
    jq "(.tasks[] | select(.id == \"$TASK_ID\")) |= . + {\"status\": \"$STATUS\", \"notes\": \"$DETAILS\"}" "$TASK_FILE" > "${TASK_FILE}.tmp" && mv "${TASK_FILE}.tmp" "$TASK_FILE"
fi

# Update completed_tasks count
COMPLETED_COUNT=$(jq '[.tasks[] | select(.status == "completed")] | length' "$TASK_FILE")
jq ".completed_tasks = $COMPLETED_COUNT" "$TASK_FILE" > "${TASK_FILE}.tmp" && mv "${TASK_FILE}.tmp" "$TASK_FILE"

# Get modified files from git
MODIFIED_FILES=$(git diff --name-only HEAD~1 2>/dev/null | tr '\n' ', ' | sed 's/,$//' || echo "N/A")

# Append to progress.txt
cat >> "$PROGRESS_FILE" << ENTRY

=== Session: $TIMESTAMP ===
Task: $TASK_ID - $TASK_TITLE
Status: $STATUS
Details: $DETAILS
Files Modified: $MODIFIED_FILES
Git Commit: $COMMIT_HASH
===================================
ENTRY

echo "✓ Progress updated:"
echo "  Task: $TASK_ID - $TASK_TITLE"
echo "  Status: $STATUS"
echo "  Commit: $COMMIT_HASH"
