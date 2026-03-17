# Release Notes

## v1.2.0 (2026-03-17)

### Architecture Analysis Suite

Four new skills that give the forge deep architecture analysis capabilities — audit what you have, check what you're planning, query best practices, and compare brownfield vs greenfield approaches.

**stack-audit** scans any project against a 15-domain, 7-layer taxonomy and produces a coverage matrix, gap analysis, maturity score (0-100), and prioritized recommendations. It answers "what do we have and how mature is it?" — useful when onboarding to a new codebase, planning tech debt work, or running a pre-launch readiness check.

**stack-compatibility-oracle** is a pre-flight check for proposed tech stacks. Before writing code, it checks whether chosen technologies across layers actually work together — runtime compatibility, deployment fit, integration quality, scale limits, and team capability. It flags BLOCKER/WARNING/INFO issues and gives a GO / GO WITH CAVEATS / NO-GO verdict. Ships with 20 curated known incompatibilities and 6 proven stack references.

**architecture-best-practices** is a queryable knowledge base of community-proven patterns across all 15 taxonomy domains. Supports four query modes: domain ("best practices for Data Storage"), combination ("Next.js + Supabase + Vercel"), problem ("API slow under load"), and comparison ("PostgreSQL vs DynamoDB for this use case"). Each practice includes why it matters, when it applies, and which other domains it affects.

**brownfield-greenfield** extracts the intent graph from an existing project (what problems it solves, what patterns it uses, what constraints exist), strips away all technology choices, redesigns fresh using current best practices, and presents a side-by-side comparison. The user decides what (if anything) to change. Five phases: Extract, Abstract, Redesign, Compare, Discuss.

### Orchestrator Fixes

The phase routing and control flow got a thorough audit and several fixes:

- **Phase 8 (Voice Prompt Design)** was a 5-line stub — expanded to a full 81-line phase with 20 questions, deliverable template, and decision log
- **Route table phase counts** were wrong for all 6 project types (Phases 19 and 20 were added after counts were set). Corrected: macOS 8–10, iOS 8–15, Web FE 8–10, Full-Stack 14–17, Voice 13–15, Edge/IoT+ML 16–19
- **Phase 15 → 16 handoff** was implicit — both execution paths (subagent-driven and executing-plans) now have explicit return-to-orchestrator instructions. The executing-plans path includes a warning that skipping Phases 16-20 means shipping without security validation
- **Phase 13 Go/No-Go** had no loop-back mechanism when the verdict was "Redesign Required." Added a Decision Gate with specific phase-to-revisit mapping based on failure reason
- **Phase 19** had no concrete deliverable, making resumption detection unreliable. Added a review summary template
- **Decision Logs** added to Phases 0.5, 16, 18, 19, and 20 for consistency

### Commands Streamlined

Removed three commands that didn't pull their weight:
- `/execute-plan` — invoked by `/write-plan`, not a standalone entry point
- `/quick-web` and `/quick-mobile` — the orchestrator classifies in one question; dedicated shortcuts saved no meaningful time

Added `/stack-audit` for standalone tech stack auditing without running the full orchestrator.

### Hooks Cleaned Up

Removed the SessionStart hook that injected `using-software-forge` into every conversation. Skill descriptions and the user's CLAUDE.md handle triggering naturally — the injection was aggressive and added friction on simple tasks.

Pre-commit security scanner (PreToolUse hook) kept — it catches secrets, personal/company references, hardcoded paths, and .env files before they reach git history.

### Skill Description Tuning

Three skill descriptions updated based on trigger accuracy analysis (8/10 → ~10/10):
- **brownfield-greenfield** — added "inheriting a codebase" trigger to catch inherited-project queries
- **architecture-best-practices** — added "how to combine technologies" trigger for direct best-practice lookups
- **stack-audit** — added negative boundary to distinguish from brownfield-greenfield

### Full Changelog

