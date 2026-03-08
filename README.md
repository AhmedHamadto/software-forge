# Software Forge

Full software development lifecycle for AI coding agents. Classifies your project, sequences design phases grounded in 17 engineering books, and orchestrates 28 skills from idea to deployment.

```
                         "I'm building a SaaS with Supabase, Stripe, and auth"
                                              |
                                              v
                                    +-------------------+
                                    |  Project Router    |
                                    |  (classification)  |
                                    +--------+----------+
                                             |
                          +------------------+------------------+
                          v                  v                  v
                    +----------+      +----------+      +----------+
                    |  Build   |      |  Learn   |      |  Resume  |
                    | (speed)  |      | (teach)  |      | (detect) |
                    +----+-----+      +----+-----+      +----+-----+
                         |                 |                  |
                         +--------+--------+                  |
                                  v                           |
              +-------------------------------------+         |
              |  Phase Plan: 1>2>3>4>7>9>10>11>13>  |<--------+
              |  14>15>16>17>19>20                   |
              +----------------+--------------------+
                               |
           +-------------------+-------------------+
           v                   v                   v
    +-------------+     +-------------+     +-------------+
    | Design Docs |     | Tested Code |     | Audit Logs  |
    | (grounded   |     | (TDD, code  |     | (security,  |
    |  in books)  |     |  review)    |     |  UX, UI)    |
    +-------------+     +-------------+     +-------------+
```

## Install

```bash
# One command — installs all 28 skills
git clone https://github.com/AhmedHamadto/software-forge.git
cd software-forge && ./install.sh

# Or install just what you need
./install.sh --core    # Orchestrator + TDD + debugging + reviews (14 skills)
./install.sh --web     # Core + UI/UX + security (19 skills)
./install.sh --mobile  # Core + iOS/macOS design + security (18 skills)
./install.sh --learn   # Core + engineering mentor (15 skills)
```

Or via npx:

```bash
npx skills add AhmedHamadto/software-forge -g
```

## Use

In Claude Code, type: `/software-forge`

It asks what you're building, classifies your project type, selects the right phases, and walks you through each one.

Fast-track commands for common project types:
- `/quick-web` — Full-stack web project (skips classification)
- `/quick-mobile` — iOS mobile app (skips classification)

## What It Does

- **Classifies** your project (web, mobile, voice agent, edge/IoT, etc.)
- **Routes** to the right phases (7-20 depending on complexity)
- **Executes** each phase sequentially, grounded in engineering books
- **Produces** design docs, implementation plans, and validated code

Optional: See [docs/recommended-mcps.md](docs/recommended-mcps.md) for free tools that enhance specific phases.

## Learn More

- [Full Guide](docs/FULL-GUIDE.md) — All 28 skills, phase details, book references, troubleshooting
- [Improvement Plan](docs/improvement.md) — Current roadmap
- [Contributing](CONTRIBUTING.md) — How to add skills or improve phases

## Prerequisites

- [Claude Code](https://claude.ai/claude-code) installed and working
- macOS or Linux (bash required for install script)

## Acknowledgements

The execution pipeline skills (writing-plans, executing-plans, subagent-driven-development, test-driven-development, systematic-debugging, verification-before-completion, dispatching-parallel-agents, using-git-worktrees, finishing-a-development-branch, requesting-code-review, receiving-code-review) are from [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent.

The plugin packaging structure, multi-platform configs (`.claude-plugin/`, `.cursor-plugin/`, `.codex/`, `.opencode/`), slash commands, and distribution approach are modeled after [everything-claude-code](https://github.com/affaan-m/everything-claude-code) by Affaan Mustafa.

## License

MIT
