# Phase 4: Resilience Patterns

**Applies to:** Full-Stack, Voice, Edge/IoT+ML, Mobile (with external services)
**Source:** *Release It!* (Michael Nygard)
**Output:** Resilience section appended to system design doc

### Questions to Ask

For **each external dependency** (API, database, message queue, third-party service):

1. **Failure Mode:** What happens when this dependency is unavailable?
   - Timeout? Error response? Silent data loss?
   - How long can you tolerate the outage?

2. **Circuit Breaker:** Should you fail fast after N failures?
   - What's the threshold? (e.g., 5 failures in 30 seconds)
   - What's the half-open recovery strategy?

3. **Timeout Budget:** What's the maximum wait time?
   - For voice agents: total turn budget (STT + LLM + TTS must complete before silence)
   - For web: p95 response time target per endpoint

4. **Retry Policy:** Is the operation safe to retry?
   - Idempotent? -> Retry with exponential backoff
   - Non-idempotent? -> Fail and surface to user
   - Maximum retries before circuit opens?

5. **Bulkhead:** Does failure in one integration affect others?
   - Separate thread pools / connection pools per dependency?
   - Can a slow Stripe response block voice ordering?

6. **Graceful Degradation:** What's the reduced-functionality mode?
   - POS down -> queue orders for later sync?
   - GPS unavailable -> save detection without coordinates?
   - Cache down -> serve from DB (slower but functional)?

### Deliverable

```markdown
## Resilience Patterns

| Dependency | Failure Mode | Circuit Breaker | Timeout | Retry | Degradation |
|-----------|-------------|----------------|---------|-------|-------------|
| [Service] | [What breaks] | [Threshold] | [ms] | [Policy] | [Fallback] |

### Decision Log — Phase 4: Resilience
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
