# Software Forge — Quick Reference

## I want to…

| Goal | Run |
|------|-----|
| Start a new project or major feature | `/software-forge` |
| Spin up a web app fast | `/quick-web` |
| Spin up an iOS app fast | `/quick-mobile` |
| Explore an idea before committing | `/brainstorm` |
| Design a system's data/storage/distribution layer | `/system-design` |
| Turn a design doc into implementation tasks | `/write-plan` |
| Execute an existing plan | `/execute-plan` |
| Audit security before deploying | `/security-audit` |
| Learn engineering while building | `/software-forge` → choose **Learn** mode |

## Commands

| Command | What it does |
|---------|-------------|
| `/software-forge` | Full lifecycle — classify, design, build, review |
| `/quick-web` | Full-stack web, skips classification |
| `/quick-mobile` | iOS app, skips classification |
| `/brainstorm` | Idea → approved design doc |
| `/system-design` | DDIA-grounded architecture review |
| `/write-plan` | Design doc → TDD task breakdown |
| `/execute-plan` | Run a plan with review checkpoints |
| `/security-audit` | CSP, RLS, auth, deps, OWASP |

## Skills by Category

### Orchestration
| Skill | One-liner |
|-------|-----------|
| `software-forge` | Project router and phase sequencer |
| `brainstorming` | Idea → design doc via dialogue |
| `engineering-mentor` | Teaches while it builds |

### Architecture & Design
| Skill | One-liner |
|-------|-----------|
| `ddia-design` | 8-phase system design (Kleppmann) |
| `writing-plans` | TDD task breakdown from specs |
| `executing-plans` | Batch execution with checkpoints |

### Implementation
| Skill | One-liner |
|-------|-----------|
| `test-driven-development` | Red → green → refactor |
| `systematic-debugging` | 4-phase root cause analysis |
| `dispatching-parallel-agents` | Run independent tasks concurrently |
| `subagent-driven-development` | One subagent per task, review between |
| `verification-before-completion` | Evidence before assertions |

### Code Review
| Skill | One-liner |
|-------|-----------|
| `requesting-code-review` | Dispatch reviewer before merge |
| `receiving-code-review` | Handle feedback with rigor |
| `code-simplifier` | Strip over-engineering |

### Git & Release
| Skill | One-liner |
|-------|-----------|
| `using-git-worktrees` | Isolated feature branches |
| `finishing-a-development-branch` | Merge, PR, or cleanup |
| `release` | Bump, tag, notes, push |

### Security
| Skill | One-liner |
|-------|-----------|
| `security-audit` | Config + dependency audit |
| `web-app-security-audit` | 10-phase pen test methodology |

### UI/UX & Platform
| Skill | One-liner |
|-------|-----------|
| `ui-polish-review` | Visual quality (Refactoring UI) |
| `ux-usability-review` | Usability (Don't Make Me Think) |
| `apple-craftsman` | macOS SwiftUI with cinematic polish |
| `mobile-ios-design` | iOS HIG + SwiftUI patterns |
| `design-code-review` | SwiftUI code against Design+Code |
| `voice-agent-prompt` | LiveKit agent system prompts |

### Meta
| Skill | One-liner |
|-------|-----------|
| `using-software-forge` | Skill discovery and routing |

## Common Workflows

**New full-stack project:**
`/software-forge` → classify → brainstorm → domain model → system design → API spec → infra → UI → UX → plan → implement → security → polish → retro

**Quick feature on existing project:**
`/brainstorm` → `/write-plan` → `/execute-plan` → `/requesting-code-review`

**Bug fix:**
`/systematic-debugging` → fix → `/verification-before-completion`

**Ship a release:**
`/requesting-code-review` → `/finishing-a-development-branch` → `/release`

## Phase Map

| # | Phase | Book |
|---|-------|------|
| 0 | Classification | — |
| 0.5 | Existing System Assessment | Brownfield only |
| 1 | Brainstorming | — |
| 2 | Domain Modeling | Evans |
| 3 | System Design + Security | Kleppmann |
| 4 | Resilience Patterns | Nygard |
| 5 | ML Pipeline Design | Huyen |
| 6 | Edge Architecture | IoT patterns |
| 7 | API Specification | Contract-first |
| 8 | Voice Prompt Design | — |
| 9 | Infrastructure Design | Morris |
| 10 | UI Design | Wathan, Bell, Kholmatova |
| 11 | UX Design | Krug, Cooper, Pickering |
| 12 | Motion Design | Thomas, Nabors, Head |
| 13 | Cost Analysis & Risk | Unit economics |
| 14 | Implementation Planning | Freeman & Pryce |
| 15 | Implementation | — |
| 16 | Security Validation | — |
| 17 | Observability Design | Majors |
| 18 | ML Validation | Chen |
| 19 | Polish & Review | Wathan, Krug |
| 20 | Retrospective | — |

## Project Types → Phases

| Type | Typical phases |
|------|---------------|
| macOS App | 0, 1, 10, 11, 12, 14, 15, 19, 20 |
| iOS App | 0, 1, 2, 7, 10, 11, 12, 14, 15, 16, 19, 20 |
| Web Frontend | 0, 1, 7, 10, 11, 14, 15, 16, 19, 20 |
| Full-Stack Web | 0, 1, 2, 3, 4, 7, 9, 10, 11, 13, 14, 15, 16, 17, 19, 20 |
| Voice Agent | 0, 1, 2, 3, 4, 7, 8, 9, 13, 14, 15, 16, 17, 19, 20 |
| Edge/IoT + ML | 0, 1, 2, 3, 4, 5, 6, 7, 9, 13, 14, 15, 16, 17, 18, 19, 20 |

## Gotchas

| Problem | Fix |
|---------|-----|
| `/software-forge` not found, only `software-forge:software-forge` works | Plugin not installed correctly — re-run install or check `~/.claude/settings.json` for the plugin path |
| "Model invocation disabled" message | Normal — commands use `disable-model-invocation: true` to inline instructions directly. Not an error. |
| Skills not loading | Check symlinks: `ls -la ~/.claude/skills/` — re-install if broken |
| Resuming a paused project | Re-run `/software-forge` in the same directory — it reads `docs/plans/` to find your phase |
| `docs/plans/` deleted mid-project | Must restart from Phase 0 — commit `docs/plans/` after each phase to prevent this |
