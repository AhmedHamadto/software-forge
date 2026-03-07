# Engineer Profile Schema

This document defines the data model for `~/.claude/engineer-profile/profile.md`, which the Engineering Mentor skill creates on first run and maintains across sessions.

---

## Profile Template

The profile is a Markdown file with the following sections, written in order. When the skill creates a new profile, it populates each section from the onboarding interview.

```markdown
# Engineer Profile

Created: <ISO-8601 date>
Last Updated: <ISO-8601 date>

---

## Identity

- **Name:** <string>
- **Experience Level:** <A | B | C | D>
  - A = Student / early-career (0-2 years)
  - B = Mid-level (2-5 years)
  - C = Senior (5-10 years)
  - D = Staff+ (10+ years)
- **Primary Language(s):** <comma-separated list>
- **Current Focus Area:** <free text — e.g., "backend services in Go", "full-stack React/Node">
- **Goals:** <free text — what the engineer wants to improve>

---

## Competency Heat Map

| # | Book | Concept Area | Confidence | Last Touched | Evidence Count |
|---|------|-------------|------------|--------------|----------------|
| 1 | DDD (Evans) | Bounded Contexts | <level> | <date> | <n> |
| 2 | DDD (Evans) | Aggregates | <level> | <date> | <n> |
| 3 | DDIA (Kleppmann) | Data Modeling | <level> | <date> | <n> |
| 4 | DDIA (Kleppmann) | Replication | <level> | <date> | <n> |
| 5 | Release It! (Nygard) | Circuit Breakers | <level> | <date> | <n> |
| 6 | Release It! (Nygard) | Bulkheads | <level> | <date> | <n> |
| 7 | Release It! (Nygard) | Timeouts | <level> | <date> | <n> |
| 8 | Designing ML Systems (Huyen) | Data Pipelines | <level> | <date> | <n> |
| 9 | Designing ML Systems (Huyen) | Model Lifecycle | <level> | <date> | <n> |
| 10 | Infrastructure as Code (Morris) | IaC Patterns | <level> | <date> | <n> |
| 11 | GOOS (Freeman & Pryce) | TDD Red-Green-Refactor | <level> | <date> | <n> |
| 12 | GOOS (Freeman & Pryce) | Test Pyramid | <level> | <date> | <n> |
| 13 | Observability Engineering (Majors) | Structured Logging | <level> | <date> | <n> |
| 14 | Observability Engineering (Majors) | Distributed Tracing | <level> | <date> | <n> |
| 15 | Observability Engineering (Majors) | Metrics & Alerting | <level> | <date> | <n> |
| 16 | Refactoring UI (Wathan & Schoger) | Visual Hierarchy | <level> | <date> | <n> |
| 17 | Don't Make Me Think (Krug) | Cognitive Load | <level> | <date> | <n> |
| 18 | Every Layout (Bell & Pickering) | Intrinsic Design | <level> | <date> | <n> |
| 19 | Every Layout (Bell & Pickering) | Composition Patterns | <level> | <date> | <n> |
| 20 | Design Systems (Kholmatova) | Design Tokens | <level> | <date> | <n> |
| 21 | Design Systems (Kholmatova) | Component API Design | <level> | <date> | <n> |
| 22 | About Face (Cooper) | Goal-Directed Design | <level> | <date> | <n> |
| 23 | About Face (Cooper) | Interaction Patterns | <level> | <date> | <n> |
| 24 | Inclusive Design Patterns (Pickering) | ARIA Patterns | <level> | <date> | <n> |
| 25 | Inclusive Design Patterns (Pickering) | Keyboard Navigation | <level> | <date> | <n> |
| 26 | The Illusion of Life (Thomas & Johnston) | The 12 Principles | <level> | <date> | <n> |
| 27 | The Illusion of Life (Thomas & Johnston) | Timing & Easing | <level> | <date> | <n> |
| 28 | Animation at Work (Nabors) | State Transitions | <level> | <date> | <n> |
| 29 | Animation at Work (Nabors) | Meaningful vs Decorative | <level> | <date> | <n> |
| 30 | Designing Interface Animation (Head) | Choreography | <level> | <date> | <n> |
| 31 | Designing Interface Animation (Head) | Motion Narrative | <level> | <date> | <n> |

---

## Session Ledger

<!-- Append-only log. Never delete rows. -->

| Session Date | Phase | Gate | Concept | Action | Outcome |
|-------------|-------|------|---------|--------|---------|

---

## Correction History

<!-- Append-only log. Never delete rows. -->

| Date | Concept Area | What Was Wrong | Correction Applied |
|------|-------------|----------------|-------------------|

---

## Project History

<!-- Append-only log. Never delete rows. -->

| Date | Project | Concepts Applied | Notes |
|------|---------|-----------------|-------|

---

## Learning Preferences

- **Preferred Explanation Style:** <analogy | formal-definition | code-first | diagram>
- **Feedback Directness:** <gentle | direct | blunt>
- **Session Length Preference:** <short (15 min) | medium (30 min) | long (60 min)>
```

