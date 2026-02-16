# On Task Start Hook

**Trigger**: When starting a new task (via task_boundary)

## Pre-Task Checklist

### 1. Context Management
```
IF context_length > 80k tokens THEN
  - Summarize current conversation
  - Create checkpoint artifact
  - Suggest user to start new conversation
END IF
```

### 2. Orient Phase (Mandatory)
Before ANY code changes:
- [ ] Read relevant files
- [ ] Understand current state
- [ ] Identify dependencies
- [ ] Plan verification steps

### 3. Tool Availability Check
Verify these tools are available:
- [ ] `view_file` / `view_code_item`
- [ ] `replace_file_content` / `write_to_file`
- [ ] `run_command` (for tests/verification)
- [ ] `grep_search` / `find_by_name`
- [ ] `search_web` (for latest info/docs)
- [ ] `read_url_content` (for reading documentation)

If ANY critical tool is missing, inform user immediately.

### 4. Verification Plan
Before starting, state:
- What will be changed
- How it will be verified
- What tests will be run

## Task Execution Rules
1. **Never assume** - Always read files first
2. **Always verify** - Run tests after changes
3. **Always log** - Update task.md progress
4. **Always commit** - Use git after successful verification
