# Publishing autodev-engine Plugin

This guide explains how to publish autodev-engine as a Claude Code plugin via GitHub.

## Prerequisites

- GitHub repository (public or private)
- Git configured locally
- README.md with installation instructions

## Publishing Steps

### 1. Prepare Release

Update version in `.claude-plugin/plugin.json`:

```json
{
  "name": "autodev-engine",
  "version": "1.0.0",
  ...
}
```

Update `CHANGELOG.md` with release notes.

### 2. Test Locally

Before publishing, test the plugin locally:

```bash
# Test locally
claude --plugin-dir .

# Verify commands work
/plan --help
/dev
/test run

# Test install.sh
./install.sh --project --scripts
```

### 3. Create GitHub Release

```bash
# Tag the release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Or create release via GitHub UI
# Go to: Releases → Draft a new release
# Tag: v1.0.0
# Title: v1.0.0 - Initial Release
# Description: Copy from CHANGELOG.md
```

## 👥 User Installation

After publishing, users can install your engine using the `skills.sh` CLI:

```bash
npx skills add <your-github-username>/autodev-engine
```

Or specific skills:

```bash
npx skills add <your-github-username>/autodev-engine --skill autodev-core
```

## Post-Installation Steps

Users must run `./install.sh` to install rules because:
- Claude Code plugins cannot auto-distribute rules (upstream limitation)
- Rules must be manually copied to `~/.claude/rules/` or `.claude/rules/`

## Versioning

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.1.0): New features, backward compatible
- **PATCH** (0.0.1): Bug fixes

Example:
- `1.0.0` → Initial release
- `1.1.0` → Add new agent
- `1.1.1` → Fix bug in existing agent

## Testing Checklist

Before each release:

- [ ] Run `bash tests/test_plugin.sh`
- [ ] Run `bash tests/test_skills.sh`
- [ ] Test `./install.sh` in clean directory
- [ ] Test `/plugin install` locally
- [ ] Verify all commands work
- [ ] Update CHANGELOG.md
- [ ] Update version in plugin.json

## Troubleshooting

**Plugin not found:**
- Verify repository is public or user has access
- Check `.claude-plugin/plugin.json` exists
- Verify JSON format is valid

**Commands don't work:**
- Check `commands/` directory structure
- Verify YAML frontmatter in command files
- Test locally with `claude --plugin-dir .`

**Rules not applying:**
- Remind users to run `./install.sh`
- Check rules were copied to correct location
- Verify `~/.claude/rules/` or `.claude/rules/` exists
