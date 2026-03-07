# Release It! (Michael Nygard) — Teaching Content

## Circuit Breakers

### Deep (first exposure)

In a distributed system, your application calls other services — a payment gateway, a recommendation engine, a third-party API. When one of those dependencies fails, the naive approach is to keep retrying. But Nygard explains in Chapter 5 that retrying a failing call is often the worst thing you can do. If the payment service is down under load, hammering it with retries from every instance of your application does not help it recover — it buries it deeper. Meanwhile, your own application's threads are blocked waiting for responses that will never come, and your users are staring at spinning loaders.

A Circuit Breaker is a wrapper around remote calls that tracks failures and short-circuits when a dependency is unhealthy. It has three states. **Closed** is the normal state: calls pass through, and the breaker counts consecutive failures. When failures hit a threshold (say, 5 failures in 10 seconds), the breaker trips to **Open**. In the Open state, calls fail immediately without attempting the remote call — fast failure instead of slow failure. After a configurable timeout, the breaker moves to **Half-Open**: it allows a single probe call through. If that call succeeds, the breaker resets to Closed. If it fails, back to Open.

Consider an e-commerce checkout service that calls a fraud detection API. Without a circuit breaker, when the fraud service goes down, every checkout request hangs for 30 seconds (the HTTP timeout), then fails. With 100 concurrent users, that is 100 threads blocked for 30 seconds each — your checkout service is effectively down too, even though there is nothing wrong with it. With a circuit breaker, after 5 failed calls, the breaker opens. Subsequent checkout requests get an immediate failure from the breaker, letting you implement a fallback: skip fraud check and flag for manual review, or show a "try again in a moment" message. Either way, your checkout service stays responsive.

The key insight from Nygard is that circuit breakers prevent cascade failures — the domino effect where one failing service takes down everything that depends on it, which takes down everything that depends on them. In production systems, cascade failures are the most common cause of total outages. A circuit breaker is the difference between "the recommendation engine is down so recommendations are empty" and "the recommendation engine is down so the entire site is down."

### Refresher (subsequent exposure)

A Circuit Breaker wraps remote calls and fails fast when a dependency is unhealthy, preventing cascade failures. It transitions through Closed (normal), Open (calls blocked), and Half-Open (probing for recovery). When a breaker is open, implement a fallback rather than letting the failure propagate.

### Socratic Questions

- Your API service calls both a payment provider and an email service during checkout. The email service starts timing out on every request. Without a circuit breaker, what happens to your checkout throughput, and why is slow failure worse than fast failure here?
- You have set your circuit breaker to trip after 3 failures with a 60-second open window. During a deployment of the downstream service, it briefly returns errors for 5 seconds. Is your breaker configuration appropriate, or would it cause unnecessary disruption? What would you adjust?
- Your circuit breaker is in the Open state, and the fallback for your recommendation service returns an empty list. A product manager asks why recommendations disappeared. How do you make circuit breaker state visible to the team without requiring them to read logs?

---

## Bulkheads

### Deep (first exposure)

The term "bulkhead" comes from ship design. Ships are divided into watertight compartments so that if the hull is breached in one section, water floods that compartment but not the entire ship. Nygard applies this metaphor to software in Chapter 5: your system should be partitioned so that a failure in one area cannot consume all the resources and sink everything.

In practice, a bulkhead means allocating separate resource pools for different dependencies or workloads. Suppose your API service calls three downstream services: payments, inventory, and notifications. Without bulkheads, they share a single HTTP connection pool of 100 connections. If the notification service starts responding slowly, all 100 connections gradually fill up waiting for notification responses. Now your payments calls and inventory calls cannot get a connection — they fail too, even though those services are perfectly healthy. A single slow dependency has consumed the shared resource and taken down unrelated functionality.

With bulkheads, you allocate dedicated connection pools: 50 connections for payments, 30 for inventory, 20 for notifications. When notifications gets slow and saturates its 20 connections, payments and inventory continue operating normally with their own pools. The damage is contained. You can apply the same principle to thread pools, memory allocations, CPU cores, or even separate process instances. The more critical the workload, the more isolated its resources should be.

