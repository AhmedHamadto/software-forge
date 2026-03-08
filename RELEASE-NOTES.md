# Release Notes

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