- feat: add stack-audit skill (15-domain × 7-layer taxonomy audit)
- feat: add stack-compatibility-oracle skill (pre-flight architecture check)
- feat: add architecture-best-practices skill (queryable knowledge base)
- feat: add brownfield-greenfield skill (intent extraction + redesign comparison)
- feat: add /stack-audit command
- fix: expand Phase 8 from 5-line stub to full phase (81 lines)
- fix: correct route table phase counts for all 6 project types
- fix: add explicit Phase 15 → 16 handoff for both execution paths
- fix: add Go/No-Go Decision Gate with loop-back in Phase 13
- fix: add deliverable template to Phase 19
- fix: add Decision Logs to Phases 0.5, 16, 18, 19, 20
- fix: correct Book References label (Phase 14: "Testing Strategy" → "Writing Plans")
- refactor: remove /execute-plan, /quick-web, /quick-mobile commands
- refactor: remove SessionStart hook injection
- refactor: remove orphaned hook scripts (session-start, run-hook.cmd)
- refactor: remove orphaned license field from code-simplifier frontmatter
- docs: update skill count from 26 to 30 across all docs
- docs: add 4 new skills to FULL-GUIDE and QUICK-REFERENCE tables
- docs: update command tables in README, FULL-GUIDE, QUICK-REFERENCE
- chore: bump version to 1.2.0 across all manifests

### Bundled Skills (30 total)
- **Orchestrator**: software-forge, engineering-mentor
- **Architecture Analysis**: stack-audit, stack-compatibility-oracle, architecture-best-practices, brownfield-greenfield
- **Design & Planning**: brainstorming, ddia-design, writing-plans
- **Execution**: executing-plans, subagent-driven-development, dispatching-parallel-agents, test-driven-development, systematic-debugging, verification-before-completion, using-git-worktrees, finishing-a-development-branch
- **Code Review**: requesting-code-review, receiving-code-review
- **Security**: security-audit, web-app-security-audit
- **Review & Polish**: ui-polish-review, ux-usability-review, design-code-review, code-simplifier, apple-craftsman, mobile-ios-design
- **Specialty**: voice-agent-prompt
- **Release**: release
- **Meta**: using-software-forge

### Slash Commands (6)
- `/software-forge` — Start the full lifecycle
- `/brainstorm` — Standalone brainstorming
- `/system-design` — Standalone DDIA review
- `/write-plan` — Standalone implementation planning
- `/security-audit` — Standalone security audit
- `/stack-audit` — Standalone tech stack audit

---

## v1.0.0 (2026-03-07)

Initial release.

### The Orchestrator
- **software-forge** skill: Universal project lifecycle router
- 6 project types: macOS App, iOS Mobile, Web Frontend, Full-Stack Web, Voice Agent, Edge/IoT+ML
- 20-phase lifecycle (no project runs all of them — the router selects 6-16 based on type)
- Route table with conditional phases based on sub-classification
- Phase plan compilation step to prevent skipping/wrong phases
- Resumption protocol: detects current phase from existing `docs/plans/` artifacts
- Context compaction at two checkpoints (after planning, after implementation)

### Build or Learn
- **Build** mode runs the full orchestrator at speed
- **Learn** mode activates the **engineering-mentor** wrapper, which teaches software engineering concepts at every architectural decision point while building at the same quality

### Engineering Mentor
An adaptive teaching layer that wraps software-forge:
- 4 decision gates: Auto-Decide (green), Teaching (blue), Socratic (yellow), Critical (red)
- 31 concept areas across 17 books
- 5 confidence levels: none, emerging, developing, confident, mastery
- Persistent profile at `~/.claude/engineer-profile/profile.md`
- Per-project learning ledger at `docs/learning-ledger.md`
- Trajectory system: Apprentice, Architect, Specialist, Mentor

