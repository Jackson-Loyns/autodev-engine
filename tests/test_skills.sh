#!/usr/bin/env bash
# test_skills.sh - Validate skills have proper YAML frontmatter
set -euo pipefail

FAILED=0

echo "==== Testing Skills ===="

for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    
    echo -n "Testing $skill_name... "
    
    # Check SKILL.md exists
    if [ ! -f "$skill_file" ]; then
        echo "✗ FAIL - SKILL.md not found"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Check YAML frontmatter exists
    if ! grep -q "^---$" "$skill_file"; then
        echo "✗ FAIL - Missing YAML frontmatter (---)"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Extract frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file")
    
    # Check required fields
    if echo "$frontmatter" | grep -q "^name:"; then
        :
    else
        echo "✗ FAIL - Missing 'name' field in frontmatter"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    if echo "$frontmatter" | grep -q "^description:"; then
        :
    else
        echo "✗ FAIL - Missing 'description' field in frontmatter"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    echo "✓ PASS"
done

# Summary
echo ""
echo "==== Test Summary ===="
if [ $FAILED -eq 0 ]; then
    echo "✓ All skills validated successfully!"
    exit 0
else
    echo "✗ $FAILED skill(s) failed validation"
    exit 1
fi
