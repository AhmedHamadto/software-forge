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

#### Subagent-Driven Path (current session)

After `/subagent-driven-development` and `/finishing-a-development-branch` complete:
1. Announce: "Phase 15 (Implementation) is complete."
2. Summarize what was built vs. the plan (deviations, additions, removals).
3. Proceed immediately to the next active phase in the compiled plan (typically Phase 16: Security Validation).

#### Parallel Session Path (`/executing-plans`)

If executing in a separate session with `/executing-plans`:
1. After `/finishing-a-development-branch` completes in the separate session, return to the ORIGINAL orchestrator session.
2. Tell the orchestrator: "Phase 15 is complete. All tasks implemented, tests passing, branch merged/PR created."
3. The orchestrator will resume from Phase 16.

⚠️ Do NOT skip this step. Phases 16-20 include security validation, observability setup, and polish review. Skipping them means shipping without security verification.
