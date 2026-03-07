# Observability Engineering (Charity Majors et al.) — Teaching Content

## Structured Logging

### Deep (first exposure)

When something goes wrong in production, the first thing most developers do is read the logs. But if your logs are unstructured strings — `console.log("Error processing order")` or `logger.info(f"User {user_id} logged in from {ip}")` — you are left grepping through gigabytes of text with fragile regular expressions, hoping the information you need was included in the message and that the format has not changed since the last developer touched that log line. Majors and co-authors explain in Chapters 5-6 that structured logging transforms logs from a pile of text into a queryable data source.

Structured logging means emitting every log event as a machine-parseable record (typically JSON) with consistent, well-known fields. Every event should include at minimum: a timestamp (ISO-8601, UTC), the service name, a log level, a request ID or correlation ID, and the actual message. When distributed systems are involved, you also want a trace ID that ties log events across service boundaries together. Instead of `"Failed to charge customer"`, you emit `{"timestamp": "2026-03-05T14:22:01Z", "service": "payments", "level": "error", "request_id": "req-abc123", "trace_id": "trace-xyz789", "customer_id": "cust-456", "amount": 9999, "currency": "USD", "error": "card_declined", "message": "Payment charge failed"}`. Every field is independently queryable.

The practical difference is dramatic. With structured logs and a log aggregation tool (Datadog, Loki, CloudWatch Logs Insights), you can query: "show me all errors in the payments service in the last hour where the amount exceeds $50" — and get precise results in seconds. With unstructured logs, that same investigation requires grep, awk, and prayer. Correlation IDs are particularly powerful: when a user reports a problem, you look up their request ID and instantly see every log event across every service that participated in that request, in chronological order. Without correlation IDs, tracing a request through three services requires correlating timestamps and hoping the clocks are synchronized.

The cost of structured logging is discipline, not performance. Every developer on the team must include the required fields in every log statement. Libraries like `pino` (Node.js), `structlog` (Python), or `slog` (Go) make this the default rather than the exception by attaching context fields automatically. The migration from printf-style logging to structured logging is one of the highest-leverage observability improvements a team can make — it turns "we have logs" from a theoretical safety net into an actual debugging tool.

### Refresher (subsequent exposure)

Structured logging emits machine-parseable events (JSON) with consistent fields — timestamp, service, level, request_id, trace_id, and context-specific data. This makes logs queryable instead of grep-able. Always include a correlation ID so you can trace a single request across all services that touched it.

### Socratic Questions

- Your Node.js API uses `console.log` throughout. A user reports that their checkout failed but your logs only show `"Error in checkout"` with no context. What specific fields would you add to make this log event useful for debugging, and how would you ensure every developer on the team includes them?
- Two services are involved in processing a payment: an API gateway and a payments service. A request fails somewhere between them. Your logs have timestamps but no correlation IDs. How do you figure out which log lines in the payments service correspond to the failing request from the gateway?
- A junior developer adds a log line: `logger.info("User " + userId + " placed order " + orderId + " for $" + total)`. What is wrong with this from a structured logging perspective, and how would you rewrite it?

---

## Distributed Tracing

### Deep (first exposure)

In a monolith, understanding a request's journey is straightforward — you step through the code or read a stack trace. In a distributed system where a single user action touches 5, 10, or 20 services, a stack trace only shows you what happened inside one service. You know the API gateway returned a 500 error, but was it the auth service, the product catalog, the pricing engine, or the inventory service that caused the problem? Majors et al. cover distributed tracing in Chapters 7-8 as the tool that reconstructs the full picture.

A trace represents the entire journey of a single request through your system. It is composed of spans, where each span represents a unit of work — an HTTP call, a database query, a message publish, a function execution. Spans have a start time, a duration, a status, and key-value tags (like `http.method=POST`, `db.statement=SELECT...`). Spans are nested: the API gateway span contains a child span for the auth service call, which contains a child span for the database query inside the auth service. This parent-child relationship forms a tree that shows exactly where time was spent and where errors occurred. Trace context (usually a trace ID and span ID) is propagated across service boundaries via HTTP headers (the W3C `traceparent` header is the standard).

Consider a checkout flow that calls inventory, payments, and notifications. A trace for this request would show: the top-level span is the API gateway handling the POST to `/checkout` (total time: 850ms). Inside it, you see a span for the inventory check (50ms, success), a span for the payment charge (750ms, success), and a span for the notification (failed after 30ms with a connection error). Without tracing, your monitoring shows "checkout p99 is 850ms" — but you cannot tell if that is because payments is slow or because you are retrying notifications. With tracing, you see immediately that payments dominates the latency and the notification failure is a separate issue.

