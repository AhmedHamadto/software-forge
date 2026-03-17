# Phase 19: Polish & Review

**Applies to:** All project types

Route to the appropriate review skill(s):

| Project Type | Review Skills |
|-------------|--------------|
| macOS App | `/design-code-review` + `/apple-craftsman` (review mode) |
| iOS Mobile App | `/mobile-ios-design` (review mode) + `/ux-usability-review` |
| Web Frontend | `/ui-polish-review` + `/ux-usability-review` |
| Full-Stack Web | `/ui-polish-review` + `/ux-usability-review` |
| Voice Agent | `/ux-usability-review` (conversational flow review) |
| Edge/IoT + ML | `/ui-polish-review` (webapp) + `/ux-usability-review` (webapp) |

After review skills complete, invoke `/code-simplifier` on the full codebase.

### Additional Tool Integration (if available)

After running the primary review skills above, check for:

1. **Design Motion Principles skill?**
   - Run three-lens motion audit on the final codebase
2. **Motion AI Kit?**
   - Run /motion-audit for performance classification
3. **Context7 MCP?**
   - Verify any library-specific patterns against current docs
   (not training-data-stale docs)

These are additive — they enhance the review, they don't replace it.

### Developer Guard Integration

If developer-guard is installed, invoke its repo-scan and legal-audit skills here. If not, continue with built-in security validation.

### Deliverable

After all review skills complete, produce a review summary appended to the design doc:

```markdown
## Polish & Review Summary

### Reviews Completed
| Review Skill | Findings | Fixed | Deferred |
|-------------|----------|-------|----------|
| [skill name] | [count] | [count] | [count] |

### Key Changes Made
- [Change 1]: [What was fixed and why]
- [Change 2]: [What was fixed and why]

### Deferred Items
- [Item]: [Why deferred, when to address]

### Decision Log — Phase 19: Polish & Review
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Accepted:** [Finding left as-is] — [why it's acceptable].
- **Deferred:** [Finding] — [why deferred, when to revisit].
```
