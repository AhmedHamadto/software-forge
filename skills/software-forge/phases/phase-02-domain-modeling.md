# Phase 2: Domain Modeling

**Applies to:** Full-Stack, Voice, Edge/IoT+ML, Mobile (with backend)
**Source:** *Domain-Driven Design* (Eric Evans)
**Output:** Domain model section appended to design doc

### Questions to Ask

Work through these one at a time:

1. **Bounded Contexts:** What are the distinct areas of the business domain?
   - Each context has its own ubiquitous language, models, and rules
   - Example (restaurant SaaS): Ordering, Menu Management, Voice Interaction, Billing
   - Example (industrial IoT): Detection, Review, Training, Fleet Management, Telemetry

2. **Aggregates:** Within each context, what are the consistency boundaries?
   - An aggregate is a cluster of entities that must be consistent together
   - What invariants must hold within each aggregate?
   - Example: An "Order" aggregate — items can't be empty, total must match items, status transitions are valid

3. **Domain Events:** What important things happen that other contexts care about?
   - Events cross context boundaries; commands stay within them
   - Example: "DetectionCreated" -> triggers Review context; "ReviewCompleted" -> triggers Training context

4. **Context Map:** How do bounded contexts communicate?
   - Shared kernel, customer-supplier, conformist, anti-corruption layer?
   - Where are the translation layers needed?

### Deliverable

```markdown
## Domain Model

### Bounded Contexts
- **[Context Name]**: [Purpose, key entities, invariants]

### Aggregates
- **[Aggregate Name]**: [Root entity, child entities, invariants]

### Domain Events
- [EventName]: [Source context] -> [Target context(s)]

### Context Map
[How contexts relate and communicate]
```
