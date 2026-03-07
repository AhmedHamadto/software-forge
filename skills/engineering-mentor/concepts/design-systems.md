# Design Systems (Alla Kholmatova) — Teaching Content

## Design Tokens

### Deep (first exposure)

A design token is a named value that represents a design decision. Instead of scattering `#3B82F6` throughout your codebase, you define a token `color-primary` with that value. But Kholmatova's insight goes deeper than simple variable naming. She describes a tiered token architecture that separates intent from implementation. Global tokens are raw values: `blue-500: #3B82F6`, `spacing-4: 16px`. Alias tokens map intent to global tokens: `color-action: blue-500`, `spacing-component-gap: spacing-4`. Component tokens map component concerns to alias tokens: `button-background: color-action`, `card-padding: spacing-component-gap`. Each tier adds meaning without adding complexity.

This layering matters because design decisions change at different rates. When the brand color changes, you update one global token. When "primary action" should be a different shade, you update one alias token. When buttons specifically need different padding, you update one component token. Without tiers, a brand color change means finding every instance of `#3B82F6` across hundreds of files — and discovering that some instances were the brand color but others just happened to be the same shade of blue for unrelated reasons. Tokens with semantic names make intent explicit: `color-action` versus `color-info` use the same blue today but can diverge tomorrow.

Naming conventions matter enormously. Kholmatova advocates for functional names over descriptive ones: `color-danger` not `color-red`, `spacing-tight` not `spacing-4px`, `font-heading` not `font-bold-24`. Functional names survive redesigns. If you rename your "red" danger color to orange, `color-danger` still makes sense but `color-red` becomes a lie. The naming convention is the API of your design system — inconsistent naming creates the same problems as inconsistent API naming in code.

### Refresher (subsequent exposure)

Design tokens are named values representing design decisions, organized in tiers: global (raw values), alias (semantic intent), and component (specific usage). Functional naming (`color-danger` not `color-red`) survives redesigns and makes intent explicit. Tokens are the API of your design system — naming consistency matters as much as in code APIs.

### Socratic Questions

- Your codebase uses `color-blue-500` for both primary buttons and informational badges. A rebrand changes the primary color to purple but informational elements should stay blue. How does a token tier system handle this, and what would break without it?
- A new developer adds a component and uses `spacing-16` everywhere. Another developer uses `spacing-component-gap` for the same purpose. Both resolve to `16px`. Why is this a problem, and how would you enforce consistency?

---

## Component API Design

### Deep (first exposure)

Kholmatova frames components as having an API — a set of props, variants, and composition rules that define how the component can be used. Just like a function signature, a component API communicates intent, constrains usage, and makes incorrect usage difficult. A well-designed component API has the property that it is hard to misuse. A poorly designed one accepts so many props and configurations that developers constantly use it wrong, and the component gradually accumulates workarounds for edge cases it was never meant to handle.

The central tension is between composition and configuration. A configuration-heavy component exposes many props: `<Button size="sm" variant="primary" icon="check" iconPosition="left" loading disabled rounded fullWidth />`. Every combination of props must be designed, tested, and maintained. With 7 boolean/enum props, the theoretical state space is enormous, and many combinations are invalid (a button cannot be both `loading` and `disabled` in the same way, a `fullWidth` button with `iconPosition="left"` looks wrong). A composition-based approach keeps the component focused: `<Button variant="primary" size="sm"><Icon name="check" /> Save</Button>`. The button handles button concerns (variant, size, state), the icon handles icon concerns, and the developer composes them. New requirements — like adding a badge to a button — do not require adding a `badge` prop to Button; you compose `<Button>` with `<Badge>`.

Kholmatova identifies a practical heuristic: if a prop only makes sense in combination with another prop, the abstraction is wrong. `iconPosition` only makes sense when `icon` is set. This is a code smell — it means the component is doing too much. Extract the icon concern into a composable child, and `iconPosition` disappears because the developer controls position through composition (putting `<Icon>` before or after the text content).

### Refresher (subsequent exposure)

Component APIs should constrain usage and make misuse difficult. Prefer composition over configuration: instead of adding props for every variation, keep components focused and let developers compose them. If a prop only makes sense in combination with another prop, the abstraction is doing too much — extract the concern into a composable child.

### Socratic Questions

- Your `<Card>` component has accumulated 12 props: `title`, `subtitle`, `image`, `imagePosition`, `footer`, `footerAlign`, `bordered`, `elevated`, `onClick`, `href`, `badge`, and `badgePosition`. Several props conflict (e.g., `onClick` and `href`). How would you redesign this using composition?
- A designer requests a new button variant that combines an icon, a label, and a notification dot. The current `<Button>` component has no `notificationDot` prop. Should you add one, or is there a better approach?
- Your team debates whether to use a single `<Input>` component with a `type` prop for text, number, date, and textarea, or separate `<TextInput>`, `<NumberInput>`, `<DateInput>`, and `<TextArea>` components. What are the trade-offs, and what does Kholmatova's composition principle suggest?
