# Deployment Guide — How to Publish and Share autodev-engine

This guide explains how to deploy autodev-engine so other users can install and use it.

## Deployment Options

### Option 1: GitHub Public Repository (Recommended)

This is the standard way to distribute Claude Code plugins.

#### Step 1: Create GitHub Repository

```bash
# Initialize git if not already done
git init
git add -A
git commit -m "feat: v1.0.0 - Initial release"

# Create repo on GitHub, then:
git remote add origin https://github.com/<your-username>/autodev-engine.git
git branch -M main
git push -u origin main
```

#### Step 2: Create Release

```bash
# Tag the release
git tag -a v1.0.0 -m "Release v1.0.0 - Full autonomous development engine"
git push origin v1.0.0
```

Or create release via GitHub Web UI:
1. Go to your repo → Releases → Draft a new release
2. Tag: `v1.0.0`
3. Title: `v1.0.0 - Initial Release`
4. Description: Copy from `CHANGELOG.md`
5. Publish release

#### Step 3: Users Install

Once published, users install with these commands:

```bash
# In Claude Code
/plugin marketplace add <your-github-username>/autodev-engine
/plugin install autodev-engine@autodev-engine

# Then in terminal
git clone https://github.com/<your-repo>/autodev-engine.git
cd autodev-engine
./install.sh
```

---

### Option 2: Private Repository

If you want to share with specific users only:

#### Step 1: Create Private Repo

Same as Option 1, but set repository to private on GitHub.

#### Step 2: Grant Access

1. Go to repo Settings → Collaborators
2. Add users who should have access

#### Step 3: Users Install

Same as public repo, users need:
- GitHub access to your private repo
- Same installation commands

---

### Option 3: Local Distribution (ZIP file)

For offline or air-gapped environments:

#### Step 1: Create Distribution ZIP

```bash
# Create clean distribution
zip -r autodev-engine-v1.0.0.zip \
  .claude-plugin/ \
  agents/ \
  commands/ \
  skills/ \
  rules/ \
  scripts/ \
  assets/ \
  references/ \
  install.sh \
  README.md \
  PUBLISHING.md \
  CHANGELOG.md \
  -x "*.git*" "*.DS_Store"
```

#### Step 2: Share ZIP

Distribute `autodev-engine-v1.0.0.zip` via email, file sharing, etc.

#### Step 3: Users Install

```bash
# Extract
unzip autodev-engine-v1.0.0.zip -d autodev-engine
cd autodev-engine

# Manual installation
./install.sh
```

---

## User Installation Guide

### For Users: How to Install

#### Prerequisites
- Claude Code installed
- Git installed
- Bash shell (Mac/Linux)

#### Installation Steps

```bash
# Step 1: Add marketplace (if using GitHub)
/plugin marketplace add <your-github-username>/autodev-engine

# Step 2: Install plugin
/plugin install autodev-engine@autodev-engine

# Step 3: Install rules (REQUIRED)
git clone https://github.com/<your-repo>/autodev-engine.git
cd autodev-engine
./install.sh

# Step 4: (Optional) Copy scripts to project
./install.sh --project --scripts
```

#### Verification

```bash
# In Claude Code, try commands:
/plan --help
/dev
/progress

# If commands work, installation successful!
```

---

## Updating the Plugin

When you make changes and want to release updates:

### Step 1: Update Version

Edit `.claude-plugin/plugin.json`:
```json
{
  "version": "1.1.0"
}
```

### Step 2: Update CHANGELOG.md

Add new version section:
```markdown
## [1.1.0] - 2026-02-20

### Added
- New feature X
- New command Y
```

### Step 3: Commit and Tag

```bash
git add -A
git commit -m "feat: v1.1.0 - Add new features"
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin main --tags
```

### Step 4: Users Update

Users can update with:
```bash
/plugin update autodev-engine@autodev-engine
```

---

## Troubleshooting

### "Plugin not found"

**Cause:** Repository not accessible or `.claude-plugin/plugin.json` missing

**Solution:**
- Verify repository is public or user has access
- Check `.claude-plugin/plugin.json` exists
- Try: `git clone https://github.com/<your-repo>/autodev-engine.git`

### "Commands don't work"

**Cause:** Plugin installed but rules not installed

**Solution:**
```bash
cd autodev-engine
./install.sh
```

### "Permission denied: ./install.sh"

**Cause:** Script not executable

**Solution:**
```bash
chmod +x install.sh
./install.sh
```

---

## Promotion and Documentation

### README Updates

Make sure your GitHub README.md includes:
- Clear installation instructions
- Quick start guide
- Example usage
- Link to PUBLISHING.md for contributors

### Documentation Links

Add badges to README.md:
```markdown
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
```

### Community

Consider creating:
- GitHub Discussions for Q&A
- Issues template for bug reports
- Contributing guidelines
- Example projects using autodev-engine

---

## Support

If users encounter issues:

1. Check [PUBLISHING.md](PUBLISHING.md) troubleshooting section
2. Run `make test` to validate installation
3. Create GitHub Issue with:
   - Claude Code version
   - OS version
   - Error message
   - Steps to reproduce
