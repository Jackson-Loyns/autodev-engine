# Tool Calling Rule

**Priority**: CRITICAL

## Mandatory Tool Usage

### NEVER Do These Without Tools
- ❌ "I would read the file..." → ✅ Actually call `view_file`
- ❌ "You could modify..." → ✅ Actually call `replace_file_content`
- ❌ "Run the tests..." → ✅ Actually call `run_command`
- ❌ "Search for..." → ✅ Actually call `grep_search`

## Tool Call Template

### Before ANY Code Change
```
1. view_file(path) - ALWAYS read first
2. Analyze current state
3. Plan the change
4. replace_file_content(path, ...) - Make the change
5. run_command("test") - Verify the change
```

### For New Features
```
1. grep_search / find_by_name - Find similar patterns
2. view_file - Read existing code
3. write_to_file - Create new file
4. run_command - Test immediately
5. view_file - Verify what was written
```

### For Debugging
```
1. view_file - Read the problematic file
2. run_command - Reproduce the error
3. grep_search - Find related code
4. replace_file_content - Fix
5. run_command - Verify fix
6. run_command - Run all tests
```

## Parallel vs Sequential

### Use Parallel (Multiple tools at once)
```python
# Good: Independent reads
view_file(file1) + view_file(file2) + view_file(file3)
```

### Use Sequential (Wait for results)
```python
# Good: Dependent operations
1. view_file(path) - need to see content first
2. [analyze result]
3. replace_file_content - change based on what you saw
```

## Verification is Mandatory

### After Every Code Change
```
MUST call run_command to verify:
- Run tests
- Build/compile
- Lint check
- Any relevant validation

IF verification fails THEN
  DO NOT proceed to next task
  FIX the issue first
END IF
```

## Common Patterns

### Pattern 1: Read-Modify-Verify
```
view_file(path) →
replace_file_content(path, ...) →
run_command("npm test")
```

### Pattern 2: Search-Read-Create
```
grep_search("similar_function") →
view_file(found_file) →
write_to_file(new_file)
```

### Pattern 3: Debug-Fix-Test
```
run_command("npm test") →
view_file(failing_test) →
replace_file_content(fix) →
run_command("npm test")
```

## Never Assume
- ❌ "The file probably contains..."
- ✅ Call `view_file` and know for sure

- ❌ "If you run X, it should..."  
- ✅ Call `run_command` and see the actual result

## Auto-Retry Logic
IF tool fails THEN
  1. Check error message
  2. Adjust parameters
  3. Retry with corrected params
  4. If fails again (>2 times), ask user
END IF
