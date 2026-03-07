# Phase 20: Retrospective & Feedback Loop

**Applies to:** All project types
**Input:** Completed project — all implementation and validation phases done
**Output:** Retrospective section appended to design doc

### Purpose

Capture what happened during the build so future projects benefit. This is not a code review (that was Phase 19). This is a process review — what the skill got right, what it got wrong, and what the engineer learned.

### Retrospective Questions

1. **What went well?**
   - Which design decisions proved correct during implementation?
   - Which phases saved time or caught issues early?
   - What tooling or patterns worked better than expected?

2. **What was harder than expected?**
   - Where did the design not survive contact with implementation?
   - Which estimates (cost, complexity, timeline) were off?
   - What integration points caused friction?

3. **What would you do differently?**
   - Which design decisions would you change with hindsight?
   - Were any phases skipped that should have been included?
   - Were any phases included that added no value?

4. **What did you learn?**
   - New patterns or techniques discovered during the build
   - Concepts that clicked during implementation
   - Tools or libraries worth using again (or avoiding)

### Deliverable

```markdown
## Retrospective

### What Went Well
- [bullet points]

### What Was Harder Than Expected
- [bullet points]

### Design vs Reality
| Design Decision | What Actually Happened | Lesson |
|----------------|----------------------|--------|
| [decision] | [reality] | [takeaway] |

### Lessons for Future Projects
- [actionable insights]
```

### For Learn Mode (Engineering Mentor)

When running under the engineering-mentor wrapper, this phase feeds directly into the Growth Review. The retrospective answers inform which concepts the engineer applied successfully and which need more practice. The engineering-mentor skill handles the growth review separately — this phase just captures the raw retrospective data.
