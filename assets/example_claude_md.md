# Example CLAUDE.md Template

> Copy this template to the root of any project to configure AI agent behavior.
> Customize the sections below for your specific project needs.

```markdown
# CLAUDE.md

## Project Overview
[Project name] — [Brief description of what this project does].

Tech stack: [Language/Framework] + [Database] + [Infrastructure]

## Development Rules

### Session Protocol
1. Read `.dev/progress.txt` and `.dev/task.json` before ANY work
2. Claim exactly ONE task per session via `bash scripts/claim_task.sh`
3. Implement, test, update progress, commit — in that order
4. Never modify task descriptions in `.dev/task.json`

### Code Standards
- Follow existing patterns in the codebase
- Functions under 50 lines; extract if longer
- All public APIs must have tests
- No hardcoded secrets — use environment variables

### Testing
- Run `bash scripts/run_tests.sh` after every change
- Tests must pass before marking task complete
- Target: 80%+ code coverage

### Git Workflow
- Commit format: `feat(TASK-XXX): Description`
- Never commit failing tests
- Squash WIP commits before merging

## Architecture Notes
[Describe key architectural decisions, folder structure conventions,
and important patterns specific to this project.]

## File Structure
```
src/
├── components/    # UI components
├── services/      # Business logic
├── models/        # Data models
├── utils/         # Shared utilities
└── tests/         # Test files
```

## Available Tools
- `bash scripts/run_tests.sh` — Run all tests
- `bash scripts/claim_task.sh` — Claim next task
- `bash scripts/update_progress.sh TASK-XXX status "notes"` — Update progress

## MCP Services
[List configured MCP servers and their purposes]

## Important Constraints
- [Project-specific constraints, e.g., "No new npm dependencies without approval"]
- [Performance requirements, e.g., "API response time < 200ms"]
- [Security requirements, e.g., "All user input must be sanitized"]
```
