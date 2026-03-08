# Phase 10: UI Design

**Applies to:** macOS, iOS, Web Frontend, Full-Stack Web
**Sources:**
- *Refactoring UI* (Wathan & Schoger)
- *Every Layout* (Andy Bell & Heydon Pickering)
- *Design Systems* (Alla Kholmatova)
**Output:** UI design section appended to design doc

### Tool Integration (if available)

Before starting the question-based design process, check for available tools:

1. **Figma MCP connected?** (check via /mcp)
   - If yes: "Paste a link to your existing Figma file. I'll pull the
     current design tokens (colors, spacing, typography, components)
     and use them as the starting point for this phase."
   - Use the extracted tokens to pre-fill the Visual Hierarchy and
     Design System sections below, then validate with the user.

2. **No design tool available?**
   - Continue with the question-based approach below. This works
     perfectly — the questions are designed to extract the same
     information through dialogue.

### Questions to Ask

**Visual Hierarchy (Refactoring UI):**
1. What are the primary, secondary, and tertiary actions on each screen?
2. How will size, weight, and color establish importance?
3. What spacing scale creates visual grouping? (4px/8px base?)
4. Typography: how many font sizes? What's the scale ratio?
5. Color: what's the palette? Which colors carry meaning vs decoration?

**Layout (Every Layout):**
6. What layout primitives does this project need? (Stack, Sidebar, Cluster, Grid, Cover, Switcher)
7. Where can intrinsic sizing replace fixed breakpoints?
8. What's the content-width measure for readability? (45-75 characters)
9. How does the layout compose — which primitives nest inside which?

**Design System (Design Systems):**
10. Does this project need a design system, or is it too small?
11. If yes: what are the design tokens? (colors, spacing, typography, radii, shadows)
12. Component naming convention? (semantic vs presentational)
13. Component API design — what props are configurable vs fixed?
14. How are variants handled? (size, state, theme)

### Deliverable

```markdown
## UI Design

### Visual Hierarchy
- Primary Actions: [what stands out most]
- Typography Scale: [sizes and weights]
- Color System: [palette with semantic meanings]
- Spacing Scale: [base unit and multipliers]

### Layout Strategy
- Primitives: [Stack, Sidebar, Grid, etc.]
- Breakpoint Strategy: [intrinsic vs fixed]
- Content Measure: [character width]

### Design System
- Tokens: [list]
- Components: [list with variants]
- Naming: [convention]

### Decision Log — Phase 10: UI Design
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
