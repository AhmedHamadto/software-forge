# Every Layout (Andy Bell & Heydon Pickering) — Teaching Content

## Intrinsic Design

### Deep (first exposure)

Most CSS layout approaches fight the web's fundamental nature. The web is a fluid medium — viewports come in every size, content varies in length, and users control their own font sizes. Yet developers reach for fixed breakpoints and pixel-perfect designs, writing media queries that assume a finite set of screen widths. Bell and Pickering argue this is backwards. Instead of the developer dictating when layout should change, the content and available space should dictate it. This is intrinsic design: layout that responds to its own context rather than to arbitrary breakpoints.

The practical tools are CSS functions like `min()`, `max()`, and `clamp()`. Instead of writing `width: 800px` with a media query that changes it to `width: 100%` below 768px, you write `width: min(800px, 100%)`. The element is 800px when space allows and 100% when it does not — no breakpoint needed. `clamp()` takes this further: `font-size: clamp(1rem, 2.5vw, 2rem)` creates fluid typography that scales with the viewport but never goes below 1rem or above 2rem. The browser does the responsive work for you, and the result is smoother than jumping between discrete sizes at breakpoints.

Intrinsic design also means sizing elements based on their content rather than on a grid imposed from outside. A sidebar does not need to be "300px wide" — it needs to be "wide enough for its content, but no wider than 30% of the container." The `fit-content`, `min-content`, and `max-content` keywords let elements negotiate their own size. When you stop prescribing sizes and start describing constraints, layouts become more robust. They handle edge cases — long words, missing images, translated text that is 40% longer — because the rules are about relationships, not measurements.

### Refresher (subsequent exposure)

Intrinsic design uses CSS functions (`min()`, `max()`, `clamp()`) and content-based sizing (`fit-content`, `min-content`, `max-content`) to let layout respond to available space and content rather than arbitrary breakpoints. Instead of prescribing sizes, describe constraints and let the browser negotiate.

### Socratic Questions

- You have a card component with a title, image, and description. The title length varies from 3 words to 20 words across different locales. How would intrinsic sizing handle this compared to a fixed-height card?
- A designer gives you a mockup at exactly 1440px. How would you implement the layout so it works at any viewport width without media queries?

---

## Composition Patterns

### Deep (first exposure)

Bell and Pickering identify a small set of layout primitives that, when composed together, can build virtually any interface: Stack, Sidebar, Cluster, Switcher, Cover, and Grid. Each primitive solves exactly one layout problem. A Stack adds consistent vertical spacing between its children. A Sidebar places a side element next to a main content area, wrapping when space is insufficient. A Cluster distributes items horizontally with wrapping (think tag lists or button groups). A Switcher flips between horizontal and vertical layout at a threshold. A Cover vertically centers a principal element with optional header and footer. A Grid creates responsive grids where columns appear and disappear based on a minimum width.

The power comes from composition, not complexity. Each primitive is typically 3-5 lines of CSS. A page layout might be a Cover (for the hero) containing a Stack (for vertical sections), each section containing a Sidebar (for content + aside), where the content area contains a Grid (for cards). Each primitive knows nothing about its siblings or parents — it only manages its own children's arrangement. This composability mirrors how React components nest, but at the CSS level.

The key insight is that these primitives use intrinsic thresholds rather than breakpoints. The Sidebar does not wrap at "768px viewport width" — it wraps when the main content area would be squeezed below a minimum width. The Grid does not switch from 3 columns to 2 at "1024px" — it creates as many columns as fit at a minimum width. This means the same component works in a full-width layout, inside a sidebar, or in a modal, without any modification. The layout primitives are context-agnostic, which is the whole point: they respond to their container, not to the viewport.

### Refresher (subsequent exposure)

Every Layout defines composable layout primitives — Stack, Sidebar, Cluster, Switcher, Cover, Grid — each solving one layout problem in 3-5 lines of CSS. Primitives nest inside each other to build complex layouts. They use intrinsic thresholds (container-based) rather than viewport breakpoints, making them context-agnostic and reusable anywhere.

### Socratic Questions

- You need a layout where a sidebar sits next to main content on wide screens and stacks below it on narrow screens. This same layout appears both at full page width and inside a modal. How do Every Layout's primitives handle both contexts without modification?
- You are building a tag list that should wrap naturally when tags exceed the available width, with consistent gaps. Which primitive applies, and how does it differ from using `display: flex; flex-wrap: wrap` with manual gap calculations?
- A junior developer has written 15 different responsive layout components, each with its own set of media queries. How would you refactor them using composition of layout primitives?
