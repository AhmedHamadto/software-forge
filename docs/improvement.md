# Software-Forge Improvement Plan

*Last updated: 2026-03-08*

This document is an executable improvement plan. Each fix includes exact file paths, what to change, and success criteria. Run these in Claude Code sequentially — later fixes build on earlier ones.

---

## Part A: Context Compaction Resilience (Existing — Enhanced)

### Problem Statement

When a software-forge session compacts (runs out of context window), three things break:

1. **Teaching context is lost.** The engineering-mentor conducts Socratic dialogues, corrections, and nuanced design discussions. These live only in conversation memory. After compaction, the summary captures *what was decided* but not *why* — the reasoning, the wrong answers that were corrected, the analogies that clicked. Post-compaction phases lose the pedagogical thread.

2. **Long implementation plans bloat the context window.** The writing-plans skill produces 500-1000 line plans inline in the conversation. This consumes 15-20% of the context window before a single line of code is written. If execution happens in the same session, compaction is guaranteed mid-implementation, and the plan itself gets summarized away.

3. **Learn mode gates get skipped after compaction.** The engineering-mentor's gate protocol (check profile confidence → decide gate type → teach/test/auto) runs from conversation context. After compaction, the summary says "Phase 12 complete, proceed to Phase 13" but the mentor doesn't re-establish its gate logic. Teaching phases get treated as auto-execute phases.

### Root Cause

