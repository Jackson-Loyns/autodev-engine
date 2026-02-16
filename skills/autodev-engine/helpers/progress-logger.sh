#!/usr/bin/env bash
# Progress Logger Helper
# Logs session progress to .dev/progress.txt

set -e

PROGRESS_FILE=".dev/progress.txt"

log_session_start() {
    local task_id="$1"
    local task_title="$2"
    
    cat >> "$PROGRESS_FILE" << EOF

=== Session Started: $(date -Iseconds) ===
Task: $task_id - $task_title
Status: in_progress
User: ${USER:-unknown}@${HOSTNAME:-unknown}
Working Directory: $(pwd)
===================================

EOF
}

log_session_complete() {
    local task_id="$1"
    local task_title="$2"
    local git_commit="${3:-NO_COMMIT}"
    local details="${4:-Task completed successfully}"
    
    cat >> "$PROGRESS_FILE" << EOF
=== Session Completed: $(date -Iseconds) ===
Task: $task_id - $task_title
Status: completed ✅
Git Commit: $git_commit
Details: $details
===================================

EOF
}

log_session_failed() {
    local task_id="$1"
    local task_title="$2"
    local reason="$3"
    
    cat >> "$PROGRESS_FILE" << EOF
=== Session Failed: $(date -Iseconds) ===
Task: $task_id - $task_title
Status: failed ❌
Reason: $reason
===================================

EOF
}

log_custom_entry() {
    local message="$1"
    
    cat >> "$PROGRESS_FILE" << EOF
[$(date -Iseconds)] $message
EOF
}

get_recent_sessions() {
    local count="${1:-5}"
    grep "=== Session" "$PROGRESS_FILE" | tail -n "$((count * 2))"
}

get_today_sessions() {
    local today=$(date +%Y-%m-%d)
    grep "$today" "$PROGRESS_FILE" | grep "=== Session"
}

# Main CLI
case "${1:-help}" in
    start)
        log_session_start "$2" "$3"
        ;;
    complete)
        log_session_complete "$2" "$3" "$4" "$5"
        ;;
    fail)
        log_session_failed "$2" "$3" "$4"
        ;;
    log)
        log_custom_entry "$2"
        ;;
    recent)
        get_recent_sessions "$2"
        ;;
    today)
        get_today_sessions
        ;;
    help|*)
        cat << EOF
Progress Logger Helper

Usage:
  $0 start TASK-XXX "Title"           Log session start
  $0 complete TASK-XXX "Title" SHA    Log completion
  $0 fail TASK-XXX "Title" "reason"   Log failure
  $0 log "message"                    Log custom entry
  $0 recent [N]                       Show recent N sessions (default: 5)
  $0 today                            Show today's sessions
EOF
        ;;
esac
