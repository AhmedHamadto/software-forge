---
name: release
description: Cut a professional release — bump version, write release notes, commit, tag, and push. Use when shipping a new version of any project.
---

# Release

## Overview

Guides a professional release process: determines the version bump, writes structured release notes, updates the changelog, commits, tags, and pushes. Ensures consistency and quality across releases.

**Announce at start:** "I'm using the release skill to cut a new version."

## When to Use

- Shipping a new version of a project
- User says "release", "cut a release", "ship it", "bump version"
- After implementation is complete and all tests pass

**When NOT to use:**
- Work-in-progress commits (just commit normally)
- Hotfixes that don't warrant a release (though they often do)

---

## Authorship Rule

**All commits and tags are authored by the user, not by Claude.**

- Do NOT add `Co-Authored-By: Claude` or any AI attribution to commits
- Do NOT add `Co-Authored-By` trailers of any kind
- The commit author is whoever is configured in `git config user.name` and `git config user.email`
- This applies to the release commit, the tag, and any preparatory commits

---

## Release Flow

### Step 1: Pre-Flight Check

Before anything else:

1. **Run tests.** If they fail, stop. Do not release broken code.
2. **Check git status.** All changes should be staged or committed. Warn if there are uncommitted changes unrelated to the release.
3. **Check current branch.** Releases should typically come from `main` or a release branch. If on a feature branch, confirm with the user.
4. **Read the current version.** Check `package.json`, `Cargo.toml`, `pyproject.toml`, `RELEASE-NOTES.md`, git tags, or wherever the project tracks its version.

### Step 2: Determine Version Bump

Read the commit history since the last release tag to understand what changed:

```bash
git log <last-tag>..HEAD --oneline
```

Apply [Semantic Versioning](https://semver.org/):

| Change Type | Bump | Examples |
|------------|------|---------|
| Breaking API/behavior changes | **Major** (X.0.0) | Removed feature, renamed public API, changed data format |
| New features, new phases, new skills | **Minor** (x.Y.0) | Added skill, added phase, new capability |
| Bug fixes, typos, doc updates, refactors | **Patch** (x.y.Z) | Fixed typo, corrected phase number, updated docs |

**Present the recommendation to the user:**

> Based on the changes since vX.Y.Z, I recommend a **minor** bump to vX.Y+1.0:
> - [list key changes]
>
> Does this look right, or would you prefer a different version?

Wait for confirmation before proceeding.

### Step 3: Write Release Notes

Read the existing `RELEASE-NOTES.md` to match the project's established style and structure. The new entry must be consistent with previous entries in tone, heading levels, and formatting.

**Release notes structure:**

```markdown
## vX.Y.Z (YYYY-MM-DD)

### [Section Header — describes the theme]

[Narrative paragraph explaining the headline change. What it is, why it matters, how it works at a high level.]

### [Additional sections as needed]

[Group related changes under descriptive headers. Not every change needs its own section — group small changes together.]

### Full Changelog

- type: description of change
- type: description of change
```

**Rules:**
- Lead with the most important change, not a chronological dump
- Use narrative paragraphs for significant features, not just bullet points
- Group related changes under meaningful section headers
- The Full Changelog at the bottom is a concise, complete list using conventional commit prefixes (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`)
- Update counts, tables, or summary stats if the project tracks them (e.g., skill count, phase count)
- Do NOT mention Claude, AI, or automation in the release notes

### Step 4: Update Version References

Update the version string in every manifest file that exists:

| File | Fields to update |
|------|-----------------|
| .claude-plugin/plugin.json | .version |
| .claude-plugin/marketplace.json | .metadata.version AND .plugins[].version |
| .cursor-plugin/plugin.json | .version (if exists) |
| .codex/plugin.json | .version (if exists) |
| package.json | .version |
| Cargo.toml / pyproject.toml | version field |

Also check for README badges or version references.

### Step 5: Commit

Stage all release-related changes and create a single release commit:

```bash
git add -A
git commit -m "release: vX.Y.Z — [one-line summary of headline change]"
```

**No `Co-Authored-By` trailer. No AI attribution.**

### Step 6: Tag

Create an annotated tag:

```bash
git tag -a vX.Y.Z -m "vX.Y.Z"
```

### Step 7: Push

Ask the user before pushing:

> Ready to push the release commit and tag to origin. Proceed?

If confirmed:

```bash
git push && git push --tags
```

---

## Conventional Commit Prefixes

Use these in the Full Changelog section:

| Prefix | Meaning |
|--------|---------|
| `feat:` | New feature or capability |
| `fix:` | Bug fix |
| `refactor:` | Code restructuring without behavior change |
| `docs:` | Documentation only |
| `chore:` | Build, CI, dependencies, tooling |
| `perf:` | Performance improvement |
| `test:` | Test additions or fixes |
| `style:` | Formatting, whitespace (no logic change) |

---

## Anti-Patterns

| Mistake | Fix |
|---------|-----|
| Releasing without running tests | Always run tests in Step 1 |
| "Bump version" as the commit message | Use `release: vX.Y.Z — [summary]` |
| Adding AI co-authorship | The user is the author. Period. |
| Dumping raw git log as release notes | Write narrative release notes that a human would want to read |
| Skipping the tag | Tags are how users and tools identify releases |
| Force-pushing a release | Never. If something is wrong, cut a new patch release. |
| Releasing from a feature branch | Releases come from main unless the user explicitly confirms otherwise |
