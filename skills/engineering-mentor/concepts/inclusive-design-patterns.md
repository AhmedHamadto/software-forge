# Inclusive Design Patterns (Heydon Pickering) — Teaching Content

## ARIA Patterns

### Deep (first exposure)

The first rule of ARIA is "don't use ARIA." Pickering opens with this apparent paradox to make a critical point: ARIA (Accessible Rich Internet Applications) is a repair technology. It exists to patch accessibility onto elements that lack native semantics. A `<button>` element already communicates its role, state, and behavior to assistive technology. Adding `role="button"` to a `<div>` gives you the role announcement but not the keyboard behavior (Enter and Space to activate), not the focus management, and not the implicit form submission. You end up reimplementing everything the `<button>` already does, and you usually get it wrong.

When ARIA is genuinely needed — for custom widgets that have no HTML equivalent — Pickering emphasizes three categories. Roles tell assistive technology what an element is: `role="tablist"`, `role="tab"`, `role="tabpanel"`. States tell it what condition the element is in: `aria-selected="true"`, `aria-expanded="false"`, `aria-disabled="true"`. Properties provide additional relationships: `aria-labelledby="heading-id"`, `aria-controls="panel-id"`, `aria-describedby="help-text"`. These three categories map to the three questions a screen reader user asks about any element: "What is this?" (role), "What state is it in?" (state), and "What is it connected to?" (property).

The most common ARIA mistake Pickering identifies is using ARIA to fix problems that HTML already solves. Developers add `aria-label` to a link instead of putting descriptive text in the link. They add `role="navigation"` to a `<div>` instead of using `<nav>`. They add `aria-required="true"` instead of the `required` attribute. Each ARIA attribute is a maintenance burden — it must be kept in sync with the visual state, it must be tested with actual screen readers (because browser/AT support varies), and it adds cognitive load to the code. Native HTML semantics are tested by browser vendors, updated automatically, and understood by all assistive technologies. Use ARIA only when HTML has no native element for what you are building.

### Refresher (subsequent exposure)

The first rule of ARIA: do not use ARIA when native HTML semantics suffice. ARIA has three categories — roles (what is it), states (what condition), and properties (what connections) — that answer screen reader users' questions. ARIA patches accessibility onto custom widgets; it does not replace native semantics. Every ARIA attribute is a maintenance burden that must be tested with actual assistive technology.

### Socratic Questions

- A developer has built a custom dropdown using `<div>` elements with `role="listbox"`, `role="option"`, `aria-selected`, and `aria-activedescendant`. What native HTML element provides all of this behavior for free, and what keyboard interactions is the developer likely missing in their custom implementation?
- Your component library has a `<Modal>` component. What ARIA roles and properties does it need that HTML cannot provide natively? What about `aria-modal`, focus trapping, and `aria-labelledby`?
- A code review shows `<a href="#" role="button" aria-label="Submit form" onclick="submitForm()">Submit</a>`. Identify everything wrong with this from an ARIA perspective and how to fix it.

---

## Keyboard Navigation

### Deep (first exposure)

Pickering states a fundamental accessibility requirement: every interactive element must be reachable and operable with a keyboard alone. This is not just for screen reader users — it serves users with motor disabilities who use switch devices, users with repetitive strain injuries who cannot use a mouse, and power users who prefer keyboard efficiency. Tab moves focus forward through interactive elements, Shift+Tab moves backward, Enter activates links and buttons, Space activates buttons and toggles, and arrow keys navigate within composite widgets (tabs, menus, radio groups).

Focus management is where most keyboard accessibility breaks. When a modal opens, focus must move to the modal. When it closes, focus must return to the element that triggered it. When an item is deleted from a list, focus must move to the next item (not jump to the top of the page). When a route changes in a single-page app, focus must move to the new content. Every time the DOM changes in a way that affects what the user was interacting with, you must answer the question: "Where should focus go now?" Getting this wrong does not just annoy keyboard users — it strands them. A keyboard user who cannot find the focus after a modal closes has to Tab through the entire page to get back to where they were.

Pickering introduces the roving tabindex pattern for composite widgets. In a tab bar with 5 tabs, only the active tab should be in the tab order (`tabindex="0"`). The other 4 should be removed from the tab order (`tabindex="-1"`). Arrow keys move between tabs, updating which one has `tabindex="0"`. This means a user Tabs into the tab bar (one stop), arrows to their desired tab, and Tabs out (one stop). Without roving tabindex, they would have to Tab through all 5 tabs to get past them, which is tedious in a tab bar and unusable in a menu with 50 items. The principle: Tab navigates between widgets, arrow keys navigate within widgets.

Skip links deserve special attention. A page with a navigation bar, sidebar, and main content forces keyboard users to Tab through every nav link and sidebar item to reach the main content. A skip link — typically the first focusable element on the page — jumps focus directly to the main content area. It is usually visually hidden until focused, so it appears only for keyboard users who need it. Without skip links, a keyboard user on a site with 30 navigation links must press Tab 30 times on every page load before reaching the content they came for.

### Refresher (subsequent exposure)

Every interactive element must be keyboard-reachable and operable. Tab moves between widgets, arrow keys navigate within them (roving tabindex pattern). Focus management is critical: when DOM changes (modals, deletions, route changes), explicitly manage where focus goes. Skip links let keyboard users bypass repetitive navigation to reach main content.

### Socratic Questions

- Your single-page app navigates between routes, but after navigation, focus stays on the link the user clicked in the nav bar. A keyboard user has to Tab through the entire navigation again to reach the new page content. How do you fix this, and where exactly should focus go?
- You have a data table with 100 rows, each with an "Edit" and "Delete" button. A keyboard user must press Tab 200 times to get past the table. How would you redesign the keyboard interaction to make the table navigable without exhausting the user?
- A user opens a confirmation dialog, confirms the action, and the dialog closes. The element that triggered the dialog has been removed from the DOM (it was a "Delete" button on an item that is now deleted). Where should focus go, and why is this a harder problem than the simple "return focus to trigger" pattern?
