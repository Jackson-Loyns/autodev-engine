# Initialize Development Workflow

**Command**: `/dev init` or `init-dev`

## Purpose
Initialize the `.dev/` directory structure for systematic task management and progress tracking.

## What It Creates

```
project-root/
└── .dev/
    ├── requirement.txt      # Original project requirements
    ├── task.json           # Task management database
    ├── progress.txt        # Session-by-session progress log
    ├── human_review.md     # Issues requiring human intervention
    ├── feature_list.json   # Feature completion tracking
    └── locks/              # File locking for multi-agent collaboration
```

## Execution Steps

### 1. Check if .dev/ already exists
```bash
if [ -d ".dev" ]; then
  echo "⚠️ .dev/ directory already exists"
  echo "Options:"
  echo "  1. Continue (merge with existing)"
  echo "  2. Backup and reinitialize"
  echo "  3. Cancel"
fi
```

### 2. Create directory structure
```bash
mkdir -p .dev/locks
```

### 3. Initialize requirement.txt
```bash
if [ ! -f ".dev/requirement.txt" ]; then
  cat > .dev/requirement.txt << 'EOF'
# Project Requirements

## Overview
[Describe the project goal]

## Features
1. Feature 1 description
2. Feature 2 description

## Constraints
- Technical constraints
- Performance requirements
- Security requirements

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
EOF
  echo "✅ Created .dev/requirement.txt (EDIT THIS FILE)"
fi
```

### 4. Initialize task.json
```bash
if [ ! -f ".dev/task.json" ]; then
  cat > .dev/task.json << 'EOF'
{
  "tasks": [],
  "metadata": {
    "created": "ISO_TIMESTAMP",
    "last_updated": "ISO_TIMESTAMP",
    "total_tasks": 0,
    "completed_tasks": 0
  }
}
EOF
  echo "✅ Created .dev/task.json"
fi
```

### 5. Initialize progress.txt
```bash
if [ ! -f ".dev/progress.txt" ]; then
  cat > .dev/progress.txt << 'EOF'
# Development Progress Log

This file tracks every development session chronologically.

========================================
EOF
  echo "✅ Created .dev/progress.txt"
fi
```

### 6. Initialize human_review.md
```bash
if [ ! -f ".dev/human_review.md" ]; then
  cat > .dev/human_review.md << 'EOF'
# Human Review Required

## Pending Issues

(No issues yet)

---

## Resolved Issues

(No resolved issues yet)
EOF
  echo "✅ Created .dev/human_review.md"
fi
```

### 7. Initialize feature_list.json
```bash
if [ ! -f ".dev/feature_list.json" ]; then
  cat > .dev/feature_list.json << 'EOF'
{
  "features": [],
  "metadata": {
    "created": "ISO_TIMESTAMP",
    "total_features": 0,
    "completed_features": 0
  }
}
EOF
  echo "✅ Created .dev/feature_list.json"
fi
```

### 8. Add .dev/ to .gitignore (optional)
```bash
if [ -f ".gitignore" ] && ! grep -q "^.dev/" .gitignore; then
  echo ""
  echo "# Development workflow (optional - can be committed)"
  echo ".dev/locks/" >> .gitignore
  echo "⚠️ Note: .dev/locks/ added to .gitignore"
  echo "   You may want to commit .dev/ files for transparency"
fi
```

## Post-Initialization

### Next Steps
1. **Edit `.dev/requirement.txt`** with your actual requirements
2. **Run decomposition**: Use Task Decomposer to generate tasks
   ```
   /plan decompose
   ```
3. **Start development**: Begin the development loop
   ```
   /dev claim
   ```

## Usage Example

```
User: "Initialize the dev workflow for this project"

Agent: [Calls init-dev command]
Agent: 
✅ .dev/ workflow initialized!

Structure:
  .dev/requirement.txt  ← EDIT THIS with requirements
  .dev/task.json        ← Tasks will be added by decomposer
  .dev/progress.txt     ← Automatic session logging
  
Next: Edit requirement.txt, then run /plan decompose
```

## Integration with Other Commands

- **After init**: Run `/plan decompose` to generate tasks
- **During dev**: Use `/claim` to get next task
- **Track progress**: Use `/progress` to view session log
- **Human review**: Issues automatically logged to `human_review.md`