Software-forge assumes a single continuous context window. It stores everything in conversation memory and reads from disk only for resumption (detecting which phase you're on via `docs/plans/` artifacts). There's no intermediate persistence layer between "full conversation context" and "check if a file exists on disk."

---

### Fix 1: Decision Log (survives compaction)

**What:** After each design phase, append a `## Decision Log` section to the design doc on disk.

**Why:** Design docs capture *decisions* but not *reasoning*. The Decision Log captures the "why" — rejected alternatives, key trade-offs, user corrections, analogies that worked. When a new session or post-compaction context reads the design doc, it gets the reasoning, not just the output.

**Where to change:**
- `skills/software-forge/SKILL.md` — In the "Phase Execution" section, add after the existing step 3 ("Produce the deliverable it specifies"):
  ```
  3b. Append a Decision Log entry to the design doc on disk
      capturing: what was decided, what was rejected, why,
      and any user corrections or teaching moments.
  ```
- Each inline design phase file (Phases 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 17) — append to the deliverable template:
  ```markdown
  ### Decision Log — Phase [N]: [Name]
  - **[Topic]:** Chose [X] over [Y] because [reasoning].
  - **Rejected:** [Alternative] — [why it was rejected].
  - **User correction:** [If the user corrected a direction, capture what changed and why].
  ```

**Format example:**
```markdown
### Decision Log — Phase 10: UI Design
- **Typography:** Chose 1.2 ratio scale over 1.25 because the app is information-dense and needs tighter spacing. User initially suggested 1.33 but agreed 1.2 after seeing the math.
- **Layout:** NavigationSplitView over custom sidebar because standard macOS convention = zero learning curve.
- **Rejected:** Tab bar instead of three-column layout. Inspector needs to coexist with content, not replace it.

### Decision Log — Phase 12: Motion Design
- **Timing:** 700ms hard ceiling. User learned that >700ms feels broken, not smooth.
- **Meaningful test:** Every animation must answer "would removing this lose spatial context?" Tooltip hover fade = decorative (removed). Tab slide = meaningful (kept).
```

**Test:** After compaction, start a new session. Read the design doc. The Decision Log should give you enough context to understand *why* decisions were made, not just *what* was decided.

---

### Fix 2: Plan Size Management

**What:** The writing-plans skill must ALWAYS save to disk first and NEVER keep the full plan in conversation context. The plan file on disk is the source of truth. The conversation should only contain a summary table.

**Why:** A 900-line plan in conversation context guarantees compaction during execution. The executing-plans and subagent-driven-development skills already read plans from disk. The plan doesn't need to live in conversation memory.

**Where to change:**
- `skills/writing-plans/SKILL.md` — Find the section where the plan is output and add this instruction block:

  ```markdown
  ## Output Protocol (MANDATORY)

  After generating the full plan:
  1. Write the complete plan to `docs/plans/YYYY-MM-DD-<topic>-plan.md`
  2. Display ONLY a summary table to the conversation:

  | # | Task | Files | Tests | Est. Complexity |
  |---|------|-------|-------|-----------------|
  | 1 | [name] | [count] | [count] | S/M/L |

  3. End with: "Full plan saved to `docs/plans/[filename]`. [N] tasks, [M] files, [T] tests."

  Do NOT output the full plan to the conversation. The plan lives on disk.
  ```

**Current behavior:**
```
[Generates 900-line plan] → [Outputs entire plan to conversation] → [Saves to disk]
```

**Desired behavior:**
```
[Generates plan] → [Saves to disk] → [Outputs 20-line summary table only]
```

**Test:** After writing a plan, check that conversation context contains only the summary table, and `docs/plans/` contains the full plan file.

---

### Fix 3: Learn Mode Checkpoint File

**What:** The engineering-mentor writes a checkpoint file to disk after each phase, capturing the current gate protocol state. After compaction or session resumption, the mentor reads this file to re-establish Learn mode.

**Why:** The compaction summary says "Phase 12 complete" but doesn't carry the mentor's internal state — which concepts were just taught, what the next gate type should be, whether to test or teach. A checkpoint file bridges this gap.

**Where to change:**
- `skills/engineering-mentor/SKILL.md` — Add a "Checkpoint Protocol" section:

  ```markdown
  ## Checkpoint Protocol

  After EVERY phase gate (teach, test, or auto), write or update
  the checkpoint file at `docs/plans/.mentor-checkpoint.json`.

  This is not optional. Compaction or session loss will destroy
  your gate state. The checkpoint file is your recovery mechanism.

  On resumption or post-compaction:
  1. Read `.mentor-checkpoint.json`
  2. Read the engineer profile from disk
  3. Re-announce: "Resuming Learn mode from Phase {currentPhase}.
     Last session covered: {conceptsTaughtThisSession}."
  4. Continue with the correct gate protocol for the next phase
  ```

- `skills/software-forge/SKILL.md` — In the Resumption Protocol section, add:
  ```
  5. If `docs/plans/.mentor-checkpoint.json` exists, read it.
     If mode is "learn", invoke engineering-mentor with the
     stored state instead of continuing in Build mode.
  ```

**Checkpoint file location:** `docs/plans/.mentor-checkpoint.json`

**Format:**
```json
{
  "currentPhase": 13,
  "mode": "learn",
  "lastGateType": "teaching",
  "conceptsTaughtThisSession": [
    "The 12 Principles",
    "Timing & Easing",
    "State Transitions",
    "Meaningful vs Decorative"
  ],
  "pendingConceptsNextPhase": [],
  "profilePath": "~/.claude/engineer-profile/profile.md",
  "designDocPath": "docs/plans/2026-03-07-command-center-design.md",
  "timestamp": "2026-03-08T14:30:00Z"
}
```

**Test:** Start a Learn mode session. Complete 3 phases. Kill the session. Start a new session in the same project. Software-forge should detect the checkpoint, invoke engineering-mentor, and resume with correct gate state.

---

### Fix 4: Resumption Protocol Enhancement

**What:** Extend the existing resumption protocol to read the Decision Log and mentor checkpoint.

**Where to change:**
- `skills/software-forge/SKILL.md`, Resumption Protocol section — Add:
  ```
  5. If `docs/plans/.mentor-checkpoint.json` exists, read it
     and resume in Learn mode with the stored state.
  6. If the design doc contains `### Decision Log` sections,
     read them to understand prior reasoning before continuing.
  ```

**Depends on:** Fix 1 and Fix 3.

---

### Fix 5: Engineer Profile Update Duplication

**What:** The engineer profile update is currently only in the subagent-driven-development completion checklist. It needs redundant triggers in Phase 20 and in per-phase gate logic.

**Why:** The subagent-driven-development checklist gets compacted away after Phase 15. By the time Phase 20 runs, the instruction to update the profile no longer exists in context.

**Where to change:**
- `skills/software-forge/phases/phase-20-retrospective.md` — Add as the FIRST item:
  ```markdown
  ### Mandatory: Update Engineer Profile
  If running in Learn mode (check `docs/plans/.mentor-checkpoint.json`),
  update the engineer profile at `~/.claude/engineer-profile/profile.md`:
  - Add session ledger entries for concepts taught/tested
  - Promote competency levels where verification passed
  - Add this project to the project history section
  This step is NOT optional. Do it before the retrospective content.
  ```
- `skills/engineering-mentor/SKILL.md` — Add per-phase profile write after each teaching/testing gate (not just at session end). This makes updates incremental and compaction-proof.

**Current behavior:**
```
Phase 15 (subagent checklist says "update profile") → compaction → Phase 19-20 (no profile instruction) → profile skipped
```

**Desired behavior:**
```
Each phase gate → update profile incrementally → Phase 20 → final profile update as mandatory step
```

---

## Part B: MCP & Ecosystem Integration (New)

### Problem Statement

Software Forge's design and review phases (UI, Motion, UX, Polish) are self-contained question-answer sessions that produce good documents but don't connect to the external tools that would make them dramatically better. The ecosystem now has mature, free MCPs and skills for Figma, motion design, animation auditing, and library documentation — but Software Forge doesn't know they exist.

The fix is NOT to depend on these tools. It's to be *aware* of them and use them when available, while falling back gracefully to the existing question-based approach.

### Root Cause

Software Forge was built before the MCP ecosystem matured. Each phase assumes it's working purely from conversation context and book-grounded questions. There's no "check what tools are available and use them" step.

---

### Fix 6: Optional MCP Awareness in Design Phases

**What:** Add a "Tool Integration" section to phase files that checks for available MCPs and uses them if present, otherwise falls back to the existing approach.

**Why:** A Figma MCP can pull real design tokens in seconds. A motion audit skill can identify animation gaps automatically. But not every user will have these installed. The phase must work with or without them.

**Where to change:**

**`skills/software-forge/phases/phase-10-ui-design.md`** — Add before "Questions to Ask":
```markdown
### Tool Integration (if available)

Before starting the question-based design process, check for available tools:

1. **Figma MCP connected?** (check via /mcp)
   - If yes: "Paste a link to your existing Figma file. I'll pull the
     current design tokens (colors, spacing, typography, components)
     and use them as the starting point for this phase."
   - Use the extracted tokens to pre-fill the Visual Hierarchy and
     Design System sections below, then validate with the user.

2. **No design tool available?**
   - Continue with the question-based approach below. This works
     perfectly — the questions are designed to extract the same
     information through dialogue.
```

**`skills/software-forge/phases/phase-12-motion-design.md`** — Add before "Questions to Ask":
```markdown
### Tool Integration (if available)

Before starting the question-based motion design process, check for available tools:

1. **Design Motion Principles skill installed?**
   (check ~/.claude/skills/design-motion-principles/)
   - If yes: Run the three-lens audit (Emil Kowalski, Jakub Krehel,
     Jhey Tompkins) on the existing codebase first to identify
     animation gaps and existing patterns.
   - Use the audit output to pre-populate the State Transitions
     and Choreography sections below.

2. **Motion AI Kit / Motion MCP available?**
   - If yes: Run /motion-audit to classify existing animations
     by render pipeline cost (S-tier to F-tier).
   - Use the audit to inform the Performance section.

3. **Neither available?**
   - Continue with the question-based approach below. The book-
     grounded questions produce excellent motion design specs
     without any tooling.
```

**`skills/software-forge/phases/phase-19-polish-review.md`** — Add after the existing route table:
```markdown
### Additional Tool Integration (if available)

After running the primary review skills above, check for:

1. **Design Motion Principles skill?**
   - Run three-lens motion audit on the final codebase
2. **Motion AI Kit?**
   - Run /motion-audit for performance classification
3. **Context7 MCP?**
   - Verify any library-specific patterns against current docs
   (not training-data-stale docs)

These are additive — they enhance the review, they don't replace it.
```

**Test:** Run Phase 10 with Figma MCP connected — it should pull tokens first. Run Phase 10 without Figma MCP — it should fall back to questions. Both should produce a complete UI Design section.

---

### Fix 7: Recommended MCPs Documentation

**What:** Create a `docs/recommended-mcps.md` file that maps phases to free/open-source MCPs and skills.

**Why:** Positions Software Forge as a hub that connects to the ecosystem without depending on it. Users discover tools they didn't know existed, and the orchestrator becomes more valuable over time as the ecosystem grows.

**Where to create:** `docs/recommended-mcps.md`

**Content:**
```markdown
# Recommended MCP Servers & Skills

Software Forge works without any external tools. Every phase falls
back to a question-based approach grounded in engineering books.
However, these free tools dramatically enhance specific phases
when available.

## Phase-to-Tool Mapping

| Phase | Tool | Type | What It Adds | Install |
|-------|------|------|-------------|---------|
| 10 UI Design | Figma MCP (official) | MCP | Pull real design tokens, components, layout | `claude mcp add --transport http figma https://mcp.figma.com/mcp` |
| 12 Motion Design | Design Motion Principles | Skill | Three-lens motion audit (Kowalski/Krehel/Tompkins) | `cp -r design-motion-principles/skills/* ~/.claude/skills/` |
| 12 Motion Design | Motion AI Kit | MCP+Skills | 330+ examples, /motion-audit, perf classification | motion.dev/docs/ai-kit (requires Motion+, one-time payment) |
| 15 Implementation | Context7 | MCP | Current library docs (not stale training data) | `claude mcp add context7 -- npx -y @context7/mcp` |
| 15 Implementation | typescript-lsp | Plugin | Real type checking, go-to-definition | `claude plugin install typescript-lsp@claude-plugins-official` |
| 16 Security | security-guidance | Plugin | Passive vulnerability scanning during coding | `claude plugin install security-guidance@claude-plugins-official` |
| 19 Polish | ui-polish-review (built-in) | Skill | Already included in Software Forge | — |
| 19 Polish | ux-usability-review (built-in) | Skill | Already included in Software Forge | — |

## Creative Tools (Optional)

| Tool | Type | What It Does | Install |
|------|------|-------------|---------|
| Blender MCP | MCP | AI-controlled 3D modeling, scene creation | `claude mcp add blender -- uvx blender-mcp` |
| Spline MCP | MCP | Interactive 3D web experiences | github.com/aydinfer/spline-mcp-server |
| GSAP MCP | MCP | Advanced scroll/timeline/path animations | github.com/guptaanant682/infi_gsap_mcp |

## How Software Forge Uses These

Software Forge checks for available tools at the start of each
design phase. If a relevant MCP or skill is connected, it uses
it to accelerate the phase. If not, it falls back to the book-
grounded question-based approach. You never need any of these
to get full value from Software Forge.
```

**Also add a one-line reference in the main README** (in the installation section):
```markdown
Optional: See [docs/recommended-mcps.md](docs/recommended-mcps.md) for free tools that enhance specific phases.
```

---

## Part C: Usability & Distribution (New)

### Problem Statement

Software Forge has 26 skills, which is powerful but intimidating for new users. The install is all-or-nothing. The `using-software-forge` meta-skill is aggressive in tone. The README is 19KB. These friction points reduce adoption without adding value.

---

### Fix 8: Tiered Installation

**What:** Add named install groups to `install.sh` so users can install only what they need.

**Where to change:** `install.sh` — Add group definitions after the existing individual skill logic:

```bash
# Named groups
declare -A GROUPS
GROUPS[core]="software-forge using-software-forge brainstorming writing-plans \
  executing-plans subagent-driven-development test-driven-development \
  systematic-debugging using-git-worktrees finishing-a-development-branch \
  verification-before-completion dispatching-parallel-agents \
  requesting-code-review receiving-code-review code-simplifier"

GROUPS[web]="${GROUPS[core]} ui-polish-review ux-usability-review \
  security-audit web-app-security-audit ddia-design"

GROUPS[mobile]="${GROUPS[core]} mobile-ios-design apple-craftsman \
  design-code-review ux-usability-review security-audit"

GROUPS[full]=""  # empty = install all (existing default behavior)

GROUPS[learn]="${GROUPS[core]} engineering-mentor"
```

Add to the usage/help section:
```bash
usage() {
  echo "Usage:"
  echo "  ./install.sh              Install all skills"
  echo "  ./install.sh --core       Core orchestrator + TDD + debugging + git + reviews (14 skills)"
  echo "  ./install.sh --web        Core + UI/UX + security + system design (19 skills)"
  echo "  ./install.sh --mobile     Core + iOS/macOS design + security (18 skills)"
  echo "  ./install.sh --learn      Core + engineering mentor (15 skills)"
  echo "  ./install.sh --full       Everything (26 skills)"
  echo "  ./install.sh --list       List available skills"
  echo "  ./install.sh --uninstall  Remove all symlinks"
  echo "  ./install.sh skill1 ...   Install specific skills only"
}
```

Add group handling in the main logic:
```bash
case "${1:-}" in
  --core|--web|--mobile|--full|--learn)
    group="${1#--}"
    if [[ "$group" == "full" || -z "${GROUPS[$group]}" ]]; then
      # Install all
      for skill_dir in "$SKILLS_SRC"/*/; do
        install_skill "$(basename "$skill_dir")"
      done
    else
      for skill in ${GROUPS[$group]}; do
        install_skill "$skill"
      done
    fi
    ;;
  # ... existing cases ...
esac
```

**Test:** `./install.sh --core` installs exactly 14 skills. `./install.sh --web` installs 19. `./install.sh` (no args) still installs all 28 (backward compatible).

---

### Fix 9: Soften the `using-software-forge` Meta-Skill

**What:** Replace the aggressive "EXTREMELY IMPORTANT" tone with clear, firm guidance that doesn't read like a threat.

**Why:** The current skill fights Claude with escalating urgency ("This is not negotiable. This is not optional. You cannot rationalize your way out of this."). This works for Ahmed because he built it and understands the intent. For new users and for Claude itself, a calmer but equally firm tone produces better compliance with less friction.

**Where to change:** `skills/using-software-forge/SKILL.md`

**Replace the opening block:**
```markdown
<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply...
...
This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>
```

**With:**
```markdown
## Core Rule

When a task matches a skill's description, invoke the skill before
responding. When in doubt, check — the cost of reading a skill
that doesn't apply is one read; the cost of skipping one that
does apply is rework, missed quality gates, and inconsistent output.

Skills are invoked BEFORE responding, including before asking
clarifying questions. The skill may contain the right way to ask
those questions.
```

**Replace the "Red Flags" table** with a shorter, less combative version:
```markdown
## Common Mistakes

| What you're tempted to do | Why it's wrong |
|--------------------------|---------------|
| "Let me just answer this quickly" | Skills provide better answers. Check first. |
| "I'll gather context, then check skills" | Skills tell you HOW to gather context. |
| "I remember this skill's content" | Skills evolve between sessions. Always re-read. |
| "This is too simple for a skill" | Simple tasks become complex. Skills prevent rework. |
```

**Keep** the Skill Priority section and the flow diagram — those are useful.

**Test:** Run a session with the softened meta-skill. Claude should still invoke skills consistently, but the conversation should feel less adversarial.

---

### Fix 10: Quick-Start Commands for Common Project Types

**What:** Add fast-path commands that bypass classification for the most common project types.

**Why:** Most users build web apps. Asking them to go through classification every time adds friction without value for known project types.

**Where to create:**

**`commands/quick-web.md`:**
```markdown
---
description: "Fast-track a full-stack web project — skips classification, pre-selects standard web phases"
disable-model-invocation: true
---

Set active phases to: 1, 2, 3, 4, 7, 10, 11, 12, 13, 14, 15, 16, 19, 20.

Then invoke the software-forge skill and start directly at Phase 1 (Brainstorming),
announcing the pre-selected phase plan to the user for confirmation before proceeding.

Skip Phase 0 (classification) entirely — the user has already told us this is a full-stack web project.
```

**`commands/quick-mobile.md`:**
```markdown
---
description: "Fast-track an iOS mobile app — skips classification, pre-selects standard iOS phases"
disable-model-invocation: true
---

Set active phases to: 1, 2, 3, 4, 7, 10, 11, 12, 13, 14, 15, 16, 19, 20.

Then invoke the software-forge skill and start directly at Phase 1 (Brainstorming),
announcing the pre-selected phase plan to the user for confirmation before proceeding.

Skip Phase 0 (classification) entirely — the user has already told us this is an iOS project.
```

**Also add to `plugin.json`** under a new commands section or verify they're auto-discovered from the commands/ directory.

**Test:** `/quick-web` should skip classification, present the phase plan, and start at Phase 1 on user confirmation.

---

### Fix 11: README Compression

**What:** Cut the README from 19KB to under 5KB. Move detailed content to `docs/`.

**Why:** First 50 users decide in 30 seconds. The README needs to answer: what is this, how do I install it, what happens when I run it.

**Where to change:** `README.md` — restructure to:

```markdown
# Software Forge

Full software development lifecycle for AI coding agents.
Classifies your project, sequences design phases grounded in
17 engineering books, and orchestrates 26 skills from idea
to deployment.

## Install

# One command — installs all 26 skills
git clone https://github.com/AhmedHamadto/software-forge.git
cd software-forge && ./install.sh

# Or install just what you need
./install.sh --core    # Orchestrator + TDD + debugging + reviews (14 skills)
./install.sh --web     # Core + UI/UX + security (19 skills)
./install.sh --learn   # Core + engineering mentor (15 skills)

## Use

In Claude Code, type: `/software-forge`

It asks what you're building, classifies your project type,
selects the right phases, and walks you through each one.

[Screenshot or GIF of phase plan output here]

## What It Does

- **Classifies** your project (web, mobile, voice agent, edge/IoT, etc.)
- **Routes** to the right phases (7-20 depending on complexity)
- **Executes** each phase sequentially, grounded in engineering books
- **Produces** design docs, implementation plans, and validated code

Optional: See [docs/recommended-mcps.md](docs/recommended-mcps.md)
for free tools that enhance specific phases.

## Learn More

- [Architecture](docs/ARCHITECTURE.md) — How it works under the hood
- [Skills List](docs/) — All 26 skills with descriptions
- [Contributing](CONTRIBUTING.md) — How to add skills or improve phases
- [Improvement Plan](docs/improvement.md) — Current roadmap
```

**Move the current README content** (book references, anti-patterns table, full skill descriptions, phase details) to `docs/FULL-GUIDE.md` so nothing is lost.

**Test:** New user should be able to go from README to working installation in under 2 minutes.

---

## Implementation Priority

| Priority | Fix | Impact | Effort | Depends On |
|----------|-----|--------|--------|-----------|
| 1 | Fix 2: Plan Size Management | Highest | Trivial — one instruction block in writing-plans | — |
| 2 | Fix 5: Profile Update Duplication | High | Trivial — one paragraph in phase-20 + engineering-mentor | — |
| 3 | Fix 9: Soften using-software-forge | High | Small — rewrite one file | — |
| 4 | Fix 11: README Compression | High | Medium — restructure + move content | — |
| 5 | Fix 1: Decision Log | High | Medium — add template to each design phase file | — |
| 6 | Fix 8: Tiered Installation | Medium | Medium — add group logic to install.sh | — |
| 7 | Fix 10: Quick-Start Commands | Medium | Small — two new command files | — |
| 8 | Fix 7: Recommended MCPs Doc | Medium | Small — one new file + README line | — |
| 9 | Fix 6: MCP Awareness in Phases | Medium | Medium — add sections to 3 phase files | — |
| 10 | Fix 3: Checkpoint File | Medium | Medium — new file format + read/write logic | — |
| 11 | Fix 4: Resumption Enhancement | Low | Small — add checkpoint reading to resumption | Fix 3 |

## Success Criteria

**Compaction resilience (Fixes 1-5):**
- A session that compacts mid-Phase-14 can resume with correct Learn mode gates in Phase 15
- Implementation plans consume ≤30 lines of conversation context (summary table only)
- Post-compaction design phases have access to prior reasoning via Decision Log on disk
- Engineer profile updates are never skipped — redundant triggers in orchestrator Phase 20 and engineering-mentor gates

**Ecosystem integration (Fixes 6-7):**
- Phase 10 with Figma MCP connected pulls design tokens before asking questions
- Phase 10 without Figma MCP falls back gracefully to question-based approach
- Phase 12 with Design Motion Principles skill runs three-lens audit automatically
- `docs/recommended-mcps.md` exists and is referenced from README

**Usability (Fixes 8-11):**
- `./install.sh --core` installs exactly 14 skills (backward compatible: no args = all 28)
- `using-software-forge` no longer contains "EXTREMELY IMPORTANT" or "not negotiable" language
- `/quick-web` starts a full-stack web project without classification
- README is under 5KB; full guide lives in `docs/FULL-GUIDE.md`
- New user can go from git clone to running `/software-forge` in under 2 minutes