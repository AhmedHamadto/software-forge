#!/usr/bin/env bash
# Software Forge — Claude Code Skills Installer
#
# Installs skills by symlinking them into ~/.claude/skills/
# so Claude Code discovers them automatically.
#
# Usage:
#   ./install.sh              # Install all skills
#   ./install.sh --list       # List available skills
#   ./install.sh --uninstall  # Remove all symlinks
#   ./install.sh skill1 ...   # Install specific skills only

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
SKILLS_DST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

# Named groups
GROUP_CORE="software-forge using-software-forge brainstorming writing-plans \
  executing-plans subagent-driven-development test-driven-development \
  systematic-debugging using-git-worktrees finishing-a-development-branch \
  verification-before-completion dispatching-parallel-agents \
  requesting-code-review receiving-code-review code-simplifier"

GROUP_WEB="$GROUP_CORE ui-polish-review ux-usability-review \
  security-audit web-app-security-audit ddia-design"

GROUP_MOBILE="$GROUP_CORE mobile-ios-design apple-craftsman \
  design-code-review ux-usability-review security-audit"

GROUP_LEARN="$GROUP_CORE engineering-mentor"

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' RED='' BLUE='' BOLD='' NC=''
fi

info()  { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[x]${NC} $*" >&2; }
header(){ echo -e "\n${BOLD}${BLUE}$*${NC}"; }

list_skills() {
  header "Available Skills ($(ls "$SKILLS_SRC" | wc -l | tr -d ' ') total)"
  echo ""
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill=$(basename "$skill_dir")
    # Extract description from SKILL.md frontmatter
    desc=$(sed -n 's/^description: //p' "$skill_dir/SKILL.md" 2>/dev/null | head -1)
    printf "  ${BOLD}%-35s${NC} %s\n" "$skill" "${desc:-No description}"
  done
  echo ""
}

install_skill() {
  local skill=$1
  local src="$SKILLS_SRC/$skill"
  local dst="$SKILLS_DST/$skill"

  if [ ! -d "$src" ]; then
    error "Skill not found: $skill (run ./install.sh --list to see available skills)"
    return 1
  fi

  # If destination exists and is a symlink to us, skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  [=] $skill (already installed)"
    return 0
  fi

  # If destination exists but is something else, warn and back up
  if [ -e "$dst" ]; then
    local backup="${dst}.bak"
    if [ -e "$backup" ]; then
      warn "$skill exists at $dst — removing old backup and backing up current"
      rm -rf "$backup"
    else
      warn "$skill exists at $dst — backing up to ${backup}"
    fi
    mv "$dst" "$backup"
  fi

  ln -s "$src" "$dst"
  info "$skill"
}

uninstall_skills() {
  header "Uninstalling Software Forge skills..."
  local count=0
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill=$(basename "$skill_dir")
    dst="$SKILLS_DST/$skill"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$SKILLS_SRC/$skill" ]; then
      rm "$dst"
      info "Removed: $skill"
      count=$((count + 1))
    fi
  done
  # Clean up any .bak files created during previous installs
  local bak_count=0
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill=$(basename "$skill_dir")
    bak="$SKILLS_DST/${skill}.bak"
    if [ -e "$bak" ]; then
      rm -rf "$bak"
      bak_count=$((bak_count + 1))
    fi
  done

  if [ $count -eq 0 ] && [ $bak_count -eq 0 ]; then
    echo "  No Software Forge skills were installed."
  else
    echo ""
    info "Removed $count skills."
    if [ $bak_count -gt 0 ]; then
      info "Cleaned up $bak_count backup(s)."
    fi
  fi
}

# --- Main ---

case "${1:-}" in
  --list|-l)
    list_skills
    exit 0
    ;;
  --uninstall|-u)
    uninstall_skills
    exit 0
    ;;
  --help|-h)
    echo "Software Forge — Claude Code Skills Installer"
    echo ""
    echo "Usage:"
    echo "  ./install.sh              Install all skills"
    echo "  ./install.sh --core       Core orchestrator + TDD + debugging + git + reviews (14 skills)"
    echo "  ./install.sh --web        Core + UI/UX + security + system design (19 skills)"
    echo "  ./install.sh --mobile     Core + iOS/macOS design + security (18 skills)"
    echo "  ./install.sh --learn      Core + engineering mentor (15 skills)"
    echo "  ./install.sh --full       Everything (28 skills)"
    echo "  ./install.sh --list       List available skills"
    echo "  ./install.sh --uninstall  Remove all symlinks"
    echo "  ./install.sh skill1 ...   Install specific skills only"
    echo ""
    echo "Environment:"
    echo "  CLAUDE_SKILLS_DIR   Override install directory (default: ~/.claude/skills)"
    exit 0
    ;;
  --core)
    GROUP_SELECTED=true
    SKILLS=($GROUP_CORE)
    ;;
  --web)
    GROUP_SELECTED=true
    SKILLS=($GROUP_WEB)
    ;;
  --mobile)
    GROUP_SELECTED=true
    SKILLS=($GROUP_MOBILE)
    ;;
  --learn)
    GROUP_SELECTED=true
    SKILLS=($GROUP_LEARN)
    ;;
  --full)
    GROUP_SELECTED=true
    SKILLS=()
    for skill_dir in "$SKILLS_SRC"/*/; do
      SKILLS+=("$(basename "$skill_dir")")
    done
    ;;
esac

header "Software Forge Installer"
echo ""
echo "Source:      $SKILLS_SRC"
echo "Destination: $SKILLS_DST"
echo ""

# Ensure destination exists
if [ ! -d "$SKILLS_DST" ]; then
  mkdir -p "$SKILLS_DST"
  info "Created $SKILLS_DST"
fi

# Determine which skills to install (skip if group flag already set SKILLS)
if [ "${GROUP_SELECTED:-}" != "true" ]; then
  if [ $# -gt 0 ]; then
    SKILLS=("$@")
  else
    SKILLS=()
    for skill_dir in "$SKILLS_SRC"/*/; do
      SKILLS+=("$(basename "$skill_dir")")
    done
  fi
fi

header "Installing ${#SKILLS[@]} skills..."
echo ""

installed=0
failed=0
for skill in "${SKILLS[@]}"; do
  if install_skill "$skill"; then
    installed=$((installed + 1))
  else
    failed=$((failed + 1))
  fi
done

echo ""
if [ $failed -eq 0 ]; then
  info "Done! $installed skills installed."
else
  warn "$installed installed, $failed failed."
fi

echo ""
echo "Skills are now available in Claude Code via /skill-name"
echo "Example: /software-forge, /brainstorming, /test-driven-development"
echo ""
