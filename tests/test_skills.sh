#!/usr/bin/env bash
# test_sk#!/bin/bash

# Skills Validation Script (Skills.sh Format)
# Checks for Markdown Table format as required by skills.sh

# Skills Validation Script (Skills.sh Format)
# Checks for Markdown Table format as required by skills.sh

SKILLS_DIR="skills/autodev-engine"
EXIT_CODE=0

echo "==== Testing Skills (Skills.sh Format) ===="

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Error: skills directory not found at $SKILLS_DIR!"
    exit 1
fi

# Find all SKILL.md files
find "$SKILLS_DIR" -name "SKILL.md" | while read -r skill_file; do
    skill_name=$(basename "$(dirname "$skill_file")")
    echo -n "Testing $skill_name... "
    
    # Check for Table Header
    if ! grep -q "| name | description |" "$skill_file"; then
        echo "✗ FAIL - Missing Markdown Table Header (| name | description |)"
        EXIT_CODE=1
        continue
    fi

    # Check for separator
    if ! grep -q "| :--- | :---------- |" "$skill_file"; then
        echo "✗ FAIL - Missing Table Separator (| :--- | :---------- |)"
        EXIT_CODE=1
        continue
    fi

    # Check for skill name in table
    if ! grep -q "| $skill_name" "$skill_file"; then
        echo "✗ FAIL - Skill name '$skill_name' not found in table"
        EXIT_CODE=1
        continue
    fi

    echo "✓ PASS"
done

echo ""
echo "==== Test Summary ===="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ All skills passed validation!"
else
    echo "✗ Some skills failed validation"
fi

exit $EXIT_CODE
