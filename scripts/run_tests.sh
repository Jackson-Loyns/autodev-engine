#!/bin/bash
# ============================================================
# run_tests.sh — Test Execution Script
# Runs all applicable tests in order: lint → build → e2e
# Usage: bash scripts/run_tests.sh
# Returns: exit code 0 if all tests pass, 1 if any fail
# ============================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

run_test() {
    local name="$1"
    local cmd="$2"

    echo -e "\n${CYAN}[TEST]${NC} $name"
    echo -e "${CYAN}  →${NC} $cmd"

    if eval "$cmd" 2>&1; then
        echo -e "${GREEN}  ✓ PASSED${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
        return 0
    else
        echo -e "${RED}  ✗ FAILED${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

skip_test() {
    local name="$1"
    local reason="$2"
    echo -e "\n${YELLOW}[SKIP]${NC} $name — $reason"
    SKIP_COUNT=$((SKIP_COUNT + 1))
}

echo -e "${BOLD}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   🧪 Test Runner                             ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════╝${NC}"

OVERALL_EXIT=0

# ---- 1. Lint Check ----
if [ -f "package.json" ] && jq -e '.scripts.lint' package.json > /dev/null 2>&1; then
    run_test "Lint Check" "npm run lint" || OVERALL_EXIT=1
else
    skip_test "Lint Check" "No lint script in package.json"
fi

# ---- 2. Type Check (TypeScript) ----
if [ -f "tsconfig.json" ] && [ -f "package.json" ]; then
    if jq -e '.scripts["type-check"]' package.json > /dev/null 2>&1; then
        run_test "Type Check" "npm run type-check" || OVERALL_EXIT=1
    elif command -v npx > /dev/null 2>&1 && [ -f "node_modules/.bin/tsc" ]; then
        run_test "Type Check" "npx tsc --noEmit" || OVERALL_EXIT=1
    else
        skip_test "Type Check" "TypeScript not configured"
    fi
fi

# ---- 3. Unit Tests ----
if [ -f "package.json" ] && jq -e '.scripts.test' package.json > /dev/null 2>&1; then
    run_test "Unit Tests" "npm test -- --passWithNoTests 2>/dev/null || npm test" || OVERALL_EXIT=1
else
    skip_test "Unit Tests" "No test script in package.json"
fi

# ---- 4. Build ----
if [ -f "package.json" ] && jq -e '.scripts.build' package.json > /dev/null 2>&1; then
    run_test "Build" "npm run build" || OVERALL_EXIT=1
else
    skip_test "Build" "No build script in package.json"
fi

# ---- 5. Python Tests (if applicable) ----
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    if command -v pytest > /dev/null 2>&1; then
        run_test "Python Tests" "pytest -x -q" || OVERALL_EXIT=1
    elif command -v python3 > /dev/null 2>&1 && [ -d "tests" ]; then
        run_test "Python Tests" "python3 -m pytest -x -q" || OVERALL_EXIT=1
    else
        skip_test "Python Tests" "pytest not available"
    fi
fi

# ---- Summary ----
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}Passed: $PASS_COUNT${NC}  ${RED}Failed: $FAIL_COUNT${NC}  ${YELLOW}Skipped: $SKIP_COUNT${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $OVERALL_EXIT -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✓ All tests passed!${NC}"
else
    echo -e "\n${RED}${BOLD}✗ Some tests failed. Please fix before marking task as completed.${NC}"
fi

exit $OVERALL_EXIT
