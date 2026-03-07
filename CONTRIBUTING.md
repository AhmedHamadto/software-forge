# Contributing to Software Forge

Thanks for your interest in improving Software Forge. Every skill you add, phase you refine, or book grounding you propose makes the framework more useful for every engineer who uses it. The project grows through contributions like yours.

Contributions of all kinds are welcome — new skills, phase improvements, book groundings, bug fixes, and documentation.

## Adding a New Skill

1. Create a directory under `skills/your-skill-name/`
2. Add a `SKILL.md` with YAML frontmatter:

```markdown
---
name: your-skill-name
description: One-line description. Use when [trigger condition].
---

# Skill Title

## Overview
What this skill does and why it exists.

## When to Use
- Trigger condition 1
- Trigger condition 2

## Procedure
Step-by-step instructions the agent follows.
```

3. Register it in `.claude-plugin/plugin.json` under `"skills"` with `path` and `description` fields matching the SKILL.md frontmatter
4. Add a row to the appropriate section in `README.md`
5. Update skill counts across README, plugin configs, and marketplace.json

## Proposing a New Phase

Phases live in `skills/software-forge/phases/phase-XX-name.md`. To propose one:

1. Open an issue with the **Phase Suggestion** template
2. Explain what gap the phase fills and which project types it applies to
3. If grounded in a book, name the book and the specific concepts used
4. If approved, add the phase file, update the route table in `skills/software-forge/SKILL.md`, and update the README phase table

## Suggesting a Book Grounding

Each book grounds a specific concept area in the engineering-mentor skill. To suggest a new book:

1. Open an issue explaining which concept the book covers
2. Describe how it would integrate with existing phases
3. If accepted, add a concept file to `skills/engineering-mentor/concepts/` with Deep, Refresher, and Socratic question sections

## Areas Where Help Is Wanted

- **Android/Kotlin skill** — equivalent of `mobile-ios-design` for Android
- **CI/CD phase** — pipeline design between implementation and security validation
- **Performance testing skill** — load testing, profiling, benchmarking
- **Database migration skill** — schema evolution patterns and rollback strategies


## Testing

Skills are prompt-based instructions, not executable code. Before submitting:

1. Run `./install.sh --list` to verify your skill appears with the correct description
2. Invoke your skill in Claude Code and verify the procedure runs correctly
3. If you changed phase routing, test with at least two project types to confirm the route table is correct

See [docs/testing.md](docs/testing.md) for the full testing approach including headless mode tests and phase routing validation.

## Code of Conduct

This project follows the [Contributor Covenant v2.1](CODE_OF_CONDUCT.md). Be respectful, constructive, and welcoming.

## Submitting Changes

1. Fork the repo and create a branch
2. Make your changes
3. Run `./install.sh --list` to verify skill discovery works
4. Test your changes by invoking the affected skills in Claude Code
5. Open a PR with a clear description of what changed and why
