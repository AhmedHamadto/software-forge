# Phase 17: Observability Design

**Applies to:** Full-Stack, Voice, Edge/IoT+ML
**Source:** *Observability Engineering* (Charity Majors)
**Output:** Observability section appended to system design doc

### Questions to Ask

1. **Structured Logging:**
   - What logging format? (JSON, structured key-value)
   - What fields on every log line? (timestamp, service, request_id, user_id, trace_id)
   - Correlation IDs — how do you trace a request across services?

2. **Distributed Tracing:**
   - What spans exist? (one per service hop in the request path)
   - What tool? (X-Ray, Jaeger, OpenTelemetry)
   - What sampling rate? (100% in staging, 10% in prod, 100% for errors)

3. **Metrics:**
   - RED metrics per service: Rate, Errors, Duration
   - Business metrics: orders/hour, detections/day, review latency
   - Infrastructure metrics: CPU, memory, queue depth, cache hit rate
   - Use percentiles (p50, p95, p99), not averages

4. **Alerting:**
   - What's worth waking someone up for? (data loss, service down, security breach)
   - What can wait until morning? (elevated error rate, slow responses, queue backlog)
   - Alert fatigue prevention — fewer, better alerts

5. **Dashboards:**
   - One dashboard per bounded context
   - Top-level "system health" dashboard
   - On-call runbook linked from each alert

### Deliverable

```markdown
## Observability

### Logging
- Format: [JSON/structured]
- Required Fields: [timestamp, service, request_id, trace_id, ...]
- Correlation: [How trace IDs propagate]

### Tracing
- Tool: [X-Ray/Jaeger/OTEL]
- Spans: [List of spans in critical path]
- Sampling: [Rate per environment]

### Metrics
| Metric | Type | Alert Threshold |
|--------|------|----------------|
| [name] | [RED/business/infra] | [threshold] |

### Alerting
| Alert | Severity | Action |
|-------|----------|--------|
| [What] | [Page/Warning/Info] | [Runbook link] |

### Decision Log — Phase 17: Observability
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
