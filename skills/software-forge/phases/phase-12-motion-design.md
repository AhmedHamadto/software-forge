# Phase 12: Motion Design

**Applies to:** Conditional — any project with meaningful state transitions or interactions
**Sub-classification question:** "Does your project have state transitions, loading sequences, or interactions that would benefit from motion design?"
**Sources:**
- *The Illusion of Life* (Frank Thomas & Ollie Johnston)
- *Animation at Work* (Rachel Nabors)
- *Designing Interface Animation* (Val Head)
**Output:** Motion design section appended to design doc

### Tool Integration (if available)

Before starting the question-based motion design process, check for available tools:

1. **Design Motion Principles skill installed?**
   (check ~/.claude/skills/design-motion-principles/)
   - If yes: Run the three-lens audit (Emil Kowalski, Jakub Krehel,
     Jhey Tompkins) on the existing codebase first to identify
     animation gaps and existing patterns.
   - Use the audit output to pre-populate the State Transitions
     and Choreography sections below.

2. **Motion AI Kit / Motion MCP available?**
   - If yes: Run /motion-audit to classify existing animations
     by render pipeline cost (S-tier to F-tier).
   - Use the audit to inform the Performance section.

3. **Neither available?**
   - Continue with the question-based approach below. The book-
     grounded questions produce excellent motion design specs
     without any tooling.

### Questions to Ask

**Animation Principles (The Illusion of Life):**
1. Which of the 12 principles apply to this interface?
   - Squash & Stretch: do interactive elements deform on press/release?
   - Anticipation: do elements telegraph what's about to happen?
   - Follow-Through: do elements settle naturally after movement?
   - Slow In / Slow Out: what easing curves feel right?
   - Timing: what durations feel responsive vs sluggish? (100-200ms micro, 200-500ms transitions, never over 700ms)
   - Secondary Action: do supporting elements react when the primary moves?
2. Which principles should NOT apply? (Restraint is a principle too)

**UI Animation Patterns (Animation at Work):**
3. What are the state transitions? Map each: [State A] -> [State B], what changes, continuous or discrete?
4. Loading states: skeleton screens, progress indicators, optimistic UI, or staggered reveal?
5. What's meaningful vs decorative? Every animation must be meaningful OR removable without losing comprehension.
6. Performance budget: 60fps target, transform/opacity only on composited layers?

**Choreography (Designing Interface Animation):**
7. What's the stagger sequence for multiple elements? (top-down, center-out, by importance)
8. How do transitions maintain spatial continuity?
9. What's the motion narrative? (loading -> processing -> success)
10. When should you NOT animate? (Repeated actions, during content focus, when it delays task completion)

**Reduced Motion:**
11. Does every animation respect `prefers-reduced-motion`?
12. What's the reduced-motion fallback? (instant cut, opacity fade, static)
13. Motion-dependent interactions with non-motion alternatives?

### Deliverable

```markdown
## Motion Design

### Principles Applied
- [Principle]: [Where and how used]
- Easing: [Default curves for enter/exit/reposition]
- Timing: [Duration ranges by interaction type]

### State Transitions
| From | To | Animation | Duration | Easing |
|------|-----|-----------|----------|--------|
| [State] | [State] | [What changes] | [ms] | [curve] |

### Choreography
- Entry Sequence: [Stagger strategy]
- Spatial Continuity: [How elements maintain context]
- Narrative: [Micro-stories if any]

### Performance
- GPU-composited: [Which animations]
- Layout-triggering: [Which to avoid or optimize]
- Frame Budget: [Target fps]

### Reduced Motion
- Fallback Strategy: [What happens with prefers-reduced-motion]
- Motion-Dependent Alternatives: [Non-motion equivalents]

### Decision Log — Phase 12: Motion Design
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
