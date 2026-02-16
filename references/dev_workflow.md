# Development Workflow Reference

> Complete development workflow from project creation to deployment.

## Workflow Phases

```
Requirements → Initialize → Decompose → Develop Loop → Test → Review → Complete
```

### Phase 1: Requirements

Place requirements in `.dev/requirement.txt`. Include:
- Feature descriptions with expected behavior
- Input/output specifications
- Edge cases and constraints
- Priority indicators

### Phase 2: Initialize

```bash
bash init.sh "<project-name>" "<requirement-description>"
```

Creates:
- Git repository with `.gitignore`
- `.dev/` directory with all tracking files
- Script permissions

### Phase 3: Decompose

On first session, the AI agent automatically:
1. Reads `.dev/requirement.txt`
2. Decomposes requirements into granular tasks
3. Generates `.dev/task.json` with all tasks
4. Creates `.dev/feature_list.json` for feature tracking

Task granularity rule: Each task must be completable in ONE AI session.

### Phase 4: Development Loop

```bash
./autodev.sh auto    # Auto-detect remaining tasks
./autodev.sh 5       # Fixed 5 iterations
./autodev.sh infinite # Until all tasks complete
```

Per-session cycle:
1. Orient → 2. Verify environment → 3. Claim task → 4. Implement → 5. Test → 6. Update progress → 7. Git commit

### Phase 5: Testing

Automated test runner detects and executes:
- Linting (`npm run lint`)
- Type checking (`npx tsc --noEmit`)
- Unit tests (`npm test` / `pytest`)
- Build verification (`npm run build`)

```bash
bash scripts/run_tests.sh
```

### Phase 6: Human Review

When AI encounters blockers:
1. Issue documented in `.dev/human_review.md`
2. AI skips to next task
3. Human resolves asynchronously

### Phase 7: Completion

The engine exits when:
- All tasks in `task.json` have status `completed`
- Or consecutive failure limit (3) is reached
- Or specified iteration count is reached

## Spec-Kit Integration

For projects using GitHub spec-kit:

```bash
# Install spec-kit
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Initialize
specify init . --ai claude

# Use in Claude Code
/speckit.constitution    # Project principles
/speckit.specify         # Feature specifications
/speckit.plan            # Technical plans
/speckit.tasks           # Task decomposition
/speckit.implement       # Implementation
```
