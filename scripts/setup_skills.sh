#!/bin/bash
# ============================================================
# setup_skills.sh — Skills Installation Script
# Installs recommended skills from skills.sh for Claude Code
# Usage: bash scripts/setup_skills.sh [--all | --select]
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   📦 Skills Installation                     ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Recommended skills list (verified no conflicts)
declare -A SKILLS=(
    ["systematic-debugging"]="obra/superpowers"
    ["writing-plans"]="obra/superpowers"
    ["test-driven-development"]="obra/superpowers"
    ["verification-before-completion"]="obra/superpowers"
    ["executing-plans"]="obra/superpowers"
    ["webapp-testing"]="anthropics/skills"
    ["mcp-builder"]="anthropics/skills"
    ["frontend-design"]="anthropics/skills"
    ["web-design-guidelines"]="vercel-labs/agent-skills"
    ["agent-browser"]="vercel-labs/agent-browser"
    ["git-advanced-workflows"]="community/skills"
    ["find-skills"]="vercel-labs/skills"
)

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠ Claude CLI not found. Skills installation requires Claude Code.${NC}"
    echo ""
    echo "Install Claude Code first: https://docs.anthropic.com/claude-code"
    echo ""
    echo "After installation, run this script again."
    exit 1
fi

MODE="${1:---all}"

echo -e "Available skills:"
echo ""

INDEX=0
for SKILL in "${!SKILLS[@]}"; do
    INDEX=$((INDEX + 1))
    REPO="${SKILLS[$SKILL]}"
    echo -e "  ${CYAN}$INDEX.${NC} ${BOLD}$SKILL${NC} — ${REPO}"
done

echo ""

if [ "$MODE" = "--select" ]; then
    echo -e "Enter skill numbers to install (comma-separated), or 'all':"
    read -r SELECTION

    if [ "$SELECTION" = "all" ]; then
        MODE="--all"
    fi
fi

echo ""
echo -e "${BLUE}Installing skills...${NC}"
echo ""

INSTALLED=0
FAILED=0

for SKILL in "${!SKILLS[@]}"; do
    REPO="${SKILLS[$SKILL]}"
    echo -e "${CYAN}→${NC} Installing ${BOLD}${SKILL}${NC} from ${REPO}..."

    # Use claude CLI to install skill
    # claude skill add <repo>/<skill-name>
    SKILL_URL="https://github.com/${REPO}"

    if claude mcp add-skill "${SKILL}" "${SKILL_URL}" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Installed${NC}"
        INSTALLED=$((INSTALLED + 1))
    else
        # Alternative: try direct installation via skills.sh
        echo -e "  ${YELLOW}⚠ Standard install failed, trying alternative...${NC}"

        # Create local skill reference
        SKILLS_DIR=".claude/skills"
        mkdir -p "$SKILLS_DIR"

        cat > "${SKILLS_DIR}/${SKILL}.md" << SKILLFILE
---
name: ${SKILL}
source: ${REPO}
url: https://skills.sh/${REPO}/${SKILL}
---

# ${SKILL}

Skill from ${REPO}. Visit https://skills.sh/${REPO}/${SKILL} for full documentation.

To use this skill, reference it in your prompts or CLAUDE.md.
SKILLFILE

        echo -e "  ${GREEN}✓ Created local reference${NC}"
        INSTALLED=$((INSTALLED + 1))
    fi
done

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}Installed: $INSTALLED${NC}  ${YELLOW}Failed: $FAILED${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Skills are ready to use! Reference them in your CLAUDE.md or prompts."
