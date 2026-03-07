# Software Forge — Architecture

## System Overview

Software Forge is a skill orchestration framework for Claude Code that guides projects from idea to deployment. It consists of three layers:

```
┌─────────────────────────────────────────────────────────────────┐
│                      USER INTERFACE                             │
│                                                                 │
│  /software-forge          Entry point — classifies, routes      │
│  /engineering-mentor      Learn mode — wraps forge with teaching│
└───────────────────────────────┬─────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────┐
│                     ORCHESTRATION LAYER                          │
│                                                                 │
│  Phase Router ──▶ Phase Plan ──▶ Sequential Execution           │
│                                                                 │
│  20 phases available, 6-16 selected per project type            │
│  Each phase either invokes a skill or runs an inline session    │
└───────────────────────────────┬─────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────┐
│                       SKILL LAYER (28 skills)                   │
│                                                                 │
│  ┌──────────────┐ ┌────────────────┐ ┌────────────────────────┐ │
│  │ Design &     │ │ Implementation │ │ Review & Security      │ │
│  │ Planning     │ │ & Execution    │ │                        │ │
│  │              │ │                │ │                        │ │
│  │ brainstorm   │ │ executing-plans│ │ security-audit         │ │
│  │ ddia-design  │ │ subagent-dev   │ │ web-app-security-audit │ │
│  │ writing-plans│ │ parallel-agents│ │ ui-polish-review       │ │
│  │ voice-prompt │ │ tdd            │ │ ux-usability-review    │ │
│  │              │ │ debugging      │ │ design-code-review     │ │
│  │              │ │ verification   │ │ code-simplifier        │ │
│  │              │ │ git-worktrees  │ │ apple-craftsman        │ │
│  │              │ │ finishing-dev  │ │ mobile-ios-design      │ │
│  │              │ │ req-code-review│ │ repo-scan              │ │
│  │              │ │ recv-code-rev  │ │ legal-audit            │ │
│  └──────────────┘ └────────────────┘ └────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependency Graph

### Phase → Skill Invocations

These are the direct invocations from phase files. Every other phase runs inline (no skill dependency).

```
software-forge (orchestrator)
│
├── Phase 1:  Brainstorming ──────────▶ /brainstorming
├── Phase 3:  System Design ──────────▶ /ddia-design
├── Phase 8:  Voice Prompt ───────────▶ /voice-agent-prompt
├── Phase 14: Implementation Plan ────▶ /writing-plans
├── Phase 15: Implementation ─────────▶ /subagent-driven-development
│                                   OR▶ /executing-plans
│                                      └──▶ /dispatching-parallel-agents
│                                      └──▶ /test-driven-development
│                                      └──▶ /systematic-debugging
│                                      └──▶ /verification-before-completion
│                                      └──▶ /using-git-worktrees
│                                      └──▶ /requesting-code-review
│                                      └──▶ /receiving-code-review
│                                      └──▶ /finishing-a-development-branch
├── Phase 16: Security Validation ────▶ /security-audit
│                                  AND▶ /web-app-security-audit
└── Phase 19: Polish & Review ────────▶ /ui-polish-review      (web)
                                   AND▶ /ux-usability-review   (web, iOS)
                                   AND▶ /design-code-review    (macOS, iOS)
                                   AND▶ /apple-craftsman       (macOS)
                                   AND▶ /mobile-ios-design     (iOS)
                                   AND▶ /code-simplifier       (all)
