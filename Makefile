# Makefile for autodev-engine

.PHONY: test test-plugin test-skills validate install clean help

help:  ## Show this help message
	@echo "autodev-engine - Development Tasks"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

test: test-plugin test-skills  ## Run all tests
	@echo ""
	@echo "✓ All tests passed!"

test-plugin:  ## Test plugin structure and components
	@bash tests/test_plugin.sh

test-skills:  ## Test skills YAML frontmatter
	@bash tests/test_skills.sh

validate:  ## Validate JSON and shell scripts
	@echo "Validating plugin.json..."
	@jq . .claude-plugin/plugin.json > /dev/null
	@echo "✓ plugin.json valid"
	@echo ""
	@echo "Validating shell scripts..."
	@bash -n install.sh
	@for script in scripts/*.sh; do bash -n "$$script" && echo "✓ $$script"; done

install: validate  ## Install plugin locally for testing
	@echo "Testing local plugin installation..."
	@claude --plugin-dir . --help > /dev/null 2>&1 || echo "Note: Run 'claude --plugin-dir .' to test locally"

clean:  ## Remove temporary files
	@find . -name "*.log" -delete
	@find . -name ".DS_Store" -delete
	@echo "✓ Cleaned temporary files"

.DEFAULT_GOAL := help
