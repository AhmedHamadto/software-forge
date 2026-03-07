# Don't Make Me Think (Steve Krug) — Teaching Content

## Cognitive Load

### Deep (first exposure)

Krug's first law of usability is right there in the title: don't make the user think. Every time a user has to pause and figure out whether something is a link, wonder what a label means, or decide between two equally plausible navigation options, they are spending cognitive effort on the interface instead of on their task. Chapters 1 through 6 build the case that the primary job of a designer or developer is to eliminate unnecessary decisions. Users do not read pages — they scan them. They do not make optimal choices — they satisfice, clicking the first reasonable option rather than evaluating all options. Designing for how users actually behave, rather than how you wish they behaved, is the core of the book.

Obvious navigation means that a user should be able to answer three questions at any moment: Where am I? What are the major sections of this site? What are my options at this level? Krug introduces the "trunk test": if you were dropped on any page of the application with no context (like being left on a random street), could you immediately identify the site name, the page name, the major sections, your local navigation options, and a search box? If any of those are missing or ambiguous, the user has to think. Visual hierarchy serves scanning: headings, bold text, bullet points, and whitespace let users pick out the information they need without reading every word. A wall of unstyled text is not just ugly — it is unusable, because it forces the user to read linearly when they want to scan selectively.

Eliminating unnecessary decisions is about reducing the number of choices and making the remaining ones obvious. Every dropdown, toggle, configuration option, and modal confirmation is a micro-decision that costs the user attention. Krug argues that the happy path — the most common thing the user wants to do — must be effortless. If 90% of users want to do X, then X should require zero decisions. The remaining 10% of use cases can be accessible but should not clutter the primary path. Consider a file upload flow: the happy path is "click upload, select file, done." If the interface asks the user to choose a file type, a destination folder, permissions, and a description before they can upload, you have turned a one-step task into a five-step task for every user, to serve edge cases that most users never encounter.

The consequence of ignoring cognitive load is not that users complain — it is that they leave, make errors, or avoid features entirely. Krug emphasizes that users blame themselves when interfaces are confusing ("I must be doing something wrong"), which means you will never hear about most usability failures. The fix is not user education or better documentation — it is removing the confusion at the source. Every question mark that appears over a user's head is a failure of design, not a failure of the user.

### Refresher (subsequent exposure)

Users scan rather than read, satisfice rather than optimize, and blame themselves when confused. Eliminate unnecessary decisions, make navigation obvious (the trunk test: can you identify where you are and what your options are from any page?), use visual hierarchy to support scanning, and ensure the happy path requires zero thinking.

### Socratic Questions

- Your application's settings page has 40 options organized in a single scrollable list. Users frequently contact support asking how to change their notification preferences, which is the 28th option on the page. Applying Krug's principles, how would you restructure this page to reduce cognitive load without removing any functionality?
- You are designing a checkout flow. At the payment step, users must choose between "Pay with saved card," "Add new card," "PayPal," "Apple Pay," and "Bank transfer." Analytics show that 85% of returning users pay with their saved card. How would you design this step so the happy path is effortless while still supporting the other options?
- A developer adds a confirmation dialog that asks "Are you sure?" every time a user saves a form. Their reasoning is that it prevents accidental saves. Using Krug's framework, why does this "safety" feature actually make the experience worse, and what alternative would you suggest for genuinely destructive actions?
