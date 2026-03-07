# Phase 14: Implementation Planning

**Applies to:** All project types
**Invoke:** `/writing-plans`
**Input:** All design docs produced in prior phases

### Testing Strategy Addition

When creating the implementation plan, ensure each task specifies which level of the testing pyramid it targets:

| Level | What It Tests | When to Use |
|-------|--------------|-------------|
| Unit | Single function/component in isolation | Every task (TDD) |
| Integration | Two+ components together, real dependencies | API endpoints, DB queries, service integrations |
| Contract | API shape matches between producer/consumer | Cross-service boundaries, webhook contracts, device protocols |
| End-to-End | Full user flow through the system | Critical paths only (login, core transaction, detection pipeline) |
| Load | Performance under expected/peak traffic | After core features are built |

**Source:** *Growing Object-Oriented Software, Guided by Tests* (Freeman & Pryce)

**Output:** Implementation plan at `docs/plans/YYYY-MM-DD-<topic>-plan.md`
