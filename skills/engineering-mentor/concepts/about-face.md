# About Face (Alan Cooper) — Teaching Content

## Goal-Directed Design

### Deep (first exposure)

Cooper makes a distinction that sounds simple but changes how you design: users have goals, not tasks. Tasks are what people do to achieve goals, and tasks change as tools improve. The goal of "communicate with my team" has been achieved through memos, emails, chat, and video calls — the task changed every decade, but the goal remained constant. If you design for the task ("make email faster"), you optimize a potentially obsolete solution. If you design for the goal ("make team communication effortless"), you might discover that email is not the right task at all.

Personas are Cooper's tool for keeping design goal-oriented. But Cooper's personas are not the marketing demographics that the term often degenerates into. A marketing persona says "Sarah, 34, lives in Brooklyn, earns $85K, likes yoga." Cooper's persona says "Sarah needs to review 20 expense reports before her 3pm meeting. Her goal is to approve legitimate expenses quickly without missing fraud. She is interrupted every 10 minutes by Slack messages." The persona captures context, goals, and constraints — the things that actually drive design decisions. The useful question is never "what would a 34-year-old want?" but always "what would someone with these goals and constraints need?"

Cooper identifies three levels of goals. Activity goals are immediate: "find expenses over $500." End goals are why the activity matters: "ensure compliant spending." Life goals are the underlying motivation: "be seen as a competent manager." Good design satisfies all three levels. A system that lets Sarah find over-$500 expenses (activity goal) but makes the process so tedious that it takes 3 hours (undermining her end goal of efficiency) has failed, even though the feature works. A system that makes expense review fast and satisfying supports both her end goal and her life goal of competence.

### Refresher (subsequent exposure)

Goal-directed design focuses on user goals (why) rather than tasks (what). Cooper's personas capture context, goals, and constraints — not demographics. Three goal levels matter: activity goals (immediate), end goals (purpose), and life goals (motivation). Design must satisfy all three, or the feature works technically but fails practically.

### Socratic Questions

- You are designing a dashboard for warehouse managers. Marketing describes the persona as "Mike, 45, manages a team of 12, tech-savvy." How would you rewrite this as a Cooper-style persona that actually drives design decisions?
- A product manager asks for a feature to "let users export reports to CSV." What goal-directed questions would you ask before designing this feature? What might you discover about the actual goal?
- Your expense approval app has a 98% task completion rate but a low NPS score. Users successfully approve expenses but describe the experience as "painful." Which of Cooper's goal levels is being satisfied, and which is being violated?

---

## Interaction Patterns

### Deep (first exposure)

Cooper identifies a toolkit of interaction patterns that map to different cognitive situations users face. The most important pattern is progressive disclosure: showing only what is needed at each step, revealing complexity as the user asks for it. A form with 30 fields is overwhelming; the same form split into 5 steps of 6 fields each is manageable. But progressive disclosure is not just about hiding fields — it is about matching the information architecture to the user's mental model. The user thinks in stages (what, where, when, how to pay), not in database tables.

Direct manipulation means the user acts on the object itself rather than through an intermediary. Dragging a file to the trash is direct manipulation; selecting a file and clicking "Delete" is indirect. Cooper argues that direct manipulation reduces cognitive distance — the gap between the user's intention and the system's response. When you drag an appointment to a new time slot in a calendar, the mental model (moving the event) matches the physical action (moving the element). When you type a time into a form field, there is a translation step: the user must convert their spatial intuition ("later in the day") into a numeric format ("15:30").

Error prevention is more important than error handling. Cooper's hierarchy: first, make the error impossible (disable the submit button until the form is valid). Second, make the error difficult (default to safe values, use constrained inputs like dropdowns instead of free text). Third, make recovery easy (undo instead of confirmation dialogs). Confirmation dialogs are Cooper's pet peeve — they train users to click "OK" without reading, which means they provide no actual protection. Undo is strictly superior: it requires no decision before the action and allows recovery after.

### Refresher (subsequent exposure)

Key interaction patterns: progressive disclosure (reveal complexity as needed), direct manipulation (act on the object itself to reduce cognitive distance), and error prevention over error handling. Cooper's hierarchy: make errors impossible, then difficult, then recoverable. Undo beats confirmation dialogs because confirmations train mindless clicking.

### Socratic Questions

- Your settings page has 45 options organized in a single scrollable list. Users report feeling overwhelmed. How would you apply progressive disclosure without hiding important settings?
- You have a "delete account" button that shows a confirmation dialog. Users occasionally delete their accounts accidentally despite the dialog. What does Cooper's error prevention hierarchy suggest as a better approach?
- You are designing a scheduling interface where users need to block out time ranges. Compare a form-based approach (start time input, end time input, submit) versus a direct manipulation approach (click and drag on a timeline). What cognitive advantages does direct manipulation offer, and when might the form approach be better?
