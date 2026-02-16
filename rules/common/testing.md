---
description: Testing rules — test execution order, coverage requirements, and TDD guidelines.
---

# Testing Rules

## Mandatory Test Execution

Run tests in this exact order after every implementation:

```
1. Lint          → eslint / flake8 / golangci-lint
2. Type Check    → tsc --noEmit / mypy / go vet
3. Unit Tests    → jest / pytest / go test
4. Build         → npm run build / go build
5. E2E           → playwright / cypress (if applicable)
6. Regression    → verify previously passing features still work
```

Use `bash scripts/run_tests.sh` to auto-detect and execute applicable tests.

## Coverage Requirements

- Target: **80%+ code coverage**
- All public functions must have at least one test
- All error paths must be explicitly tested
- All edge cases identified in acceptance criteria must have tests

## Test Quality Rules

1. **No test-free completion** — Never mark a task as `completed` without all tests passing
2. **Meaningful tests** — Tests must verify behavior, not just increase coverage metrics
3. **Descriptive names** — Test names describe what behavior is being verified
4. **No flaky tests** — Avoid timeouts, race conditions, and external dependencies in unit tests
5. **Co-located tests** — Place tests near the code they test, or in a dedicated `tests/` directory

## Test File Naming

| Language | Pattern |
|----------|---------|
| TypeScript/JS | `*.test.ts`, `*.spec.ts` |
| Python | `test_*.py`, `*_test.py` |
| Go | `*_test.go` |

## TDD When Applicable

For complex logic or bug fixes, follow TDD:
1. **RED** — Write failing test that defines expected behavior
2. **GREEN** — Write minimal code to pass the test
3. **REFACTOR** — Improve code quality while keeping tests green
