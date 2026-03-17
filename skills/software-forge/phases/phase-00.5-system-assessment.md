# Phase 0.5: Existing System Assessment

**Applies to:** All project types, **only when adding to an existing project** (skip for greenfield)
**Output:** System assessment section prepended to design doc

### Purpose

Before brainstorming new features, understand what already exists. Designing without mapping the current system produces plans that conflict with existing architecture, duplicate existing capabilities, or ignore existing tech debt.

### Process

1. **Map the current architecture:**
   - Read README, docs/, and any existing design docs
   - Identify the tech stack, key dependencies, and deployment model
   - Map the data model (schemas, migrations, key entities)
   - Identify the main entry points and request flows

2. **Identify constraints and boundaries:**
   - What patterns and conventions does the codebase follow?
   - What are the existing API contracts that must not break?
   - What tech debt or known issues exist? (check issues, TODOs, CHANGELOG)
   - What dependencies are pinned or constrained?

3. **Assess the test and CI situation:**
   - What test coverage exists? What's tested vs untested?
   - What CI/CD pipeline exists? What checks run on PR?
   - How are deployments done today?

4. **Summarize the integration surface:**
   - What external services are already integrated?
   - What internal APIs exist that the new feature could reuse?
   - Where are the seams — natural places to extend without rewriting?

### Deliverable

```markdown
## Existing System Assessment

### Architecture Summary
- Stack: [Languages, frameworks, infrastructure]
- Key Components: [List with one-line descriptions]
- Data Model: [Key entities and relationships]

### Constraints
- Must Not Break: [Existing APIs, contracts, behaviors]
- Tech Debt: [Known issues that affect the new work]
- Conventions: [Patterns the new code must follow]

### Integration Surface
- Reusable: [Existing APIs/components the new feature can leverage]
- Seams: [Natural extension points]

### Test & CI Status
- Coverage: [What's tested, what's not]
- Pipeline: [What runs on PR/merge/deploy]

### Decision Log — Phase 0.5: System Assessment
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
