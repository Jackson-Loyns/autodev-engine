---
name: test
description: "/test — Run tests or start TDD workflow. Usage: /test run, /test tdd, /test coverage"
---

# /test Command

Run tests or initiate TDD workflow.

## Usage

```
/test run          # Run all tests
/test tdd          # Start TDD workflow with tdd-guide agent
/test coverage     # Run tests with coverage report
```

## Behavior

### /test run
```bash
bash scripts/run_tests.sh
```
Auto-detects and runs: lint → type-check → unit tests → build → Python tests.

### /test tdd
Delegate to `agents/tdd-guide.md` for the Red-Green-Refactor cycle:
1. Write failing tests for the current task
2. Implement minimal code to pass
3. Refactor while keeping green

### /test coverage
```bash
# Node.js
npx jest --coverage
# or
npx vitest --coverage

# Python
pytest --cov=. --cov-report=term-missing
```
Target: 80%+ coverage.
