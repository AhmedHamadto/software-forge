# Software Forge

An agentic skills framework for the full software development lifecycle. Tell it what you're building — it classifies your project, selects the right phases, and sequences the right skills from idea to deployment.

No project runs all phases. A macOS menu bar app hits 7-8. A full-stack SaaS hits 14-15. An edge IoT system with ML hits 15-18. The router picks what you need.

```
                         "I'm building a SaaS with Supabase, Stripe, and auth"
                                              │
                                              ▼
                                    ┌───────────────────┐
                                    │  Project Router    │
                                    │  (classification)  │
                                    └────────┬──────────┘
                                             │
                          ┌──────────────────┼──────────────────┐
                          ▼                  ▼                  ▼
                    ┌──────────┐      ┌──────────┐      ┌──────────┐
                    │  Build   │      │  Learn   │      │  Resume  │
                    │ (speed)  │      │ (teach)  │      │ (detect) │
                    └────┬─────┘      └────┬─────┘      └────┬─────┘
                         │                 │                  │
                         └────────┬────────┘                  │
                                  ▼                           │
              ┌─────────────────────────────────────┐         │
              │  Phase Plan: 1→2→3→4→7→9→10→11→13→  │◄────────┘
              │  14→15→16→17→19→20                  │
              └──────────────┬──────────────────────┘
                             │
           ┌─────────────────┼──────────────────┐
           ▼                 ▼                   ▼
    ┌─────────────┐   ┌─────────────┐    ┌─────────────┐
    │ Design Docs │   │ Tested Code │    │ Audit Logs  │
    │ (grounded   │   │ (TDD, code  │    │ (security,  │
    │  in books)  │   │  review)    │    │  UX, UI)    │
    └─────────────┘   └─────────────┘    └─────────────┘
```

## How it works

1. You pick a mode — **Build** (full speed) or **Learn** (build + teach)
2. You describe what you're building
3. Software Forge classifies it (macOS, iOS, web, full-stack, voice agent, edge/IoT+ML)
4. It compiles a phase plan — only the phases your project needs
5. Each phase either invokes a bundled skill or runs an inline design session
6. You end up with design docs, implementation plans, tested code, and review findings

Every design phase is grounded in a specific software engineering book. No hand-waving.

## Quickstart

```bash
npx skills add AhmedHamadto/software-forge -g
```

Then in Claude Code:

```
/software-forge
```

Pick **Build** (full speed) or **Learn** (build + teach), describe your project, and follow the phases.

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed and working
- macOS or Linux (bash required for install script)

## Install

### Option 1: npx skills (quickest)

```bash
npx skills add AhmedHamadto/software-forge -g
```

