#!/usr/bin/env bash
# Task Manager Helper
# Manages task.json state transitions and validation

set -e

TASK_FILE=".dev/task.json"

# Functions

get_next_claimable_task() {
    if [ ! -f "$TASK_FILE" ]; then
        echo "ERROR: task.json not found" >&2
        exit 1
    fi
    
    # Use jq to find next claimable task
    jq -r '.tasks[] | select(.status == "pending") | 
           select(.dependencies as $deps | 
                  if ($deps | length) == 0 then true 
                  else all($deps[]; . as $dep | 
                       any(input.tasks[]; .id == $dep and .status == "completed"))
                  end) | 
           .id' "$TASK_FILE" | head -n1
}

claim_task() {
    local task_id="$1"
    local session_id="session_$(date +%s)"
    
    jq --arg id "$task_id" \
       --arg session "$session_id" \
       --arg timestamp "$(date -Iseconds)" \
       '(.tasks[] | select(.id == $id)) |= (
           .status = "in_progress" | 
           .claimed_at = $timestamp | 
           .claimed_by_session = $session
        )' "$TASK_FILE" > "$TASK_FILE.tmp"
    
    mv "$TASK_FILE.tmp" "$TASK_FILE"
    echo "$task_id"
}

complete_task() {
    local task_id="$1"
    local git_commit="${2:-$(git rev-parse HEAD 2>/dev/null || echo 'NO_COMMIT')}"
    
    jq --arg id "$task_id" \
       --arg timestamp "$(date -Iseconds)" \
       --arg commit "$git_commit" \
       '(.tasks[] | select(.id == $id)) |= (
           .status = "completed" | 
           .completed_at = $timestamp | 
           .git_commit = $commit
        ) | 
        .metadata.completed_tasks = ([.tasks[] | select(.status == "completed")] | length) |
        .metadata.last_updated = $timestamp
        ' "$TASK_FILE" > "$TASK_FILE.tmp"
    
    mv "$TASK_FILE.tmp" "$TASK_FILE"
}

fail_task() {
    local task_id="$1"
    local reason="$2"
    
    jq --arg id "$task_id" \
       --arg timestamp "$(date -Iseconds)" \
       --arg reason "$reason" \
       '(.tasks[] | select(.id == $id)) |= (
           .status = "failed" | 
           .failed_at = $timestamp | 
           .failure_reason = $reason
        ) | 
        .metadata.last_updated = $timestamp
        ' "$TASK_FILE" > "$TASK_FILE.tmp"
    
    mv "$TASK_FILE.tmp" "$TASK_FILE"
}

get_task_info() {
    local task_id="$1"
    jq --arg id "$task_id" '.tasks[] | select(.id == $id)' "$TASK_FILE"
}

list_tasks() {
    local status_filter="${1:-all}"
    
    if [ "$status_filter" = "all" ]; then
        jq -r '.tasks[] | "\(.id)\t\(.status)\t\(.title)"' "$TASK_FILE"
    else
        jq -r --arg status "$status_filter" \
           '.tasks[] | select(.status == $status) | "\(.id)\t\(.status)\t\(.title)"' \
           "$TASK_FILE"
    fi
}

get_statistics() {
    jq '{
        total: (.tasks | length),
        completed: ([.tasks[] | select(.status == "completed")] | length),
        in_progress: ([.tasks[] | select(.status == "in_progress")] | length),
        pending: ([.tasks[] | select(.status == "pending")] | length),
        failed: ([.tasks[] | select(.status == "failed")] | length)
    }' "$TASK_FILE"
}

# Main CLI
case "${1:-help}" in
    next)
        get_next_claimable_task
        ;;
    claim)
        claim_task "$2"
        ;;
    complete)
        complete_task "$2" "$3"
        ;;
    fail)
        fail_task "$2" "$3"
        ;;
    info)
        get_task_info "$2"
        ;;
    list)
        list_tasks "$2"
        ;;
    stats)
        get_statistics
        ;;
    help|*)
        cat << EOF
Task Manager Helper

Usage:
  $0 next                    Get next claimable task ID
  $0 claim TASK-XXX          Claim a specific task
  $0 complete TASK-XXX [SHA] Mark task complete with optional git commit
  $0 fail TASK-XXX "reason"  Mark task failed with reason
  $0 info TASK-XXX           Get task details
  $0 list [status]           List tasks (all/pending/completed/failed)
  $0 stats                   Get task statistics
EOF
        ;;
esac