The cost of bulkheads is reduced efficiency — dedicated pools mean some resources sit idle while others are saturated. This is a deliberate trade-off. Nygard argues that in production systems, the cost of over-provisioning a few connection pools is trivial compared to the cost of a total outage caused by resource exhaustion. The most dangerous dependencies are often the ones you think about least — a logging service, a feature flag provider, an analytics endpoint — because nobody expects them to fail. Bulkheads ensure that when the unexpected happens, the blast radius is contained.

### Refresher (subsequent exposure)

Bulkheads isolate resource pools per dependency so that a failure or slowdown in one area cannot exhaust resources needed by others. Dedicate separate connection pools, thread pools, or process instances to different workloads, especially separating critical paths from non-critical ones.

### Socratic Questions

- Your Node.js API has a single HTTP client shared across calls to Stripe (payments), SendGrid (email), and a third-party weather API used for a minor feature. The weather API starts hanging. What happens to payment processing, and how would bulkheads prevent it?
- You are designing a microservice that handles both real-time user requests and background batch processing. Both use the same database connection pool. During a batch import of 100,000 records, user requests start timing out. What bulkhead strategy would you apply?
- A teammate argues that separate connection pools waste resources because each pool has idle connections while others are at capacity. How would you respond to this concern, and when is the inefficiency justified?

---

## Timeouts

### Deep (first exposure)

Every call your system makes to another system — an HTTP request, a database query, a message broker publish — can hang indefinitely unless you set an explicit timeout. Nygard dedicates significant attention to timeouts in Chapter 5 because the default behavior of most libraries and frameworks is to wait forever, and "forever" in a production system means your threads fill up, your connection pools drain, and your application becomes unresponsive. The key insight is that a slow response is worse than no response. A failed call can be retried, routed to a fallback, or reported to the user in milliseconds. A call that hangs for 60 seconds ties up a thread, a connection, and a user's patience for 60 seconds before giving the same failure.

Timeouts must be set deliberately, not left to defaults. Nygard warns that default timeouts are always wrong — they are either infinite (no timeout at all), or they are a generic value chosen by the library author who has no idea about your specific latency requirements. You need to reason about what an acceptable response time is for each call. If your payment API normally responds in 200ms, a 30-second timeout means that when it is failing, you will wait 150 times longer than normal before noticing. A 2-second timeout is more appropriate: it is generous enough to handle slow responses but fast enough to detect a real problem.

Timeout budgets become critical when calls are chained. If your user-facing API has a 5-second SLA, and it calls Service A which calls Service B which calls Service C, you cannot give each service a 5-second timeout — that is 15 seconds in the worst case. You need cascading timeouts: the outer call has a 5-second budget, Service A gets 3 seconds (leaving 2 for processing), Service A gives Service B 2 seconds, and so on. Each layer must be aware of its budget and fail fast if the budget is exceeded, rather than starting a downstream call that cannot possibly complete in time.

Without proper timeouts, a single slow dependency can create a cascading failure across your entire system. Consider an API gateway with no timeout on a backend call. The backend database locks up. Every request to the gateway starts a thread that blocks waiting for the backend. In minutes, the gateway runs out of threads and stops accepting new connections. Load balancers start health-checking the gateway as unhealthy. Users see 502 errors. The root cause was a slow database, but the symptoms look like the entire infrastructure is down. A well-chosen timeout on that backend call would have failed fast, returned an error to the user in 2 seconds, and kept the gateway healthy for all other routes.

### Refresher (subsequent exposure)

Set explicit timeouts on every remote call — defaults are always wrong. A slow response is worse than a failure because it ties up resources while providing no value. Use timeout budgets for call chains: each layer gets a fraction of the total budget, ensuring the outer SLA is never violated by unbounded downstream waits.

### Socratic Questions

- Your API calls a third-party geocoding service with no explicit timeout configured. The geocoding service deploys a bad release and starts responding in 45 seconds instead of 200ms. What happens to your API's throughput and error rate, and what timeout would you set?
- Your checkout flow calls three services sequentially: inventory check (usually 100ms), payment charge (usually 500ms), and email notification (usually 200ms). Your API has a 3-second SLA. How would you distribute the timeout budget across these calls, and what happens to the notification call if inventory and payment together take 2.5 seconds?
- A developer on your team sets all HTTP client timeouts to 30 seconds "to be safe and avoid false timeouts." Why is this arguably worse than having no timeout strategy at all?
