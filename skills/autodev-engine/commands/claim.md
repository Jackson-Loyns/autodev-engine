# Claim Task Command

**Command**: `/claim` or `claim-task`

## Purpose
Automatically claim the next highest-priority task from `.dev/task.json` and prepare for implementation.

## Prerequisites
- `.dev/task.json` must exist (run `/dev init` first)
- At least one task with status `pending`

## Execution Steps

### 1. Read task.json
```bash
if [ ! -f ".dev/task.json" ]; then
  echo "❌ Error: .dev/task.json not found"
  echo "Run: /dev init"
  exit 1
fi
```

### 2. Find next claimable task
```javascript
// Selection logic:
// 1. Status must be "pending"
// 2. All dependencies must be "completed"
// 3. Select highest priority (lowest priority number)

const tasks = JSON.parse(task_json).tasks;
const claimable = tasks.filter(t => 
  t.status === "pending" &&
  t.dependencies.every(dep => 
    tasks.find(t2 => t2.id === dep && t2.status === "completed")
  )
);

if (claimable.length === 0) {
  if (tasks.every(t => t.status === "completed")) {
    echo "🎉 All tasks completed!"
  } else {
    echo "⚠️ No claimable tasks (check dependencies)"
  }
  exit 0
}

const next_task = claimable.sort((a, b) => a.priority - b.priority)[0];
```

### 3. Update task status
```javascript
next_task.status = "in_progress";
next_task.claimed_at = new Date().toISOString();
next_task.claimed_by_session = `session_${Date.now()}`;

// Write back to task.json
fs.writeFileSync('.dev/task.json', JSON.stringify(tasks, null, 2));
```

### 4. Display task information
```
╔════════════════════════════════════════════════════════╗
║  CLAIMED TASK                                          ║
╠════════════════════════════════════════════════════════╣
║  ID: TASK-001                                          ║
║  Title: Implement user authentication                  ║
║  Priority: 1 (HIGHEST)                                 ║
║  Estimated: ~2 hours                                   ║
╠════════════════════════════════════════════════════════╣
║  ACCEPTANCE CRITERIA                                   ║
║  - [ ] User can register with email/password           ║
║  - [ ] User can login and receive JWT token            ║
║  - [ ] Password is hashed with bcrypt                  ║
╠════════════════════════════════════════════════════════╣
║  FILES TO MODIFY                                       ║
║  - src/auth/auth.service.ts                           ║
║  - src/auth/auth.controller.ts                        ║
║  - src/users/users.service.ts                         ║
╠════════════════════════════════════════════════════════╣
║  DEPENDENCIES (ALL COMPLETED ✅)                       ║
║  - TASK-000: Project setup                             ║
╚════════════════════════════════════════════════════════╝
```

### 5. Read relevant files (Orient Phase)
```bash
echo "📖 Reading files to understand current state..."

for file in ${task.files_to_modify[@]}; do
  if [ -f "$file" ]; then
    view_file "$file"
  else
    echo "⚠️ File does not exist yet: $file"
  fi
done
```

### 6. Check for conflicts
```bash
# Check if any files are locked by other agents
for file in ${task.files_to_modify[@]}; do
  if [ -f ".dev/locks/${file}.lock" ]; then
    echo "⚠️ WARNING: $file is locked by another session"
    cat ".dev/locks/${file}.lock"
  fi
done
```

### 7. Create session checkpoint
```bash
cat >> .dev/progress.txt << EOF

=== Session Started: $(date -Iseconds) ===
Task: ${task.id} - ${task.title}
Status: in_progress
Claimed by: ${USER}@${HOSTNAME}
Files to modify: ${task.files_to_modify.join(', ')}
===================================

EOF
```

## Implementation Workflow

After claiming, the agent should:

### Orient Phase ✅
1. Read all files mentioned in `files_to_modify`
2. Understand current architecture
3. Identify dependencies

### Plan Phase
1. Break down acceptance criteria into steps
2. Identify test cases needed
3. Plan verification approach

### Implement Phase
1. Write/modify code
2. Follow existing patterns
3. Add comments

### Test Phase
1. Run linting
2. Run existing tests
3. Add new tests for this feature
4. Verify acceptance criteria

### Complete Phase
1. Update task status to `completed`
2. Log to progress.txt
3. Git commit with proper message
4. Move to next task

## Task Completion

When task is complete:
```bash
# Update status
task.status = "completed";
task.completed_at = new Date().toISOString();

# Write commit
git add -A
git commit -m "feat(${task.id}): ${task.title}"

# Log completion
cat >> .dev/progress.txt << EOF
=== Session Completed: $(date -Iseconds) ===
Task: ${task.id} - ${task.title}
Status: completed ✅
Git Commit: $(git rev-parse HEAD)
Details: All acceptance criteria met
===================================
EOF
```

## Error Handling

### If task fails
```bash
# Update status
task.status = "failed";
task.failed_at = new Date().toISOString();
task.failure_reason = "Description of issue";

# Create human review entry
cat >> .dev/human_review.md << EOF

## ${task.id}: ${task.title}

**Status**: Failed
**Reason**: ${failure_reason}
**Recommended Solution**: ${suggested_fix}

### Context
[Provide full context of the issue]

### Attempted Solutions
1. Attempt 1 - Result
2. Attempt 2 - Result

---
EOF
```

## Usage Example

```
User: "Claim the next task and start working"

Agent: [Calls claim command]
Agent: 
╔════════════════════════════════════╗
║  CLAIMED: TASK-003                 ║
║  Title: Add password reset         ║
╚════════════════════════════════════╝

[Reads relevant files]
[Begins implementation]
```

## Safety Features

- ✅ Checks dependencies before claiming
- ✅ Prevents claiming if files are locked
- ✅ Logs every session start
- ✅ Maintains task state integrity
- ✅ Automatic rollback on failure
