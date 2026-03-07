# The Illusion of Life (Frank Thomas & Ollie Johnston) — Teaching Content

## The 12 Principles

### Deep (first exposure)

Disney's twelve principles of animation were developed to make drawn characters feel alive. Thomas and Johnston codified them in 1981, but their relevance to UI design is profound because they describe how humans perceive movement. These are not arbitrary aesthetic rules — they encode how objects behave in the physical world, and when digital interfaces follow these principles, they feel natural rather than mechanical.

Not all twelve principles apply equally to UI. The most relevant are: **Anticipation** — before a major action, telegraph it. A button that scales down slightly on press, before launching its action, tells the user "something is about to happen." Without anticipation, actions feel abrupt. **Follow-through and overlapping action** — after movement ends, elements should settle. A panel that slides in and then slightly overshoots its target before settling back feels physical. One that stops dead feels robotic. **Slow in and slow out** (easing) — objects accelerate and decelerate rather than moving at constant speed. An ease-out curve on entrance makes an element arrive quickly and settle gently. An ease-in on exit makes it accelerate away. Linear motion feels uncanny because nothing in the physical world moves at constant velocity. **Timing** — duration determines whether an animation feels responsive or sluggish. Micro-interactions (button press, toggle) should be 100-200ms. Transitions (page change, panel slide) should be 200-500ms. Anything over 700ms feels like lag, not animation. **Secondary action** — when a primary element moves, supporting elements should respond. When a card expands, surrounding cards should shift to accommodate it. When a notification appears, the content below it should push down. Without secondary action, elements feel disconnected from each other.

Equally important is knowing which principles to restrain. **Squash and stretch** works for playful interfaces but feels wrong in a banking app. **Exaggeration** is useful for empty states and onboarding but distracting during routine workflows. **Staging** (directing attention) is always relevant, but **appeal** (character design) rarely applies to UI. The discipline is in choosing which principles serve the interface and which would merely decorate it.

### Refresher (subsequent exposure)

Disney's 12 principles encode how humans perceive natural movement. Most relevant to UI: anticipation (telegraph before acting), follow-through (settle after movement), easing (accelerate/decelerate naturally), timing (100-200ms micro, 200-500ms transitions, never over 700ms), and secondary action (surrounding elements respond). Restraint matters — not every principle belongs in every interface.

### Socratic Questions

- You are building a todo app. A user checks off a task, and it should move to the "completed" section. Which of the 12 principles apply to this transition, and which would be over-the-top for such a routine interaction?
- Your modal slides in from the bottom and stops at its final position instantly. Users describe it as feeling "janky." Which principles are you violating, and what CSS changes would fix it?
- A designer wants every element on the page to bounce when it appears. The interface is a medical records system used by doctors 8 hours a day. How do you push back using the 12 principles themselves as your argument?

---

## Timing & Easing

### Deep (first exposure)

Thomas and Johnston devote extensive attention to timing because it is the single most important factor in whether animation feels right. The same movement at different durations communicates entirely different things. A 100ms fade says "this is instantaneous, barely worth animating." A 300ms slide says "notice this transition, it is meaningful." A 1000ms animation says "watch this elaborate reveal." Choosing the wrong duration is worse than not animating at all — a 500ms toggle on a switch makes the interface feel broken, while a 500ms page transition feels deliberate.

Easing curves control acceleration, and they carry meaning. An **ease-out** curve (fast start, gentle arrival) is the default for entrances — elements should arrive confidently and settle. An **ease-in** curve (gentle start, fast exit) is for exits — elements should accelerate away, leaving attention on what remains. An **ease-in-out** (gentle start, fast middle, gentle end) is for elements repositioning within the viewport — they detach gently, move quickly, and arrive gently. A **linear** curve has almost no valid use in UI — it feels mechanical and unnatural. The exception is progress indicators and loading bars, where constant velocity communicates steady progress.

Frame rate perception adds a constraint. Animation must maintain 60fps (16.67ms per frame) to appear smooth. This means animation calculations must complete within the frame budget. Transform and opacity changes are GPU-composited and hit the budget easily. Layout-triggering properties (width, height, top, left, padding, margin) cause the browser to recalculate layout for every frame, which is expensive and causes jank. The practical rule: animate only `transform` and `opacity`. If you need to animate size, use `scale()` on a transformed layer rather than animating `width`. If you need to animate position, use `translate()` rather than animating `top` or `left`. This constraint is non-negotiable for maintaining perceived quality.

### Refresher (subsequent exposure)

Duration communicates intent: 100-200ms for micro-interactions, 200-500ms for transitions, never over 700ms. Easing curves carry meaning: ease-out for entrances, ease-in for exits, ease-in-out for repositioning, linear almost never. Animate only `transform` and `opacity` to maintain 60fps — layout-triggering properties cause jank. Frame budget is 16.67ms per frame; GPU-composited properties hit it easily.

### Socratic Questions

- Your dropdown menu opens with a 400ms ease-in-out animation. Users report it feels "slow." What is wrong with both the duration and the easing choice, and what would you change?
- A developer animates a sidebar expanding by transitioning its `width` from `0` to `300px`. On mobile devices, the animation stutters. What is causing the performance problem, and how would you achieve the same visual effect using GPU-composited properties?
- You have two animations: a button ripple effect and a full-screen page transition. Should they use the same duration and easing? Why or why not?