---

## Concept Areas (31 total, across 17 books)

| # | Book | Concept Area | Description |
|---|------|-------------|-------------|
| 1 | Domain-Driven Design (Evans) | Bounded Contexts | Defining explicit boundaries between subdomains with their own models and ubiquitous language |
| 2 | Domain-Driven Design (Evans) | Aggregates | Clustering entities and value objects into consistency boundaries with a single root |
| 3 | Designing Data-Intensive Applications (Kleppmann) | Data Modeling | Choosing between relational, document, and graph models based on access patterns |
| 4 | Designing Data-Intensive Applications (Kleppmann) | Replication | Leader-based, multi-leader, and leaderless strategies; consistency vs. availability trade-offs |
| 5 | Release It! (Nygard) | Circuit Breakers | Preventing cascading failures by failing fast when a downstream dependency is unhealthy |
| 6 | Release It! (Nygard) | Bulkheads | Isolating components so a failure in one does not sink the entire system |
| 7 | Release It! (Nygard) | Timeouts | Setting explicit time bounds on all inter-system calls to avoid indefinite blocking |
| 8 | Designing ML Systems (Huyen) | Data Pipelines | Building reliable, testable pipelines for feature extraction and data transformation |
| 9 | Designing ML Systems (Huyen) | Model Lifecycle | Training, evaluation, deployment, monitoring, and retraining workflows |
| 10 | Infrastructure as Code (Morris) | IaC Patterns | Declarative infrastructure definitions, immutable servers, and environment parity |
| 11 | Growing Object-Oriented Software (Freeman & Pryce) | TDD Red-Green-Refactor | Writing a failing test, making it pass with minimal code, then improving the design |
| 12 | Growing Object-Oriented Software (Freeman & Pryce) | Test Pyramid | Balancing unit, integration, and end-to-end tests for fast, reliable feedback |
| 13 | Observability Engineering (Majors et al.) | Structured Logging | Emitting machine-parseable log events with consistent fields for queryability |
| 14 | Observability Engineering (Majors et al.) | Distributed Tracing | Propagating trace context across service boundaries to reconstruct request flows |
| 15 | Observability Engineering (Majors et al.) | Metrics & Alerting | Defining SLIs/SLOs, choosing metric types, and setting actionable alert thresholds |
| 16 | Refactoring UI (Wathan & Schoger) | Visual Hierarchy | Using size, weight, color, and spacing to guide the eye to what matters |
| 17 | Don't Make Me Think (Krug) | Cognitive Load | Reducing the mental effort required for users to accomplish tasks |
| 18 | Every Layout (Bell & Pickering) | Intrinsic Design | Content-driven sizing with min()/max()/clamp() instead of fixed breakpoints |
| 19 | Every Layout (Bell & Pickering) | Composition Patterns | Stack, Sidebar, Cluster, Switcher, Cover, Grid as algorithmic layout primitives |
| 20 | Design Systems (Kholmatova) | Design Tokens | Named values representing design decisions, organized in global/alias/component tiers |
| 21 | Design Systems (Kholmatova) | Component API Design | Props as the interface contract, composition vs configuration, variant patterns |
| 22 | About Face (Cooper) | Goal-Directed Design | Designing for user goals (why) not tasks (what), using personas with context and constraints |
| 23 | About Face (Cooper) | Interaction Patterns | Progressive disclosure, direct manipulation, error prevention, feedback loops |
| 24 | Inclusive Design Patterns (Pickering) | ARIA Patterns | When to use ARIA vs semantic HTML, roles/states/properties, the first rule of ARIA |
| 25 | Inclusive Design Patterns (Pickering) | Keyboard Navigation | Focus management, tab order, skip links, keyboard traps, roving tabindex |
| 26 | The Illusion of Life (Thomas & Johnston) | The 12 Principles | Disney's animation principles translated to UI: anticipation, follow-through, easing, timing |
| 27 | The Illusion of Life (Thomas & Johnston) | Timing & Easing | Duration ranges by interaction type, easing curves for enter/exit/reposition, 60fps budget |
| 28 | Animation at Work (Nabors) | State Transitions | Mapping UI states explicitly, choosing continuous vs discrete transitions |
| 29 | Animation at Work (Nabors) | Meaningful vs Decorative | The test: remove the animation — if information is lost, it is meaningful |
| 30 | Designing Interface Animation (Head) | Choreography | Stagger sequences, entrance/exit ordering, maintaining spatial relationships |
| 31 | Designing Interface Animation (Head) | Motion Narrative | Micro-stories in UI, animation as communication not decoration, when NOT to animate |

