# Software Forge

**The orchestration and education layer for AI coding agents.**

Software Forge sequences your entire project lifecycle so you never
skip a phase, never design UI before your API shape is settled, and
never ship without security validation. It invokes the best specialist
tools at each phase — yours or the ecosystem's — and optionally
teaches you engineering principles at every decision point.

> "I have an idea. Now what? In what order? How do the pieces
> connect? And can you teach me why along the way?"

[DEMO GIF PLACEHOLDER — will be added after recording]

## Install

Works with Claude Code, Cursor, Codex, Copilot, and any agent
supporting the Agent Skills standard.

```bash
# Plugin install (recommended)
/plugin install software-forge@AhmedHamadto/software-forge
```

```bash
# Or via npx
npx add-skill AhmedHamadto/software-forge
```

```bash
# Or clone and install
git clone https://github.com/AhmedHamadto/software-forge.git
cd software-forge && ./install.sh

# Install groups
./install.sh --core    # Orchestrator + TDD + debugging + reviews (15 skills)
./install.sh --web     # Core + UI/UX + security (20 skills)
./install.sh --mobile  # Core + iOS/macOS design + security (20 skills)
./install.sh --learn   # Core + engineering mentor (16 skills)
```

## Use

In Claude Code, type: `/software-forge`

It asks what you're building, classifies your project, selects the right phases, and walks you through each one.

Fast-track commands: `/quick-web` (full-stack web) | `/quick-mobile` (iOS app)

## What Makes It Different

- **It's an orchestrator, not another skill.** Sequences 26 bundled skills and integrates with 349+ ecosystem skills — Figma MCP, Motion AI Kit, Trail of Bits, Context7, and more.
- **It teaches you engineering.** Learn mode wraps every phase with adaptive teaching — Socratic questions, decision gates, and competency tracking across 31 concept areas from 17 books.
- **It integrates with the ecosystem.** Checks for available MCP servers and skills at each phase. Uses real design tokens, current docs, or falls back to book-grounded questions.

## Phases

| # | Phase | Grounded In |
|---|-------|-------------|
| 0 | Project Classification | Router logic |
| 0.5 | Existing System Assessment | Brownfield projects only |
| 1 | Brainstorming | — |
| 2 | Domain Modeling | *Domain-Driven Design* (Evans) |
| 3 | System Design + Security | *DDIA* (Kleppmann) |
| 4 | Resilience Patterns | *Release It!* (Nygard) |
| 5 | ML Pipeline Design | *Designing ML Systems* (Huyen) |
| 6 | Edge Architecture | IoT patterns |
| 7 | API Specification | Contract-first design |
| 8 | Voice Prompt Design | — |
| 9 | Infrastructure Design | *Infrastructure as Code* (Morris) |
| 10 | UI Design | *Refactoring UI*, *Every Layout*, *Design Systems* |
| 11 | UX Design | *Don't Make Me Think*, *About Face*, *Inclusive Design Patterns* |
| 12 | Motion Design | *Illusion of Life*, *Animation at Work*, *Designing Interface Animation* |
| 13 | Cost Analysis & Risk | Unit economics, risk register |
| 14 | Implementation Planning | *GOOS* (Freeman & Pryce) |
| 15 | Implementation | — |
| 16 | Security Validation | — |
| 17 | Observability Design | *Observability Engineering* (Majors) |
| 18 | ML Validation | *Reliable ML* (Chen et al.) |
| 19 | Polish & Review | *Refactoring UI*, *Don't Make Me Think* |
| 20 | Retrospective | Process review |

## Companion

Pairs with [developer-guard](https://github.com/AhmedHamadto/developer-guard) for pre-commit safety and pre-launch audits.

```bash
/plugin install developer-guard@AhmedHamadto/developer-guard
```

## Docs

- [Full Guide](docs/FULL-GUIDE.md) — All 26 skills, phase details, book references, troubleshooting
- [Architecture](docs/ARCHITECTURE.md) — How the orchestrator, phases, and skills connect
- [Recommended MCPs](docs/recommended-mcps.md) — Free tools that enhance specific phases
- [Contributing](CONTRIBUTING.md) — How to add skills or improve phases
- [Improvement Plan](docs/improvement.md) — Current roadmap

## Acknowledgements

**Adapted from:**
- Execution pipeline skills (writing-plans, executing-plans, subagent-driven-development, TDD, debugging, git-worktrees, code-review) from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- Plugin packaging structure and multi-platform configs from [everything-claude-code](https://github.com/affaan-m/everything-claude-code) by Affaan Mustafa

**Built by Software Forge:**
- The orchestrator — project classification, route table, phase sequencing, resumption protocol
- 20 lifecycle phases with conditional routing per project type
- 10 inline design phases grounded in 17 engineering books
- Adaptive engineering mentor with competency tracking across 31 concept areas
- Ecosystem integration layer — Figma MCP, Motion AI Kit, Context7, and more

## License

MIT
