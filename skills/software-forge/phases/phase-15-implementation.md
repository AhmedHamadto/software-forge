# Phase 15: Implementation

**Applies to:** All project types

### Pre-Implementation: Read the Plan

Before writing any code, re-read the implementation plan from `docs/plans/YYYY-MM-DD-<topic>-plan.md`. Context compaction after Phase 14 may have dropped design details from the conversation — the plan file on disk is the source of truth.

### Execution

Choose execution approach:
- **Subagent-driven** (current session): Invoke `/subagent-driven-development`
- **Parallel session** (separate): Invoke `/executing-plans` in a new session

### Post-Implementation: Return to Orchestrator

After the execution skill completes (all tasks done, `finishing-a-development-branch` handled), **return control to the orchestrator** to continue with the next active phase in the compiled plan (typically Phase 16: Security Validation).

Do NOT end the session here. Implementation is one phase — not the last phase. Check the compiled phase plan and proceed to whatever comes next.
