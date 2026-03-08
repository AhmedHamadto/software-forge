---
name: pre-commit-review
description: Contextual review of staged git changes for secrets, personal data,
  company references, and sensitive information that regex patterns miss.
  Use before committing when the fast pre-commit hook has passed.
disable-model-invocation: true
---

# Pre-Commit Contextual Review

## Overview

Layer 2 of the pre-commit gate. The fast hook (Layer 1) already passed —
no regex-level secrets, paths, or .env files were found. This skill reads
the staged diff with contextual understanding to catch what regex misses.

## When to Use

This skill is invoked automatically by the pre-commit hook chain when
Layer 1 passes. It can also be invoked manually with `/pre-commit-review`
before a commit for an on-demand check.

## Procedure

### Step 1: Get the Staged Diff

Run:
```bash
git diff --cached --unified=5
```

If the diff is empty, report "Nothing staged" and exit.

### Step 2: Contextual Scan

Read through the entire diff looking for these categories.
For each finding, note the file, line number, and why it's a concern.

**2a. Secrets & Credentials (contextual)**
Look for things the regex hook wouldn't catch:
- Non-standard secret patterns (e.g., `mysecret = "a8f3b2..."` with high-entropy strings)
- Secrets passed as function arguments (e.g., `authenticate("hardcoded-password")`)
- Base64-encoded strings that decode to credentials
- Comments containing real secrets (e.g., `// old key was sk-ant-...`)
- Database connection strings with embedded passwords

**2b. Personal & Company References (contextual)**
Look beyond the exact company names:
- References to specific internal projects, codenames, or team names
- Names of real people (colleagues, managers, clients)
- Internal URLs, Slack channels, Jira ticket numbers
- Domain-specific jargon that reveals private work context
- Comments like "from the MinRes codebase" or "Ahmed's laptop"

**2c. Sensitive Business Logic**
- Pricing, compensation, or financial figures
- Client names or contract details
- Internal process descriptions that shouldn't be public
- Competitive analysis or strategy notes

**2d. False Positive Check**
For anything Layer 1 might have flagged in a previous run, or borderline cases:
- Is a matched "secret" actually a placeholder/example? (e.g., `sk-test-example-key`)
- Is a path in documentation clearly marked as an example?
- Is a company name in a LICENSE or attribution that's appropriate?

### Step 3: Verdict

**BLOCK** if any findings in 2a, 2b, or 2c are real (not false positives).
Report findings with file, line, content, and recommended fix.

**PASS** if nothing found or all findings are confirmed false positives.
Report: "Layer 2 contextual review passed. No sensitive content in staged changes."

### Report Format

```
## Pre-Commit Review (Layer 2)

**Files reviewed:** [count] files, [count] lines changed
**Verdict:** PASS / BLOCK

### Findings (if any)

| # | File | Line | Category | Finding | Recommended Fix |
|---|------|------|----------|---------|-----------------|

### Notes
- [Any borderline cases or things to watch]
```
