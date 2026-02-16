#!/usr/bin/env bash
# autodev-engine installer
# Installs rules to ~/.claude/rules/ or .claude/rules/ (project-level)
# Optionally copies scripts to current project
set -euo pipefail

# ── Colors ──
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# ── Resolve script directory (handles symlinks when called from anywhere) ──
SCRIPT_PATH="$0"
while [ -L "$SCRIPT_PATH" ]; do
    link_dir="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
    SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
    [[ "$SCRIPT_PATH" != /* ]] && SCRIPT_PATH="$link_dir/$SCRIPT_PATH"
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

# ── Parse arguments ──
INSTALL_LOCATION="global"  # global or project
INSTALL_SCRIPTS=false

for arg in "$@"; do
    case $arg in
        --project)
            INSTALL_LOCATION="project"
            shift
            ;;
        --scripts)
            INSTALL_SCRIPTS=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--project] [--scripts]"
            echo ""
            echo "Options:"
            echo "  --project    Install rules to .claude/rules/ in current directory (project-level)"
            echo "               Default: install to ~/.claude/rules/ (global)"
            echo "  --scripts    Copy automation scripts to current directory"
            echo ""
            echo "Examples:"
            echo "  $0                    # Install rules globally"
            echo "  $0 --project          # Install rules to current project"
            echo "  $0 --project --scripts # Install rules + scripts to project"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown argument: $arg${NC}"
            echo "Run '$0 --help' for usage"
            exit 1
            ;;
    esac
done

echo -e "\n${BOLD}${CYAN}Autodev Engine Installer${NC}\n"

# ── Step 1: Install Rules ──
if [ "$INSTALL_LOCATION" = "global" ]; then
    RULES_DEST="$HOME/.claude/rules"
    echo -e "${BOLD}Installing rules globally${NC} → ${CYAN}$RULES_DEST${NC}"
else
    RULES_DEST="$(pwd)/.claude/rules"
    echo -e "${BOLD}Installing rules to project${NC} → ${CYAN}$RULES_DEST${NC}"
fi

RULES_SOURCE="$SCRIPT_DIR/rules/common"
if [ ! -d "$RULES_SOURCE" ]; then
    echo -e "${RED}✗ Rules source not found at $RULES_SOURCE${NC}"
    exit 1
fi

mkdir -p "$RULES_DEST"
cp -r "$RULES_SOURCE/." "$RULES_DEST/"
echo -e "  ${GREEN}✓${NC} Installed 4 rules: dev-loop, git-workflow, testing, task-management"

# ── Step 2: Copy Scripts (optional) ──
if [ "$INSTALL_SCRIPTS" = true ]; then
    echo -e "\n${BOLD}Copying automation scripts${NC} → ${CYAN}$(pwd)/scripts/${NC}"
    
    SCRIPTS_SOURCE="$SCRIPT_DIR/scripts"
    SCRIPTS_DEST="$(pwd)/scripts"
    
    if [ ! -d "$SCRIPTS_SOURCE" ]; then
        echo -e "${YELLOW}⚠ Scripts source not found at $SCRIPTS_SOURCE${NC}"
    else
        mkdir -p "$SCRIPTS_DEST"
        cp -r "$SCRIPTS_SOURCE/." "$SCRIPTS_DEST/"
        chmod +x "$SCRIPTS_DEST"/*.sh 2>/dev/null || true
        echo -e "  ${GREEN}✓${NC} Copied 7 scripts"
    fi
fi

# ── Step 3: Create .dev/ workspace (if --project) ──
if [ "$INSTALL_LOCATION" = "project" ]; then
    echo -e "\n${BOLD}Setting up development workspace${NC}"
    
    DEV_DIR="$(pwd)/.dev"
    mkdir -p "$DEV_DIR"
    mkdir -p "$(pwd)/logs"
    
    PROJECT_NAME=$(basename "$(pwd)")
    
    # task.json
    if [ ! -f "$DEV_DIR/task.json" ]; then
        cat > "$DEV_DIR/task.json" << EOF
{
  "project": "$PROJECT_NAME",
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "tasks": []
}
EOF
        echo -e "  ${GREEN}✓${NC} .dev/task.json"
    fi
    
    # progress.txt
    if [ ! -f "$DEV_DIR/progress.txt" ]; then
        cat > "$DEV_DIR/progress.txt" << EOF
=== Project: $PROJECT_NAME ===
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)

EOF
        echo -e "  ${GREEN}✓${NC} .dev/progress.txt"
    fi
    
    # human_review.md
    if [ ! -f "$DEV_DIR/human_review.md" ]; then
        cat > "$DEV_DIR/human_review.md" << EOF
# Human Review Required

No items requiring human review.
EOF
        echo -e "  ${GREEN}✓${NC} .dev/human_review.md"
    fi
    
    # requirement.txt
    if [ ! -f "$DEV_DIR/requirement.txt" ]; then
        cat > "$DEV_DIR/requirement.txt" << EOF
# Project Requirements

Describe your project requirements here.
EOF
        echo -e "  ${GREEN}✓${NC} .dev/requirement.txt"
    fi
    
    # feature_list.json
    if [ ! -f "$DEV_DIR/feature_list.json" ]; then
        echo '{"features": []}' > "$DEV_DIR/feature_list.json"
        echo -e "  ${GREEN}✓${NC} .dev/feature_list.json"
    fi
fi

# ── Done ──
echo -e "\n${BOLD}${GREEN}Installation complete!${NC}\n"

if [ "$INSTALL_LOCATION" = "global" ]; then
    echo "Rules installed globally. They will apply to all Claude Code projects."
else
    echo "Rules and workspace installed to current project."
fi

if [ "$INSTALL_SCRIPTS" = true ]; then
    echo ""
    echo -e "${BOLD}Next steps:${NC}"
    echo -e "  1. Write requirements: ${CYAN}echo \"your requirements\" > .dev/requirement.txt${NC}"
    echo -e "  2. Initialize project:  ${CYAN}bash scripts/init_project.sh \"project-name\"${NC}"
    echo -e "  3. Start development:   ${CYAN}bash scripts/autodev_engine.sh auto${NC}"
fi

echo ""
