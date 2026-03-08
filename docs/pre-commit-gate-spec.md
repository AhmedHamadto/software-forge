# Pre-Commit Gate: Design & Implementation Spec

*Created: 2026-03-08*

A two-layer pre-commit system that prevents secrets, personal references, hardcoded paths, and .env files from ever reaching git history. Layer 1 is a fast deterministic shell script (zero tokens, milliseconds). Layer 2 is a smart Claude Code skill that reads the staged diff with context awareness (uses tokens, catches what regex can't).

---

## Architecture

```
git commit
    │
    ▼
┌──────────────────────────┐
│  Layer 1: Fast Hook      │  Shell script, regex patterns
│  (PreToolUse on commit)  │  ~200ms, zero tokens
│                          │
│  Scans: staged files     │
│  Catches: pattern-match  │
│  Result: BLOCK or PASS   │
└──────────┬───────────────┘
           │ PASS
           ▼
┌──────────────────────────┐
│  Layer 2: Smart Skill    │  Claude reads staged diff
│  (pre-commit-review)     │  ~15-30 seconds, uses tokens
│                          │
│  Scans: staged diff +    │
│    surrounding context   │
│  Catches: contextual     │
│    leaks regex misses    │
│  Result: BLOCK or PASS   │
└──────────┬───────────────┘
           │ PASS
           ▼
       Commit proceeds
```

**Why two layers:**
- Layer 1 catches `sk-ant-oat01-abc123...` in 200ms. No need to burn tokens on that.
- Layer 2 catches things like a comment saying `// Ahmed's MinRes laptop` that regex wouldn't flag, or recognises that `API_KEY=os.environ["API_KEY"]` is safe while `API_KEY=sk-live-xxx` is not.

---

## Layer 1: Fast Hook

### What It Is

A Claude Code hook that fires on `PreToolUse` when the tool is `Bash` and the command matches `git commit`. It runs a shell script that greps staged files for dangerous patterns. If any match, it exits with code 2 (block the tool use) and surfaces the findings to Claude.

### Hook Configuration

Add to `hooks/hooks.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "'${CLAUDE_PLUGIN_ROOT}/hooks/pre-commit-scan.sh'",
            "async": false
          }
        ]
      }
    ]
  }
}
```

Note: The hook fires on all Bash tool uses. The script itself checks whether the command is a git commit and exits 0 (pass-through) immediately if it's not.

### Hook Script: `hooks/pre-commit-scan.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Only run on git commit commands
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
if ! echo "$TOOL_INPUT" | grep -qE 'git\s+commit'; then
  exit 0  # Not a commit — pass through silently
fi

# Get staged files (excludes deleted files)
STAGED_FILES=$(git diff --cached --name-only --diff-filter=d 2>/dev/null)
if [[ -z "$STAGED_FILES" ]]; then
  exit 0  # Nothing staged
fi

FINDINGS=""
BLOCK=false

# --- Check 1: Secrets & API Keys ---
SECRETS_PATTERN='sk-[a-zA-Z0-9]{20,}|pk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|gho_[a-zA-Z0-9]{36}|xoxb-|xoxp-|-----BEGIN\s*(RSA\s*|EC\s*|DSA\s*|OPENSSH\s*)?PRIVATE\s*KEY-----|ANTHROPIC_API_KEY\s*=\s*["\x27]?sk-|OPENAI_API_KEY\s*=\s*["\x27]?sk-|SUPABASE_SERVICE_ROLE_KEY\s*=\s*["\x27]?eyJ|eyJ[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}'

while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  MATCHES=$(grep -nEo "$SECRETS_PATTERN" "$file" 2>/dev/null | head -5) || true
  if [[ -n "$MATCHES" ]]; then
    FINDINGS+="[CRITICAL] Secrets found in $file:\n$MATCHES\n\n"
    BLOCK=true
  fi
done <<< "$STAGED_FILES"

# --- Check 2: Personal/Company References ---
PERSONAL_PATTERN='\b(MinRes|Mineral\s*Resources|Aisyst|Barakah\s*AI|Curtin\s*University)\b'

while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  # Skip this script itself and any config that legitimately contains these
  [[ "$file" == *"pre-commit"* ]] && continue
  [[ "$file" == *"hooks.json"* ]] && continue
  MATCHES=$(grep -nEi "$PERSONAL_PATTERN" "$file" 2>/dev/null | head -5) || true
  if [[ -n "$MATCHES" ]]; then
    FINDINGS+="[BLOCK] Personal/company reference in $file:\n$MATCHES\n\n"
    BLOCK=true
  fi
done <<< "$STAGED_FILES"

# --- Check 3: Hardcoded User Paths ---
PATH_PATTERN='/Users/[a-zA-Z][a-zA-Z0-9._-]+/|/home/[a-zA-Z][a-zA-Z0-9._-]+/|C:\\\\Users\\\\[a-zA-Z]'

while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  MATCHES=$(grep -nE "$PATH_PATTERN" "$file" 2>/dev/null | head -5) || true
  if [[ -n "$MATCHES" ]]; then
    FINDINGS+="[BLOCK] Hardcoded user path in $file:\n$MATCHES\n\n"
    BLOCK=true
  fi
done <<< "$STAGED_FILES"

# --- Check 4: Staged .env Files ---
while IFS= read -r file; do
  if [[ "$file" =~ ^\.env(\..*)?$ ]] || [[ "$file" =~ /\.env(\..*)?$ ]]; then
    FINDINGS+="[CRITICAL] .env file staged for commit: $file\n\n"
    BLOCK=true
  fi
done <<< "$STAGED_FILES"

# --- Output ---
if [[ "$BLOCK" == true ]]; then
  # Exit code 2 = block the tool use and send feedback
  ESCAPED_FINDINGS=$(echo -e "$FINDINGS" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')
  echo "{\"hookSpecificOutput\":{\"additionalContext\":\"PRE-COMMIT BLOCKED: $ESCAPED_FINDINGS Remove or fix these issues before committing.\"}}"
  exit 2
fi

# All clear — pass through
exit 0
```

### What Layer 1 Catches

| Category | Pattern Examples | Severity |
|----------|----------------|----------|
| API keys & tokens | `sk-ant-...`, `ghp_...`, `xoxb-...`, JWTs | CRITICAL |
| Private keys | `-----BEGIN RSA PRIVATE KEY-----` | CRITICAL |
| Hardcoded secrets | `ANTHROPIC_API_KEY=sk-...` | CRITICAL |
| Company names | MinRes, Mineral Resources, Aisyst, Barakah AI, Curtin | BLOCK |
| User paths | `/Users/ahmed/`, `/home/ahmed/` | BLOCK |
| .env files | Any `.env`, `.env.local`, `.env.production` | CRITICAL |

### What Layer 1 Cannot Catch

- Secrets in variable assignments where the pattern doesn't match (e.g., `MY_SECRET = "not-a-standard-prefix"`)
- Personal references in creative spellings or abbreviations
- Context-dependent leaks (e.g., internal project names, team names, IP)
- Whether a matched pattern is real or a false positive (e.g., `sk-example-not-real-key` in docs)

That's what Layer 2 is for.

---

## Layer 2: Smart Skill

### What It Is

A Claude Code skill that reads the staged diff, understands the context, and flags things the regex hook can't catch. It runs after Layer 1 passes — so it never wastes tokens on obvious pattern matches.

### Skill File: `skills/pre-commit-review/SKILL.md`

```markdown
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
```

### Invocation

The skill is invoked by the orchestrator. In practice, after Layer 1 passes,
Claude should invoke this skill before proceeding with the commit. This can
be triggered by:

1. Adding a note in CLAUDE.md (see below)
2. Or integrating into the commit workflow via the `finishing-a-development-branch` skill

---

## Integration with Software Forge

### Option 1: CLAUDE.md Addition

Add to your global CLAUDE.md under the "Primary Workflow" or "Code Quality" section:

```markdown
## Pre-Commit Gate

Before every `git commit`, two checks run:
1. **Fast hook** (automatic) — regex scan of staged files for secrets,
   personal references, hardcoded paths, and .env files. Blocks automatically.
2. **Smart review** (invoke `/pre-commit-review`) — contextual review of
   the staged diff for things regex misses. Run this before committing
   unless the commit is trivial (typo fix, formatting only).
```

### Option 2: Integration with `finishing-a-development-branch` Skill

Add to `skills/finishing-a-development-branch/SKILL.md`, in the pre-merge
checklist section:

```markdown
### Pre-Commit Gate (MANDATORY)
Before creating the final commit:
1. Stage all changes (`git add`)
2. The fast pre-commit hook runs automatically on `git commit`
3. If it passes, invoke `/pre-commit-review` for contextual scan
4. Only proceed with the commit after both layers pass
```

### Relationship to Existing Pre-Launch Skills

The pre-commit gate and the pre-launch audit are complementary, not overlapping:

```
Development ──► Pre-Commit Gate (every commit)
                 │ Scope: staged files only
                 │ Speed: seconds
                 │ Depth: secrets, PII, paths, env
                 │
                 ▼
Ready to publish ──► /pre-launch-audit (once, before publishing)
                      │ Scope: entire repo
                      │ Speed: 5-15 minutes
                      │ Depth: legal, IP, first-run UX,
                      │   README quality, launch polish,
                      │   PLUS full repo-scan
```

The pre-commit gate is the daily seatbelt. The pre-launch audit is the
full vehicle inspection before selling the car.

---

## File Inventory

After implementation, the following files should exist:

```
hooks/
  hooks.json              # Updated — add PreToolUse matcher for Bash
  pre-commit-scan.sh      # NEW — Layer 1 fast hook script
  run-hook.cmd            # Existing — may need update if hooks.json changes
  session-start           # Existing — unchanged

skills/
  pre-commit-review/
    SKILL.md              # NEW — Layer 2 smart skill

commands/
  pre-commit-review.md    # NEW — slash command to invoke skill manually
```

### New Command: `commands/pre-commit-review.md`

```markdown
---
description: "Run contextual pre-commit review on staged changes — catches what regex misses"
disable-model-invocation: true
---

Invoke the pre-commit-review skill and follow it exactly.
```

---

## Testing the System

### Test Layer 1 (Fast Hook)

1. Create a test file with a fake secret:
   ```bash
   echo 'API_KEY=sk-ant-oat01-fakefakefakefake123456' > test-secret.txt
   git add test-secret.txt
   git commit -m "test"
   ```
   **Expected:** Hook blocks with CRITICAL finding.
   **Cleanup:** `git reset HEAD test-secret.txt && rm test-secret.txt`

2. Create a file with a company reference:
   ```bash
   echo '// Ported from the MinRes internal repo' > test-ref.txt
   git add test-ref.txt
   git commit -m "test"
   ```
   **Expected:** Hook blocks with BLOCK finding.
   **Cleanup:** `git reset HEAD test-ref.txt && rm test-ref.txt`

3. Stage a .env file:
   ```bash
   echo 'DB_URL=postgres://localhost/test' > .env.local
   git add -f .env.local
   git commit -m "test"
   ```
   **Expected:** Hook blocks with CRITICAL finding.
   **Cleanup:** `git reset HEAD .env.local && rm .env.local`

4. Commit a clean file:
   ```bash
   echo '# Clean file' > test-clean.md
   git add test-clean.md
   git commit -m "test clean commit"
   ```
   **Expected:** Hook passes, commit proceeds (or Layer 2 invoked).
   **Cleanup:** `git reset HEAD~1 && rm test-clean.md`

### Test Layer 2 (Smart Skill)

1. Create a file with a contextual leak:
   ```bash
   echo '// This was written for Ahmed at the Perth office' > test-context.txt
   git add test-context.txt
   ```
   Run `/pre-commit-review`.
   **Expected:** Skill flags the personal reference (name + location).

2. Create a file with a false positive:
   ```bash
   echo '# Example: API_KEY=sk-example-not-a-real-key' > test-fp.txt
   git add test-fp.txt
   ```
   Run `/pre-commit-review`.
   **Expected:** Skill recognises this as a documentation example, passes.

---

## Plugin.json Update

Add the new skill and command to Software Forge's `plugin.json`:

```json
"pre-commit-review": {
  "path": "skills/pre-commit-review/SKILL.md",
  "description": "Contextual review of staged git changes — Layer 2 of the pre-commit gate"
}
```

And update `hooks/hooks.json` to include the PreToolUse hook for Bash
alongside the existing SessionStart hook.

---

## Implementation Priority

1. **Create `hooks/pre-commit-scan.sh`** — the fast hook script
2. **Update `hooks/hooks.json`** — add the PreToolUse matcher
3. **Create `skills/pre-commit-review/SKILL.md`** — the smart skill
4. **Create `commands/pre-commit-review.md`** — the slash command
5. **Update `plugin.json`** — register the new skill
6. **Test all four scenarios** from the testing section above
7. **Update CLAUDE.md** — add the Pre-Commit Gate section
