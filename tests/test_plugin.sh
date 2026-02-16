#!/usr/bin/env bash
# test_plugin.sh - Validate plugin structure and components
set -euo pipefail

FAILED=0

echo "==== Testing Plugin Structure ===="

# Test 1: Validate plugin.json
echo -n "Test 1: Validating plugin.json... "
if jq . .claude-plugin/plugin.json > /dev/null 2>&1; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    FAILED=$((FAILED + 1))
fi

# Test 2: Check required fields in plugin.json
echo -n "Test 2: Checking required fields... "
if jq -e '.name' .claude-plugin/plugin.json > /dev/null && \
   jq -e '.version' .claude-plugin/plugin.json > /dev/null && \
   jq -e '.agents' .claude-plugin/plugin.json > /dev/null; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    FAILED=$((FAILED + 1))
fi

# Test 3: Check all agents exist
echo -n "Test 3: Checking agents exist... "
AGENT_COUNT=0
for agent in agents/*.md; do
    if [ -f "$agent" ]; then
        AGENT_COUNT=$((AGENT_COUNT + 1))
    else
        echo "✗ FAIL - Missing agent: $agent"
        FAILED=$((FAILED + 1))
    fi
done
if [ $AGENT_COUNT -eq 5 ]; then
    echo "✓ PASS ($AGENT_COUNT agents)"
else
    echo "✗ FAIL - Expected 5 agents, found $AGENT_COUNT"
    FAILED=$((FAILED + 1))
fi

# Test 4: Check all commands exist
echo -n "Test 4: Checking commands exist... "
COMMAND_COUNT=0
for cmd in commands/*.md; do
    if [ -f "$cmd" ]; then
        COMMAND_COUNT=$((COMMAND_COUNT + 1))
    fi
done
if [ $COMMAND_COUNT -eq 6 ]; then
    echo "✓ PASS ($COMMAND_COUNT commands)"
else
    echo "✗ FAIL - Expected 6 commands, found $COMMAND_COUNT"
    FAILED=$((FAILED + 1))
fi

# Test 5: Check skills structure
echo -n "Test 5: Checking skills structure... "
if [ -f skills/decision-matrix/SKILL.md ] && \
   [ -f skills/autodev-core/SKILL.md ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    FAILED=$((FAILED + 1))
fi

# Test 6: Check rules exist
echo -n "Test 6: Checking rules exist... "
RULE_COUNT=$(find rules/common -name "*.md" | wc -l)
if [ "$RULE_COUNT" -eq 4 ]; then
    echo "✓ PASS ($RULE_COUNT rules)"
else
    echo "✗ FAIL - Expected 4 rules, found $RULE_COUNT"
    FAILED=$((FAILED + 1))
fi

# Test 7: Shell script syntax
echo -n "Test 7: Validating shell scripts... "
SCRIPT_FAILED=0
if ! bash -n install.sh 2>/dev/null; then
    echo "✗ FAIL - install.sh has syntax errors"
    SCRIPT_FAILED=1
fi
for script in scripts/*.sh; do
    if ! bash -n "$script" 2>/dev/null; then
        echo "✗ FAIL - $script has syntax errors"
        SCRIPT_FAILED=1
    fi
done
if [ $SCRIPT_FAILED -eq 0 ]; then
    echo "✓ PASS"
else
    FAILED=$((FAILED + 1))
fi

# Test 8: Check required documentation
echo -n "Test 8: Checking documentation... "
if [ -f README.md ] && [ -f PUBLISHING.md ] && [ -f CHANGELOG.md ]; then
    echo "✓ PASS"
else
    echo "✗ FAIL"
    FAILED=$((FAILED + 1))
fi

# Summary
echo ""
echo "==== Test Summary ===="
if [ $FAILED -eq 0 ]; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ $FAILED test(s) failed"
    exit 1
fi