```

### Engineering Mentor Wrapper

```
engineering-mentor
│
├── Wraps ──▶ software-forge (full orchestrator, unchanged)
│
├── Reads  ──▶ ~/.claude/engineer-profile/profile.md
│              (competency heat map, session ledger, learning prefs)
│
├── Reads  ──▶ ./concepts/*.md (17 concept files, on-demand)
│              Only loads individual concept sections when a
│              teaching gate fires. Never loads all at once.
│
├── Reads  ──▶ ./profile/schema.md (profile template)
│
└── Writes ──▶ docs/learning-ledger.md (per-project gate log)
               docs/learning-snapshot.md (project completion summary)
```

### Meta & Utility Skills

```
using-software-forge ──▶ Routes to the correct skill based on user request
release              ──▶ Semver tagging, release notes, changelog
```

---

## Skill Catalog

### Tier 1: Orchestration (2 skills)

| Skill | Invoked By | Invokes | Artifacts Produced |
|-------|-----------|---------|-------------------|
| `software-forge` | User via `/software-forge` | All phase skills | Phase plan, routes to all downstream skills |
| `engineering-mentor` | User via Build/Learn choice | `software-forge` | `engineer-profile/profile.md`, `learning-ledger.md` |

### Tier 2: Design & Planning (4 skills)

| Skill | Invoked By | Invokes | Artifacts Produced |
|-------|-----------|---------|-------------------|
| `brainstorming` | Phase 1 | — | `docs/plans/YYYY-MM-DD-<topic>-design.md` |
| `ddia-design` | Phase 3 | — | `docs/plans/YYYY-MM-DD-<topic>-system-design.md` |
| `voice-agent-prompt` | Phase 8 | — | Voice agent system prompt |
| `writing-plans` | Phase 14 | — | `docs/plans/YYYY-MM-DD-<topic>-plan.md` |

### Tier 3: Implementation & Execution (10 skills)

| Skill | Invoked By | Invokes | Description |
|-------|-----------|---------|-------------|
| `executing-plans` | Phase 15 | TDD, debugging, verification | Executes plans in separate session with review checkpoints |
| `subagent-driven-development` | Phase 15 | TDD, debugging, verification | Dispatches one subagent per task, code review between tasks |
| `dispatching-parallel-agents` | Execution skills | — | Runs independent tasks concurrently |
| `test-driven-development` | Execution skills | — | Red-green-refactor discipline |
| `systematic-debugging` | Execution skills | — | 4-phase root cause analysis |
| `verification-before-completion` | Execution skills | — | Evidence before assertions |
| `using-git-worktrees` | Execution skills | — | Isolate feature work safely |
| `finishing-a-development-branch` | Execution skills | — | Branch completion: merge, PR, or cleanup |
| `requesting-code-review` | Execution skills | — | Dispatch code reviewer subagent |
| `receiving-code-review` | Execution skills | — | Process review feedback rigorously |

### Tier 4: Review & Security (10 skills)

| Skill | Invoked By | Project Types | Grounded In |
|-------|-----------|--------------|-------------|
| `security-audit` | Phase 16 | All with auth/data | OWASP Top 10 |
| `web-app-security-audit` | Phase 16 | Web, Full-Stack | 10-phase pentest methodology |
| `ui-polish-review` | Phase 19 | Web, Full-Stack, Edge (webapp) | *Refactoring UI* |
| `ux-usability-review` | Phase 19 | Web, Full-Stack, iOS, Voice | *Don't Make Me Think* |
| `design-code-review` | Phase 19 | macOS, iOS | Design+Code principles |
| `code-simplifier` | Phase 19 | All | Complexity reduction |
| `apple-craftsman` | Phase 19 | macOS | SwiftUI visual design |
| `mobile-ios-design` | Phase 19 | iOS | Apple HIG |
| `repo-scan` | Pre-launch | All | Secrets, PII, hardcoded paths |
| `legal-audit` | Pre-launch | All | License, IP, attribution |

### Tier 5: Meta (2 skills)

| Skill | Purpose |
|-------|---------|
| `using-software-forge` | Skill discovery and routing |
| `release` | Version management and release notes |

---

## Phase Routing Matrix

Which phases fire for which project type. **x** = always, **o** = conditional, blank = skip.

```
Phase                        macOS  iOS   Web-FE  Full-Stack  Voice  Edge/IoT+ML
─────────────────────────────────────────────────────────────────────────────────
 0   Classification            x     x      x        x         x        x
 0.5 System Assessment         o     o      o        o         o        o
 1   Brainstorming             x     x      x        x         x        x
 2   Domain Modeling                 o               x         x        x
 3   System Design + Security        o               x         x        x
 4   Resilience Patterns             o               x         x        x
 5   ML Pipeline                                                        x
 6   Edge Architecture                                                  x
 7   API Specification               o               x         x        x
 8   Voice Prompt Design                                       x
 9   Infrastructure                                  o         o        x
10   UI Design                 x     x      x        x                  o
11   UX Design                 x     x      x        x                  o
12   Motion Design             o     o      o        o
13   Cost Analysis                                   x         x        x
14   Implementation Planning   x     x      x        x         x        x
15   Implementation            x     x      x        x         x        x
16   Security Validation             o               x         x        x
17   Observability                                   x         x        x
18   ML Validation                                                      x
19   Polish & Review           x     x      x        x         x        x
20   Retrospective             x     x      x        x         x        x
─────────────────────────────────────────────────────────────────────────────────
Typical phase count:         6-7   7-12   7-8     12-13       11      13-16
```

---

## Engineering Mentor — Learning System

### Decision Gate Model

Every decision during a build is classified into one of four gates:

```
┌─────────────────────────────────────────────────────────────┐
│                    DECISION POINT                           │
│                                                             │
│  Is it safety/cost/irreversible? ──YES──▶ RED (approve)     │
│         │ NO                                                │
│  Is a book concept relevant?                                │
│         │ YES                                               │
│  Engineer confidence = none/emerging? ──▶ BLUE (teach)      │
│  Engineer confidence = developing?    ──▶ YELLOW (Socratic) │
│  Engineer confidence = confident?     ──▶ YELLOW (refresh)  │
│  Engineer confidence = mastery?       ──▶ GREEN (silent)    │
│         │ NO                                                │
│  Safe and reversible? ──────────────▶ GREEN (auto-decide)   │
└─────────────────────────────────────────────────────────────┘
```

| Gate | Behavior | Profile Update |
|------|----------|---------------|
| GREEN | Auto-decide, show in phase-end summary | None |
| BLUE | Pause, teach concept using user's code, continue | Promote to `emerging`, log |
| YELLOW | Socratic question; if gap found, escalate to BLUE | Promote if answered well, log |
| RED | Full reasoning + stakes, require explicit approval | Log decision |

### Competency Tracking

- 31 concept areas from 17 books
- 5 confidence levels: `none` → `emerging` → `developing` → `confident` → `mastery`
- Persists at `~/.claude/engineer-profile/profile.md`
- Updated immediately after each gate fires, not at session end

### Trajectory System

| Trajectory | Unlocks When | System Role |
|-----------|-------------|-------------|
| Apprentice (default) | — | System designs and builds, teaching along the way |
| Architect | 8/10 areas at `confident`+ | User designs, system reviews |
| Specialist | 1 area at `mastery` | Deep-dives beyond core books |
| Mentor | 6/10 areas at `confident`+ | User creates teaching content |

---

## File System Layout

```
software-forge/
├── README.md
├── LICENSE                          (MIT)
├── CONTRIBUTING.md
├── RELEASE-NOTES.md
├── install.sh                       (symlink installer)
│
├── skills/
│   ├── software-forge/
│   │   ├── SKILL.md                 (orchestrator instructions)
│   │   └── phases/
│   │       ├── phase-00.5-system-assessment.md
│   │       ├── phase-01-brainstorming.md
│   │       ├── ...
│   │       └── phase-20-retrospective.md
│   │
│   ├── engineering-mentor/
│   │   ├── SKILL.md                 (mentor wrapper instructions)
│   │   ├── concepts/                (17 concept files)
│   │   │   ├── domain-driven-design.md
│   │   │   ├── ddia.md
│   │   │   ├── release-it.md
│   │   │   └── ...
│   │   └── profile/
│   │       └── schema.md            (profile template)
│   │
│   ├── brainstorming/SKILL.md
│   ├── ddia-design/SKILL.md
│   ├── writing-plans/SKILL.md
│   ├── ... (25 more skills)
│   └── using-software-forge/SKILL.md
│
├── commands/                        (slash commands)
├── hooks/                           (git hooks)
├── tests/                           (skill tests)
└── docs/
    └── ARCHITECTURE.md              (this file)
```

---

## Competitive Positioning

| Feature | Software Forge | Cursor Rules | Aider | Raw Claude Code |
|---------|---------------|-------------|-------|----------------|
| Project classification | 6 types, auto-routed | Manual | None | None |
| Phase orchestration | 20 phases, conditional | None | None | None |
| Book-grounded design | 17 books integrated | None | None | None |
| Adaptive teaching | 31 concepts, 4 gates | None | None | None |
| Competency tracking | Persistent profile | None | None | None |
| TDD enforcement | Built-in skill | Optional rule | Optional | Manual |
| Security-by-design | Injected into design phase | Afterthought | None | Manual |
| Multi-platform | macOS, iOS, web, voice, IoT | Web-focused | Any | Any |
| Resumption | Artifact-based detection | None | None | Manual |

---

## Key Metrics (for PM tracking)

| Metric | How to Measure |
|--------|---------------|
| Skills installed | Count of symlinks in `~/.claude/skills/` pointing to software-forge |
| GitHub stars | `gh api repos/AhmedHamadto/software-forge --jq .stargazers_count` |
| Install method breakdown | Track which install option users report using |
| Phase completion rate | How many projects complete all selected phases vs abandon mid-way |
| Learn mode adoption | % of users selecting Learn vs Build |
| Concept coverage | Average % of 31 concept areas touched per project |
| Skill invocation frequency | Which skills get invoked most (brainstorming, writing-plans likely top) |
| Time-to-first-phase | How quickly a new user gets from install to Phase 1 output |
| Resumption success rate | % of interrupted projects that correctly resume |
