# Phase 11: UX Design

**Applies to:** macOS, iOS, Web Frontend, Full-Stack Web
**Sources:**
- *Don't Make Me Think* (Steve Krug)
- *About Face* (Alan Cooper)
- *Inclusive Design Patterns* (Heydon Pickering)
**Output:** UX design section appended to design doc

### Questions to Ask

**Usability (Don't Make Me Think):**
1. What are the 3 most important things a user should be able to do? Can they find them in under 5 seconds?
2. Does the navigation pass the trunk test?
3. Where are users forced to think instead of act? Eliminate every unnecessary decision.
4. What are the happy paths? Are they effortless?
5. How many clicks/taps to complete each core task?

**Interaction Design (About Face):**
6. Who are the primary personas? What are their goals?
7. What interaction patterns does each core flow use? (Progressive disclosure, wizard, direct manipulation, inline editing, drag-and-drop)
8. How does the system prevent errors? (Constraints, defaults, undo, confirmation only for destructive actions)
9. What feedback does the system give for every user action?
10. What are the edge cases? (Empty states, error states, loading states, first-run experience)

**Accessibility (Inclusive Design Patterns):**
11. What semantic HTML elements map to your UI components?
12. Keyboard navigation: what's the tab order? Keyboard shortcuts for power users?
13. Screen reader strategy: ARIA roles, labels, heading hierarchy?
14. Color contrast: all combinations meet WCAG AA? (4.5:1 normal, 3:1 large)
15. Touch targets: at least 44x44pt (iOS) / 48x48dp (Android)?
16. Does the design work without color alone?

### Deliverable

```markdown
## UX Design

### Core Flows
- [Flow Name]: [Steps, click count, happy path]
- Personas: [Who, goals, context]

### Interaction Patterns
- [Pattern]: [Where used, why chosen]
- Error Prevention: [Strategy per flow]
- Feedback: [What users see/hear for each action]

### Edge States
- Empty: [What users see before content exists]
- Error: [How errors are presented and recovered from]
- Loading: [Skeleton, spinner, or progressive]
- First Run: [Onboarding strategy]

### Accessibility
- Semantic Structure: [HTML elements, heading hierarchy]
- Keyboard: [Tab order, shortcuts]
- Screen Reader: [ARIA roles, labels]
- Contrast: [Ratios verified]
- Touch Targets: [Minimum sizes]

### Decision Log — Phase 11: UX Design
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
