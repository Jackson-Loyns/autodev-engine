# On Error Hook

**Trigger**: When any error occurs (compilation, test failure, runtime error)

## Error Response Protocol

### 1. Immediate Actions
```
DO NOT proceed with more code changes.
INSTEAD:
1. Read the error message carefully
2. Identify root cause
3. Suggest TDD approach to fix
```

### 2. TDD Suggestion Template
```
**Error Detected**: [error type]

**Root Cause**: [analysis]

**Recommended Fix (TDD):**
1. Write a failing test that reproduces this error
2. Run test to confirm it fails
3. Fix the code
4. Run test to confirm it passes
5. Run all tests to ensure no regression

Invoke: /test [error description]
```

### 3. Context Reset (If Needed)
If errors persist after 3 attempts:
- Suggest context reset
- Create error summary artifact
- Ask user if they want to start fresh conversation

## Never Do
- ❌ Make blind fixes without understanding
- ❌ Skip verification after fix
- ❌ Ignore test failures
- ❌ Continue with more features when errors exist