Tracing is not free. Every span generates data, and in a high-traffic system, that adds up fast. Sampling strategies let you collect a representative subset: head-based sampling decides at the start of a trace whether to sample it (e.g., 10% of traces), while tail-based sampling waits until the trace is complete and keeps only interesting ones (errors, high latency). You do not need distributed tracing for every system. A single service with a database rarely benefits — structured logs are sufficient. Tracing shines when requests cross service boundaries and you need to understand end-to-end latency and failure propagation.

### Refresher (subsequent exposure)

Distributed tracing reconstructs a request's journey across services using spans (units of work) organized into traces (the full request tree). Trace context propagates via HTTP headers. Use sampling to control data volume. Tracing is most valuable when requests cross multiple service boundaries and you need to diagnose latency or failure propagation.

### Socratic Questions

- Your checkout API has a p99 latency of 2 seconds, but each downstream service reports healthy latencies under 200ms. What could distributed tracing reveal that per-service metrics cannot, and how would you use a trace to find the bottleneck?
- You are adding tracing to a system with three services. Service A calls Service B, which calls Service C. What happens if Service B does not propagate the trace context header to Service C? What does the trace look like?
- Your system handles 10,000 requests per second and you are considering adding tracing. Each trace generates about 5 spans. If you collect every trace, how much data does that produce, and what sampling strategy would you use to keep costs manageable while still catching errors?

---

## Metrics & Alerting

### Deep (first exposure)

Logs tell you what happened to a specific request. Traces tell you how a specific request flowed through the system. Metrics tell you what is happening to the system as a whole, right now. Majors et al. cover metrics and alerting in Chapters 9-10, and the core framework they recommend is RED: Rate (requests per second), Errors (failed requests per second or error percentage), and Duration (how long requests take, measured in percentiles). These three numbers, tracked per service and per endpoint, give you a remarkably complete picture of system health.

The critical word in that framework is "percentiles." Average latency is almost always a misleading number. If 99 requests take 50ms and 1 request takes 10 seconds, the average is 149ms — which describes nobody's actual experience. The p50 (median) is 50ms, the p99 is 10 seconds, and the p99.9 might be even worse. Percentiles show you the distribution. A healthy service has a tight distribution (p50 and p99 are close). A service with a problem has a long tail (p50 is fine, p99 is terrible). The users hitting the p99 are often your most important users — they are the ones with the largest carts, the most complex queries, the longest histories. Optimizing the average while ignoring the tail means making the experience worse for your best customers.

Alerting is where metrics become operational. The fundamental question is: what deserves to wake someone up at 3 AM? Majors et al. are emphatic that alert fatigue is a real and dangerous problem. If your on-call engineer gets 50 alerts per day, they stop reading them — and the one alert that represents a real outage gets lost in the noise. An alert should fire only when a human needs to take action that a machine cannot. Alerts based on causes ("CPU is at 80%") produce noise because high CPU might be fine during a batch job. Alerts based on symptoms ("error rate exceeded 5% for 5 minutes" or "p99 latency exceeded 2 seconds for 10 minutes") catch real user-facing problems regardless of the underlying cause.

Build a two-tier alerting system: pages (wake someone up) and warnings (review during business hours). A page means users are affected right now and a human must intervene. The error rate for your checkout endpoint exceeding 5% for 5 minutes is a page. A warning means something is degraded but not critical. A background job queue growing faster than it is draining is a warning. If you cannot articulate "when this alert fires, here is the runbook for what to do," the alert should not exist.

### Refresher (subsequent exposure)

Track RED metrics (Rate, Errors, Duration) per service using percentiles, not averages. Alert on symptoms (error rate, latency) rather than causes (CPU, memory). Maintain two tiers: pages for user-impacting issues requiring immediate human action, and warnings for review during business hours. Every alert should have a corresponding runbook.

### Socratic Questions

- Your service's average response time is 120ms, and the dashboard shows green. But users are complaining about slow performance. What metric should you check instead of the average, and what might it reveal?
- Your monitoring system sends alerts for: CPU > 80%, disk > 70%, memory > 75%, error rate > 1%, and p99 latency > 500ms. Your on-call engineer gets 30 alerts per day and has started ignoring them. Which of these alerts are symptom-based versus cause-based, and which would you keep, modify, or remove?
- You are setting up alerting for a new payment processing service. What would you configure as a page-worthy alert versus a warning, and how would you decide the thresholds (e.g., what error rate percentage, over what time window)?
