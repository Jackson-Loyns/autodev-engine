# Progress Tracking Command

**Command**: `/progress` or `view-progress`

## Purpose
Display development progress, session history, and task completion statistics.

## Execution Steps

### 1. Read progress.txt
```bash
if [ ! -f ".dev/progress.txt" ]; then
  echo "❌ No progress log found"
  echo "Run: /dev init"
  exit 1
fi
```

### 2. Read task.json for statistics
```javascript
const tasks = JSON.parse(fs.readFileSync('.dev/task.json'));
const total = tasks.tasks.length;
const completed = tasks.tasks.filter(t => t.status === 'completed').length;
const in_progress = tasks.tasks.filter(t => t.status === 'in_progress').length;
const pending = tasks.tasks.filter(t => t.status === 'pending').length;
const failed = tasks.tasks.filter(t => t.status === 'failed').length;
```

### 3. Display summary
```
╔══════════════════════════════════════════════════════╗
║           PROJECT PROGRESS SUMMARY                   ║
╠══════════════════════════════════════════════════════╣
║  Total Tasks:       15                               ║
║  ✅ Completed:       8  (53%)                        ║
║  🔄 In Progress:     1  (7%)                         ║
║  ⏳ Pending:         5  (33%)                        ║
║  ❌ Failed:          1  (7%)                         ║
╠══════════════════════════════════════════════════════╣
║  Progress: ████████████░░░░░░░░  53%                ║
╚══════════════════════════════════════════════════════╝
```

### 4. Display recent sessions
```bash
echo ""
echo "📜 RECENT SESSIONS (Last 5)"
echo "================================"
tail -n 100 .dev/progress.txt | grep "=== Session" | tail -n 10
```

### 5. Display active task(s)
```
🔄 CURRENTLY IN PROGRESS

TASK-007: Implement password reset
  Started: 2024-02-16 14:30:00
  Duration: 45 minutes
  Files modified:
    - src/auth/password-reset.service.ts
    - src/auth/password-reset.controller.ts
```

### 6. Display next pending tasks
```
⏳ NEXT TASKS (Top 3 by priority)

1. TASK-008: Add email verification (Priority: 1)
   Dependencies: ✅ All satisfied
   
2. TASK-009: Implement 2FA (Priority: 2)
   Dependencies: ⏳ Waiting for TASK-007
   
3. TASK-010: Add OAuth providers (Priority: 2)
   Dependencies: ✅ All satisfied
```

### 7. Display human review items (if any)
```bash
if grep -q "## Pending Issues" .dev/human_review.md && \
   ! grep -q "(No issues yet)" .dev/human_review.md; then
  echo ""
  echo "⚠️  HUMAN REVIEW REQUIRED"
  echo "================================"
  grep -A 5 "## Pending Issues" .dev/human_review.md | head -n 10
  echo ""
  echo "See full details: .dev/human_review.md"
fi
```

## Detailed View Options

### Option 1: Full session history
```bash
/progress --full
# Shows complete progress.txt content
```

### Option 2: Specific task history
```bash
/progress TASK-007
# Shows all sessions related to TASK-007
```

### Option 3: Statistics only
```bash
/progress --stats
# Shows only the summary box
```

### Option 4: Export to markdown
```bash
/progress --export progress_report.md
# Creates a formatted markdown report
```

## Git Integration

### Show commits per task
```bash
echo "📊 COMMITS BY TASK"
echo "================================"

for task_id in $(jq -r '.tasks[] | select(.status == "completed") | .id' .dev/task.json); do
  commits=$(git log --oneline --grep="$task_id" | wc -l)
  echo "$task_id: $commits commit(s)"
done
```

## Usage Examples

### Example 1: Quick status check
```
User: "What's the progress?"

Agent: [Calls /progress]
Agent:
╔════════════════════════════╗
║  Progress: 8/15  (53%)     ║
║  🔄 Working on: TASK-007   ║
║  ⏳ Next: TASK-008         ║
╚════════════════════════════╝
```

### Example 2: Before claiming next task
```
User: "Show me what's left to do"

Agent: [Calls /progress]
Agent:
⏳ PENDING TASKS (5 remaining)

1. TASK-008: Email verification (HIGH priority)
2. TASK-009: 2FA (MEDIUM priority)
3. TASK-010: OAuth (MEDIUM priority)
4. TASK-011: Rate limiting (LOW priority)
5. TASK-012: Audit logging (LOW priority)
```

### Example 3: End of day summary
```
User: "Summarize today's work"

Agent: [Calls /progress --full]
Agent:
📊 TODAY'S SESSIONS (2024-02-16)

Session 1: TASK-005 - Database schema ✅
  Duration: 2h 15m
  Commits: 3
  
Session 2: TASK-006 - User CRUD API ✅
  Duration: 1h 45m
  Commits: 2
  
Session 3: TASK-007 - Password reset 🔄 (In progress)
  Duration: 45m so far
  
Total: 4h 45m, 2 tasks completed
```

## Integration with Other Commands

- **After `/claim`**: Automatically shows progress
- **After task completion**: Updates statistics
- **Before `/dev auto`**: Shows remaining work
- **With `/review human`**: Highlights blocked items
