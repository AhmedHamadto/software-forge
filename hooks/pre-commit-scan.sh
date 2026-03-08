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

# Files that contain patterns as documentation/regex, not real secrets
is_self_referencing() {
  case "$1" in
    *pre-commit*|*hooks.json*) return 0 ;;
    *) return 1 ;;
  esac
}

# --- Check 1: Secrets & API Keys ---
SECRETS_PATTERN='sk-[a-zA-Z0-9_-]{20,}|pk-[a-zA-Z0-9_-]{20,}|ghp_[a-zA-Z0-9]{36}|gho_[a-zA-Z0-9]{36}|xoxb-|xoxp-|-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----|ANTHROPIC_API_KEY\s*=\s*["\x27]?sk-|OPENAI_API_KEY\s*=\s*["\x27]?sk-|SUPABASE_SERVICE_ROLE_KEY\s*=\s*["\x27]?eyJ|eyJ[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}'

while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  is_self_referencing "$file" && continue
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
  is_self_referencing "$file" && continue
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
  is_self_referencing "$file" && continue
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
