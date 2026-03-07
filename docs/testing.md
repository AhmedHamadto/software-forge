# Testing Software Forge Skills

## Approach

Skills are tested using Claude Code's headless mode (`claude -p`) which runs a prompt non-interactively and produces a session transcript (JSONL).

## Running a Test

```bash
# Run a prompt against the skill
claude -p "I want to build a REST API for a todo app" --output-format jsonl > session.jsonl

# Check that software-forge was invoked
grep -c "software-forge" session.jsonl
```

## What to Test

### Skill Triggering
Does the orchestrator activate when given a project description?

```bash
# Test: naive prompt triggers software-forge
echo "I want to build a macOS menu bar app" | claude -p --output-format jsonl > test-macos.jsonl
# Verify: should classify as macOS App, select 4 phases
```

### Phase Routing
Does the router select the correct phases per project type?

| Prompt | Expected Type | Expected Phase Count |
|--------|--------------|---------------------|
| "macOS menu bar weather app" | macOS App | 4 |
| "React dashboard" | Web Frontend | 5 |
| "SaaS with Supabase, Stripe, auth" | Full-Stack Web | 10 |
| "LiveKit voice ordering system" | Voice Agent | 11 |
| "Computer vision on Jetson Nano" | Edge/IoT+ML | 13 |

### Skill Invocation
Does each phase invoke the correct skill?

```bash
# Verify brainstorming was invoked at Phase 1
grep "brainstorming" test-fullstack.jsonl

# Verify ddia-design was invoked at Phase 3
grep "ddia-design" test-fullstack.jsonl
```

## Test Infrastructure

Tests live in `tests/`. Each test directory contains:
- `prompts/` — Input prompts
- `run-test.sh` — Test runner
- `run-all.sh` — Batch runner

## Future Work

- Token usage analysis per phase
- Regression tests for phase routing changes
- End-to-end project completion tests