---

## Confidence Levels

Each concept area carries a confidence level that progresses through a fixed promotion chain:

```
none --> emerging --> developing --> confident --> mastery
```

### Level Definitions

| Level | Meaning | Evidence Required to Promote |
|-------|---------|----------------------------|
| `none` | Not yet encountered | N/A (starting state) |
| `emerging` | Has seen the concept, can recognize it | Correctly identified the concept in a real scenario (1 instance) |
| `developing` | Can apply with guidance | Applied the concept correctly with mentor prompting (2 instances) |
| `confident` | Can apply independently and explain trade-offs | Applied independently and articulated why, including trade-offs (3 instances) |
| `mastery` | Can teach others and adapt to novel situations | Demonstrated correct application in an unfamiliar context without prompting (2 instances after reaching `confident`) |

### Promotion Rules

1. **Promotions require evidence.** Each promotion is recorded in the Session Ledger with the specific evidence that justified it.
2. **One level at a time.** No skipping levels (except during initial seeding — see below).
3. **Demotions do not happen.** Confidence levels only go up. If an engineer makes a mistake, it is logged in Correction History but the level stays. Repeated errors in a concept may warrant deeper teaching, not demotion.
4. **Evidence Count tracks demonstrations.** The `Evidence Count` column in the heat map tallies the number of times the engineer has correctly demonstrated the concept. This count only goes up.

---

## Initial Profile Seeding

When a new profile is created, the onboarding interview determines the experience level (A/B/C/D). The heat map is then seeded with starting confidence levels based on reasonable defaults for that level. The engineer can override any of these during onboarding.

### Seeding Defaults by Experience Level