This uses the [skills CLI](https://github.com/vercel-labs/skills) to install all 28 skills globally to `~/.claude/skills/`.

Install specific skills only:

```bash
npx skills add AhmedHamadto/software-forge -g -s brainstorming -s test-driven-development
```

List available skills before installing:

```bash
npx skills add AhmedHamadto/software-forge --list
```

### Option 2: Git clone + symlink

```bash
git clone https://github.com/AhmedHamadto/software-forge.git
cd software-forge
./install.sh
```

This symlinks all 28 skills into `~/.claude/skills/` where Claude Code discovers them automatically. Skills are symlinked, so `git pull` updates them everywhere.

Install specific skills only:

```bash
./install.sh brainstorming test-driven-development systematic-debugging
```

Uninstall:

```bash
./install.sh --uninstall
```

To override the install directory, set `CLAUDE_SKILLS_DIR`:

```bash
CLAUDE_SKILLS_DIR=~/custom/path ./install.sh
```

---

Then start any project with:
```
/software-forge
```

You'll be asked to pick a mode:

- **(A) Build** — Full-speed design and implementation
- **(B) Learn** — Same build quality, plus book-grounded teaching at every decision point

Learn mode activates the **engineering-mentor** wrapper, which tracks your competency across 31 concept areas from 17 books, teaches via the Socratic method, and evolves from mentor to peer as you grow.

### Example First Run

```
> /software-forge

How would you like to work?
(A) Build — Full-speed design and implementation. No teaching pauses.
(B) Learn — Same build quality, plus I teach you software engineering
             concepts at every decision point.

> A

What are you building?

> A SaaS dashboard with Supabase, Stripe billing, and Google OAuth

Project type: Full-Stack Web
Active phases: 1, 2, 3, 4, 7, 9, 10, 11, 13, 14, 15, 16, 17, 19, 20

Starting Phase 1: Brainstorming...
```

## Slash Commands

These commands are available in Claude Code after installation:

| Command | Description |
|---------|-------------|
| `/software-forge` | Start a new project or major feature — full lifecycle |
| `/brainstorm` | Turn an idea into an approved design doc |
| `/system-design` | Run a structured system design review (DDIA) |
| `/write-plan` | Create a TDD implementation plan from a design doc |
| `/execute-plan` | Execute an implementation plan with review checkpoints |
| `/security-audit` | Audit CSP, RLS, auth, dependencies, and OWASP vulnerabilities |
| `/repo-scan` | Scan for secrets, personal data, hardcoded paths before publishing |
| `/legal-audit` | Audit license, IP, attribution, and claims accuracy |

## What's Inside

### The Orchestrator

| Skill | Purpose |
|-------|---------|
| **software-forge** | Project router — classifies your project, compiles phase plan, sequences everything |

### The Mentor

| Skill | Purpose |
|-------|---------|
| **engineering-mentor** | Adaptive teaching wrapper — builds systems while upskilling the engineer through decision gates, Socratic teaching, and competency tracking |

### Design & Planning

| Skill | Purpose |
|-------|---------|
| **brainstorming** | Turns ideas into approved design docs through collaborative dialogue |
| **ddia-design** | 8-phase system design review grounded in *Designing Data-Intensive Applications* |
| **writing-plans** | Produces bite-sized TDD implementation plans from design docs |

### Implementation & Execution

| Skill | Purpose |
|-------|---------|
| **executing-plans** | Executes implementation plans in a separate session with review checkpoints |
| **subagent-driven-development** | Dispatches fresh subagent per task with code review between tasks |
| **dispatching-parallel-agents** | Runs independent tasks concurrently via parallel subagents |
| **test-driven-development** | Red-green-refactor discipline for every feature and bugfix |
| **systematic-debugging** | 4-phase root cause analysis — never fix symptoms, always find the source |
| **verification-before-completion** | Evidence before assertions — run verification commands before claiming success |
| **using-git-worktrees** | Isolate feature work in git worktrees with safety verification |
| **finishing-a-development-branch** | Guide branch completion — merge, PR, or cleanup options |
| **requesting-code-review** | Dispatch code reviewer subagent to catch issues before merging |
| **receiving-code-review** | Process review feedback with technical rigor, not blind agreement |

### Security

| Skill | Purpose |
|-------|---------|
| **security-audit** | Audits CSP, RLS, auth, dependencies, and OWASP vulnerabilities |
| **web-app-security-audit** | 10-phase penetration testing methodology for web applications |
| **repo-scan** | Scans for secrets, personal data, hardcoded paths, and attribution gaps before publishing |
| **legal-audit** | Audits license compliance, IP risks, attribution, and claims accuracy before going public |

### Review & Polish

| Skill | Purpose |
|-------|---------|
| **ui-polish-review** | Visual quality review using *Refactoring UI* principles |
| **ux-usability-review** | Usability review using *Don't Make Me Think* principles |
| **design-code-review** | SwiftUI interface review against Design+Code principles |
| **code-simplifier** | Removes unnecessary abstractions and over-engineering |
| **apple-craftsman** | macOS desktop experience design with SwiftUI |
| **mobile-ios-design** | iOS Human Interface Guidelines and SwiftUI patterns |
| **voice-agent-prompt** | System prompt engineering for LiveKit voice agents |

### Release

| Skill | Purpose |
|-------|---------|
| **release** | Professional version releases — semver, release notes, tagging, no AI attribution |

### Meta

| Skill | Purpose |
|-------|---------|
| **using-software-forge** | Skill discovery and invocation — ensures the right skill is always loaded |

## Phases

The orchestrator selects from these phases based on project type:

| # | Phase | Source | Grounded In |
|---|-------|--------|-------------|
| 0 | Project Classification | Inline | Router logic |
| 0.5 | Existing System Assessment | Inline | Brownfield projects only |
| 1 | Brainstorming | `/brainstorming` | — |
| 2 | Domain Modeling | Inline | *Domain-Driven Design* (Evans) |
| 3 | System Design + Security | `/ddia-design` + inline | *DDIA* (Kleppmann) |
| 4 | Resilience Patterns | Inline | *Release It!* (Nygard) |
| 5 | ML Pipeline Design | Inline | *Designing ML Systems* (Huyen) |
| 6 | Edge Architecture | Inline | IoT patterns |
| 7 | API Specification | Inline | Contract-first design |
| 8 | Voice Prompt Design | `/voice-agent-prompt` | — |
| 9 | Infrastructure Design | Inline | *Infrastructure as Code* (Morris) |
| 10 | UI Design | Inline | *Refactoring UI*, *Every Layout*, *Design Systems* |
| 11 | UX Design | Inline | *Don't Make Me Think*, *About Face*, *Inclusive Design Patterns* |
| 12 | Motion Design | Inline | *Illusion of Life*, *Animation at Work*, *Designing Interface Animation* |
| 13 | Cost Analysis & Risk | Inline | Unit economics, risk register |
| 14 | Implementation Planning | `/writing-plans` | *GOOS* (Freeman & Pryce) |
| 15 | Implementation | `/executing-plans` | — |
| 16 | Security Validation | `/security-audit` | — |
| 17 | Observability Design | Inline | *Observability Engineering* (Majors) |
| 18 | ML Validation | Inline | *Reliable ML* (Chen et al.) |
| 19 | Polish & Review | `/ui-polish-review` + others | *Refactoring UI*, *Don't Make Me Think* |
| 20 | Retrospective | Inline | Process review, design-vs-reality gaps |

## Project Types

| Project Type | Phases | Example |
|---|---|---|
| macOS App | 6-7 | Menu bar utility, SwiftUI desktop app |
| iOS Mobile App | 7-12 | iPhone app with optional backend |
| Web Frontend | 7-8 | React SPA, static site |
| Full-Stack Web | 12-13 | SaaS app with database, API, auth |
| Voice Agent | 11 | LiveKit telephony, conversational AI |
| Edge/IoT + ML | 13-16 | Computer vision on Jetson, fleet management |

## Key Features

- **Build or Learn** — Choose full-speed Build mode or Learn mode, which wraps every phase with adaptive, book-grounded teaching
- **Engineering Mentor** — Tracks 31 concept areas across 17 books, teaches via the Socratic method at decision points, evolves from mentor to peer as competency grows
- **Frontend design phases** — UI, UX, and Motion design grounded in 9 books, from visual hierarchy to Disney's 12 principles
- **Accessibility-by-design** — WCAG compliance questions woven into the design phase, not bolted on after
- **Security-by-design** — Threat modeling, auth, and validation questions injected into DDIA phases
- **Cost estimation** — Unit economics, third-party API costs, and scale projections in the infrastructure phase
- **Resilience patterns** — Circuit breakers, timeout budgets, and graceful degradation per external dependency
- **Testing strategy** — Testing pyramid (unit, integration, contract, e2e, load) built into implementation planning
- **Resumption protocol** — Re-run `/software-forge` on a paused project and it detects which phase you're on by checking existing `docs/plans/` artifacts. Design phases keep full context; implementation and validation phases compact context and re-read from disk.
- **Brownfield support** — Phase 0.5 maps existing systems before designing new features

## Philosophy

1. **Design before code** — Every project gets a design doc, even "simple" ones. Unexamined assumptions cause the most wasted work.
2. **Test-driven development** — Write the test first, watch it fail, write minimal code to pass, refactor. No exceptions.
3. **Evidence before assertions** — Never claim something works without running the verification command and reading the output.
4. **Books over opinions** — Every design phase is grounded in a specific software engineering book by a recognized expert.

## Grounded In

| Book | Author | Applied In |
|---|---|---|
| *Domain-Driven Design* | Eric Evans | Phase 2 |
| *Designing Data-Intensive Applications* | Martin Kleppmann | Phase 3 |
| *Release It!* | Michael Nygard | Phase 4 |
| *Designing Machine Learning Systems* | Chip Huyen | Phase 5 |
| *Infrastructure as Code* | Kief Morris | Phase 9 |
| *Growing Object-Oriented Software, Guided by Tests* | Freeman & Pryce | Phase 14 |
| *Observability Engineering* | Charity Majors et al. | Phase 17 |
| *Reliable Machine Learning* | Cathy Chen et al. | Phase 18 |
| *Refactoring UI* | Wathan & Schoger | Phases 10, 19 |
| *Every Layout* | Andy Bell & Heydon Pickering | Phase 10 |
| *Design Systems* | Alla Kholmatova | Phase 10 |
| *Don't Make Me Think* | Steve Krug | Phases 11, 19 |
| *About Face* | Alan Cooper | Phase 11 |
| *Inclusive Design Patterns* | Heydon Pickering | Phase 11 |
| *The Illusion of Life* | Frank Thomas & Ollie Johnston | Phase 12 |
| *Animation at Work* | Rachel Nabors | Phase 12 |
| *Designing Interface Animation* | Val Head | Phase 12 |

## Engineering Mentor Profile

Learn mode tracks your growth in a persistent profile at `~/.claude/engineer-profile/profile.md`. The profile stores confidence levels (none, emerging, developing, confident, mastery) across 31 concept areas from 17 books.

On first run, you'll be asked your name and experience level. The system seeds initial confidence from your answer, then adjusts based on demonstrated competence — if you underestimate yourself, you'll be promoted quickly; if you overestimate, the system switches to deeper teaching without judgment.

**Profile management:**
- **Location**: `~/.claude/engineer-profile/profile.md`
- **Reset**: Delete the file and re-run `/engineering-mentor` to start fresh
- **Backup**: Copy the file to preserve your progress across machines
- **Per-project log**: Each project writes a learning ledger to `docs/learning-ledger.md`

## Troubleshooting

**Skills not loading after install:**
- Verify symlinks exist: `ls -la ~/.claude/skills/`
- Re-install a specific skill: `./install.sh brainstorming`
- Check Claude Code can see the skills directory

**install.sh permission denied:**
- Make it executable: `chmod +x install.sh`
- Or run with bash: `bash install.sh`

**Custom install directory:**
- Set `CLAUDE_SKILLS_DIR` before running: `CLAUDE_SKILLS_DIR=~/custom/path ./install.sh`

**Engineering mentor profile issues:**
- Wrong experience level? Delete `~/.claude/engineer-profile/profile.md` and re-run `/engineering-mentor`
- Profile not updating? The system writes to disk immediately after each gate — check file permissions

**Resuming a paused project:**
- Re-run `/software-forge` in the same project directory. It checks `docs/plans/` for existing artifacts and picks up where you left off.
- Do not delete `docs/plans/` mid-project — this is how the system tracks your progress.

**Phase failed or interrupted mid-way:**
- Re-run `/software-forge` in the same directory. The resumption protocol detects which phases completed based on artifacts in `docs/plans/` and picks up from the next phase.
- If a phase produced a partial artifact, review and complete it manually before re-running.

**`docs/plans/` corrupted or deleted:**
- If deleted mid-project, the orchestrator cannot determine your current phase. You'll need to restart from Phase 0 (classification).
- To prevent this, commit `docs/plans/` to version control after each phase completes.

**Running `/software-forge` in the wrong directory:**
- Always run `/software-forge` from your project's root directory. Artifacts are saved to `docs/plans/` relative to the current directory.
- If you accidentally ran it elsewhere, move the generated `docs/plans/` directory to the correct project root.

## Testing

Skills are prompt-based instructions, not executable code. Testing is done via Claude Code's headless mode and manual verification. See [docs/testing.md](docs/testing.md) for the testing approach, example test commands, and phase routing validation.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills, suggest phases, or propose new book groundings.

## Acknowledgements

The execution pipeline skills (writing-plans, executing-plans, subagent-driven-development, test-driven-development, systematic-debugging, verification-before-completion, dispatching-parallel-agents, using-git-worktrees, finishing-a-development-branch, requesting-code-review, receiving-code-review) are from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent.

The plugin packaging structure, multi-platform configs (`.claude-plugin/`, `.cursor-plugin/`, `.codex/`, `.opencode/`), slash commands, and distribution approach are modeled after [everything-claude-code](https://github.com/affaan-m/everything-claude-code) by Affaan Mustafa.

Software Forge builds on these foundations by adding project classification, phase routing, 15 inline design phases grounded in 17 software engineering books, and an adaptive engineering mentor.

## License

MIT