### Inline Design Phases
- **Phase 0**: Project classification with route table
- **Phase 0.5**: Existing system assessment (brownfield support)
- **Phase 2**: Domain modeling grounded in *Domain-Driven Design* (Evans)
- **Phase 4**: Resilience patterns grounded in *Release It!* (Nygard)
- **Phase 5**: ML pipeline design grounded in *Designing Machine Learning Systems* (Huyen)
- **Phase 6**: Edge architecture design for IoT/device constraints
- **Phase 7**: Contract-first API specification
- **Phase 9**: Infrastructure design grounded in *Infrastructure as Code* (Morris) with cost estimation
- **Phase 10**: UI design grounded in *Refactoring UI*, *Every Layout*, *Design Systems*
- **Phase 11**: UX design grounded in *Don't Make Me Think*, *About Face*, *Inclusive Design Patterns*
- **Phase 12**: Motion design grounded in *The Illusion of Life*, *Animation at Work*, *Designing Interface Animation*
- **Phase 13**: Cost analysis & risk assessment with go/no-go decision
- **Phase 17**: Observability design grounded in *Observability Engineering* (Majors)
- **Phase 18**: ML validation grounded in *Reliable Machine Learning* (Chen et al.)
- **Phase 20**: Retrospective & feedback loop

### Design-Time Injections
- **Security-by-design**: Threat modeling, auth, and validation questions injected at DDIA Phases 2, 3, and 5
- **Accessibility-by-design**: WCAG compliance questions injected at DDIA Phase 8
- **Cost estimation**: Unit economics and scale projections in infrastructure phase

### Bundled Skills (26 total)
- **Orchestrator**: software-forge, engineering-mentor
- **Design & Planning**: brainstorming, ddia-design, writing-plans
- **Execution**: executing-plans, subagent-driven-development, dispatching-parallel-agents, test-driven-development, systematic-debugging, verification-before-completion, using-git-worktrees, finishing-a-development-branch
- **Code Review**: requesting-code-review, receiving-code-review
- **Security**: security-audit, web-app-security-audit
- **Review & Polish**: ui-polish-review, ux-usability-review, design-code-review, code-simplifier, apple-craftsman, mobile-ios-design
- **Specialty**: voice-agent-prompt
- **Release**: release
- **Meta**: using-software-forge

*Note: repo-scan, legal-audit, and pre-commit-review moved to [developer-guard](https://github.com/AhmedHamadto/developer-guard).*

### Platform Support
- Claude Code: Plugin manifest + SessionStart hook
- Cursor: Plugin manifest
- Codex: Symlink-based installation
- OpenCode: Symlink-based installation

### Slash Commands
- `/software-forge` — Start the full lifecycle
- `/brainstorm` — Standalone brainstorming
- `/system-design` — Standalone DDIA review
- `/write-plan` — Standalone implementation planning
- `/execute-plan` — Standalone plan execution
- `/security-audit` — Standalone security audit
- `/repo-scan` — *(moved to developer-guard)*
- `/legal-audit` — *(moved to developer-guard)*

### Grounded In
17 software engineering books:
- *Domain-Driven Design* (Evans)
- *Designing Data-Intensive Applications* (Kleppmann)
- *Release It!* (Nygard)
- *Designing Machine Learning Systems* (Huyen)
- *Infrastructure as Code* (Morris)
- *Growing Object-Oriented Software, Guided by Tests* (Freeman & Pryce)
- *Observability Engineering* (Majors et al.)
- *Reliable Machine Learning* (Chen et al.)
- *Refactoring UI* (Wathan & Schoger)
- *Every Layout* (Bell & Pickering)
- *Design Systems* (Kholmatova)
- *Don't Make Me Think* (Krug)
- *About Face* (Cooper)
- *Inclusive Design Patterns* (Pickering)
- *The Illusion of Life* (Thomas & Johnston)
- *Animation at Work* (Nabors)
- *Designing Interface Animation* (Head)

### Acknowledgements
- Execution pipeline skills from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- Plugin packaging structure modeled after [everything-claude-code](https://github.com/affaan-m/everything-claude-code) by Affaan Mustafa
