---
name: repo-scan
description: Scan a repository for confidential data, secrets, personal information, hardcoded paths, and attribution gaps before publishing. Use before making a repo public or pushing sensitive changes.
---

# Repository Confidential Data Scanner

## Overview

Thorough scan of every file in a repository for secrets, personal information, and anything that shouldn't be in a public repo. Reports findings by severity with exact file paths and line numbers.

## When to Use
- Before making a repository public
- Before pushing to a shared remote
- Periodic hygiene check on any repo containing skills, configs, or commands
- After merging content from external sources (attribution check)

## Scan Procedure

Run all scan categories below using Grep, Glob, and Bash tools. For each category, search the entire repository. Use parallel Agent subagents where categories are independent.

**Important:** Do NOT skip any category. Do NOT sample — scan exhaustively.

### 1. Secrets & Credentials

Search for API keys, tokens, passwords, bearer tokens, and secret strings.

**Patterns to grep (case-insensitive where applicable):**
```
sk-[a-zA-Z0-9]{20,}
pk-[a-zA-Z0-9]{20,}
key-[a-zA-Z0-9]{20,}
ANTHROPIC
OPENAI
SUPABASE_SERVICE_ROLE
SECRET_KEY
API_KEY
BEARER
password\s*[:=]
token\s*[:=]
secret\s*[:=]
-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----
ghp_[a-zA-Z0-9]{36}
gho_[a-zA-Z0-9]{36}
xoxb-
xoxp-
eyJ[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}
```

**Severity:** CRITICAL

### 2. Personal & Company References

Search for names of employers, universities, clients, or projects that reveal identity or affiliation.

**Patterns to grep:**

Check the repo owner's background and search for any employer names, university names, client names, or internal project codenames that could reveal private affiliations. Common categories:
- Current and past employer names
- University or institution names
- Client or project codenames
- Internal team names

Also scan for any references to specific people, team names, or internal project codenames that shouldn't be public.

**Severity:** HIGH

### 3. Hardcoded Paths

Search for absolute paths containing usernames, home directories, or machine-specific locations.

**Patterns to grep:**
```
/home/[a-zA-Z]
/Users/[a-zA-Z]
C:\\Users\\
~\/[a-zA-Z]
```

Exclude paths that are clearly example/placeholder paths in documentation.

**Severity:** MEDIUM

### 4. Email Addresses, Phone Numbers & Personal Identifiers

**Patterns to grep:**
```
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
\+?[0-9]{1,4}[\s.-]?[0-9]{3,4}[\s.-]?[0-9]{3,4}
```

Exclude common placeholder emails (e.g., `user@example.com`, `noreply@`).

**Severity:** HIGH

### 5. Environment-Specific Config

**Files to check:**
```
.env
.env.local
.env.production
.env.development
```

**Patterns to grep:**
```
localhost:[0-9]{4,5}
127\.0\.0\.1
0\.0\.0\.0
DATABASE_URL=
REDIS_URL=
internal service URLs or domain names
```

Also verify `.env*` files are listed in `.gitignore`.

**Severity:** MEDIUM

### 6. Git History

Use Bash to check for sensitive files that were committed and later deleted:

```bash
# Files ever deleted from the repo
git log --diff-filter=D --summary --all | grep "delete mode" | sort -u

# Search commit messages for sensitive keywords
git log --all --oneline --grep="secret\|password\|key\|token\|credential" -i

# Check if .env files were ever committed
git log --all --diff-filter=A -- "*.env" ".env.*" ".env"
```

**Severity:** CRITICAL (if secrets found in history)

### 7. Embedded Context in Skills, Hooks & Commands

Scan all markdown files, shell scripts, and command files for references to specific personal projects, internal workflows, or domain-specific context.

**Paths to scan:**
```
skills/**/*.md
hooks/**/*
commands/**/*.md
```

**Look for:**
- References to specific personal projects or repos
- Internal workflow URLs or tool names
- Domain-specific jargon that reveals private work context
- Hardcoded usernames or personal preferences that shouldn't be shared

**Severity:** HIGH

### 8. Attribution Gaps

For content derived from external sources (e.g., obra/superpowers, everything-claude-code, or other open-source projects), check for proper attribution headers.

**Method:**
- Check if the repo has a LICENSE file
- Check if files derived from external sources include attribution comments or headers
- Cross-reference README or RELEASE-NOTES for proper credit

**Severity:** LOW

## Report Format

For each finding, report:

```
### [SEVERITY] Category Name

**File:** `path/to/file`
**Line:** 42
**Content:** `the exact matching content`
**Risk:** Brief explanation of why this is a problem
```

Group findings by severity: CRITICAL > HIGH > MEDIUM > LOW.

## Summary

End the report with:

```
## Scan Summary

| Severity | Count |
|----------|-------|
| CRITICAL | X     |
| HIGH     | X     |
| MEDIUM   | X     |
| LOW      | X     |

**Categories scanned:** [list all 8]
**Files checked:** [count]
**Verdict:** CLEAN / NEEDS REMEDIATION
```

If nothing is found, confirm the repo is clean with a summary of what was checked.
