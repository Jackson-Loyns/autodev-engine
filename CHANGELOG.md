# Changelog

All notable changes to autodev-engine will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-16

### Added

**Agents (5):**
- `planner` — Analyzes requirements and creates implementation plans
- `implementer` — Executes single development tasks with full cycle
- `tdd-guide` — Enforces Test-Driven Development methodology
- `code-reviewer` — Reviews code with 5-category checklist
- `task-decomposer` — Breaks requirements into granular session-sized tasks

**Commands (6):**
- `/plan` — Create implementation plan or decompose requirements
- `/dev` — Start autonomous development loop
- `/claim` — Claim specific task from queue
- `/test` — Run tests or start TDD workflow
- `/progress` — Display development progress dashboard
- `/review` — Trigger code review or check human review items

**Skills (2):**
- `decision-matrix` — AI intelligent decision guide (Agent/Skills/MCP selection)
- `autodev-core` — Core autonomous development loop workflow

**Rules (4):**
- `dev-loop` — Development loop (ORIENT → VERIFY → CLAIM → IMPLEMENT → TEST → LOG → COMMIT)
- `git-workflow` — Git workflow with conventional commits
- `testing` — Testing rules with 80%+ coverage target
- `task-management` — Task status transitions and immutability constraints

**Scripts (7):**
- `init_project.sh` — Initialize development environment
- `autodev_engine.sh` — Autonomous development engine loop
- `claim_task.sh` — Claim next available task
- `update_progress.sh` — Update task status and progress log
- `run_tests.sh` — Automated test runner
- `setup_skills.sh` — Install recommended skills
- `new_window.sh` — Dispatch tasks to new terminal windows

**Infrastructure:**
- `install.sh` — Rules installation with `--project` and `--scripts` options
- `.claude-plugin/plugin.json` — Plugin declaration
- `PUBLISHING.md` — Publishing guide
- Test scripts for plugin validation

### Changed
- Nothing (initial release)

### Deprecated
- Nothing (initial release)

### Removed
- Nothing (initial release)

### Fixed
- Nothing (initial release)

### Security
- Nothing (initial release)

[Unreleased]: https://github.com/<your-repo>/autodev-engine/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/<your-repo>/autodev-engine/releases/tag/v1.0.0
