# Designing Interface Animation (Val Head) — Teaching Content

## Choreography

### Deep (first exposure)

When multiple elements animate simultaneously, the result is either choreography or chaos. Head dedicates significant attention to sequencing because the order in which elements appear, move, and disappear communicates hierarchy, relationships, and narrative. Without choreography, all elements animate at once, and the user's eye has nowhere to land. With choreography, each element has its moment, and the sequence tells a story.

Stagger sequences are the primary choreography tool. When a list of cards enters the viewport, they do not all appear at once. The first card appears, then the second 50ms later, then the third 50ms after that. This stagger creates a visual flow — the user's eye follows the cascade, naturally reading from first to last. The stagger direction communicates structure: top-to-bottom for vertical lists, left-to-right for timelines, center-outward for dashboards where the central metric matters most. Head emphasizes that stagger delays should be short (30-80ms between elements) and total sequences should not exceed 500ms. A 12-card grid with 80ms staggers takes 960ms to complete — that is too long. Either reduce the stagger (40ms = 480ms total) or cap the visible stagger at 5-6 elements and let the rest appear instantly.

Entrance and exit ordering follows a narrative principle: important elements enter first and exit last. The main content area should appear before the sidebar. The primary action button should appear before secondary actions. When exiting, the reverse: secondary elements leave first, clearing the stage for the primary element's departure. This is not arbitrary — it mirrors how a presenter works: the main point is established first, supporting points appear around it, and when transitioning, the supporting points are cleared before the main point changes.

### Refresher (subsequent exposure)

Choreography sequences multiple animations to communicate hierarchy and narrative. Stagger sequences (30-80ms between elements, total under 500ms) create visual flow. Stagger direction communicates structure. Important elements enter first and exit last. Without choreography, simultaneous animations create chaos — the user's eye has nowhere to land.

### Socratic Questions

- Your dashboard loads 4 metric cards, a chart, and a data table simultaneously. Everything fades in at once, and users say the page feels "overwhelming on load." How would you choreograph the entrance sequence, and what enters first?
- You have a stagger animation on a list of 30 items. At 60ms per item, the last item appears almost 2 seconds after the first. Users at the bottom of the list are staring at empty space. How do you fix this without removing the stagger?
- When navigating from a list view to a detail view, the list should exit and the detail should enter. Should these happen simultaneously, sequentially (list exits then detail enters), or overlapping? What factors influence this decision?

---

## Motion Narrative

### Deep (first exposure)

Head frames animation as storytelling. Every state change in an interface is a micro-story with a beginning, middle, and end. A file upload has a narrative: the file is selected (beginning), progress advances (middle), and the upload completes or fails (end). Animation makes this narrative visible. Without animation, the user sees three disconnected static states. With animation, they see a continuous story: the file appears in the upload zone, a progress bar fills, and the completed file settles into the file list. The transitions between states are the connective tissue that makes the narrative coherent.

The concept of spatial continuity is central to motion narrative. When a user taps a list item and it expands into a detail view, the animation should maintain the spatial relationship — the detail view grows from where the list item was. When the user navigates back, the detail view shrinks back to the list item's position. This is not just aesthetically pleasing; it preserves the user's spatial mental model. They know where they are because they watched themselves travel there. Without spatial continuity — if the detail view just appeared from nowhere and the list vanished — the user must rebuild their mental model of "where am I" every time they navigate. Material Design's container transform pattern is a canonical example of spatial continuity.

Perhaps Head's most valuable contribution is articulating when NOT to animate. Animation is harmful when it delays task completion for routine actions. An email client that plays a send animation every time you send an email is charming the first time and infuriating the hundredth. Animation is harmful during content consumption — when a user is reading an article, nothing on the page should be moving. It competes for attention with the content. And animation is harmful when it becomes a gate — when the user cannot proceed until the animation completes. The rule: if the user has to wait for your animation, it is too long or too blocking. Animation should enhance the experience, not hold it hostage.

### Refresher (subsequent exposure)

Animation tells micro-stories: beginning (trigger), middle (transition), end (resolution). Spatial continuity preserves mental models — elements should grow from where they were and return to where they came from. When NOT to animate: routine repeated actions (sending email), during content consumption (reading), and as a gate (blocking user action). Animation enhances experience; it should never hold it hostage.

### Socratic Questions

- A user clicks a "Create Project" button. A new project card should appear in the project list. How would you design the animation to tell the narrative of "this project was just created here" using spatial continuity?
- Your onboarding flow has 5 steps with elaborate transition animations between them. Users who have been through onboarding before (returning to change a setting) are frustrated by the animations. How do you maintain the narrative for first-time users while respecting returning users?
- A developer adds a 300ms animation to the "Save" button in a code editor. The editor auto-saves every 10 seconds. Why is this problematic, and how does Head's "when not to animate" framework apply?