| Concept Area | A (Student) | B (Mid) | C (Senior) | D (Staff+) |
|-------------|-------------|---------|------------|------------|
| Bounded Contexts | none | emerging | developing | confident |
| Aggregates | none | emerging | developing | confident |
| Data Modeling | none | emerging | developing | confident |
| Replication | none | none | emerging | developing |
| Circuit Breakers | none | none | emerging | developing |
| Bulkheads | none | none | emerging | developing |
| Timeouts | none | emerging | developing | confident |
| Data Pipelines | none | none | emerging | developing |
| Model Lifecycle | none | none | emerging | developing |
| IaC Patterns | none | none | emerging | developing |
| TDD Red-Green-Refactor | none | emerging | developing | confident |
| Test Pyramid | none | emerging | developing | confident |
| Structured Logging | none | none | emerging | developing |
| Distributed Tracing | none | none | emerging | developing |
| Metrics & Alerting | none | none | emerging | developing |
| Visual Hierarchy | none | emerging | developing | confident |
| Cognitive Load | none | emerging | developing | confident |
| Intrinsic Design | none | none | emerging | developing |
| Composition Patterns | none | none | emerging | developing |
| Design Tokens | none | none | emerging | developing |
| Component API Design | none | emerging | developing | confident |
| Goal-Directed Design | none | none | emerging | developing |
| Interaction Patterns | none | emerging | developing | confident |
| ARIA Patterns | none | none | emerging | developing |
| Keyboard Navigation | none | none | emerging | developing |
| The 12 Principles | none | none | emerging | developing |
| Timing & Easing | none | none | emerging | developing |
| State Transitions | none | none | emerging | developing |
| Meaningful vs Decorative | none | none | emerging | developing |
| Choreography | none | none | none | emerging |
| Motion Narrative | none | none | none | emerging |

When seeding, `Evidence Count` is set to `0` and `Last Touched` is set to the profile creation date. Seeded levels represent self-reported starting points, not demonstrated evidence.

---

## Data Preservation Guarantees

The profile follows strict append-only semantics for all log sections:

1. **Session Ledger** -- Append-only. Every mentoring interaction adds a row. Rows are never edited or deleted.
2. **Correction History** -- Append-only. Every correction adds a row. Rows are never edited or deleted.
3. **Project History** -- Append-only. Every project engagement adds a row. Rows are never edited or deleted.
4. **Competency Heat Map** -- This is a **derived view**, not a source of truth. Its values are computable from the Session Ledger. However, it is maintained inline for quick reference. When updating the heat map, the skill must also append the corresponding ledger entry.
5. **Identity and Learning Preferences** -- These sections may be updated in-place when the engineer requests changes. The previous values are not preserved (they are preferences, not historical data).

### Integrity Rule

> If the Session Ledger and the Heat Map ever disagree, the Session Ledger is authoritative. The heat map can be rebuilt from the ledger at any time.

---

## Session Ledger Format

Each row in the Session Ledger captures one meaningful interaction during a mentoring session.

| Column | Type | Description |
|--------|------|-------------|
| Session Date | ISO-8601 date | The date of the session |
| Phase | string | The phase of the mentoring session (e.g., `onboarding`, `gate-check`, `teaching`, `project-review`) |
| Gate | string or `--` | Which decision gate was involved, if any (e.g., `gate-1-problem-framing`, `gate-2-design`, `gate-3-implementation`, `gate-4-review`). Use `--` if no gate applies. |
| Concept | string | The concept area from the heat map (e.g., `Bounded Contexts`, `Circuit Breakers`) |
| Action | string | What happened (e.g., `introduced`, `applied-with-guidance`, `applied-independently`, `corrected`, `promoted-to-developing`) |
| Outcome | string | Brief description of the result (e.g., `correctly identified aggregate boundary in order service`, `confused aggregate with entity -- see correction log`) |

### Example Rows

```markdown
| 2026-03-05 | gate-check | gate-2-design | Bounded Contexts | applied-with-guidance | drew context map for payment and order domains after prompting |
| 2026-03-05 | teaching | -- | Circuit Breakers | introduced | explained concept using Netflix Hystrix analogy; engineer asked good follow-up questions |
| 2026-03-05 | gate-check | gate-2-design | Bounded Contexts | promoted-to-developing | second successful application; promoted from emerging |
```
