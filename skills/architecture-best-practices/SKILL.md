---
name: architecture-best-practices
description: Queryable knowledge base of community-proven patterns and gotchas for technology combinations across the 15-domain Tech Stack Taxonomy. Use when evaluating stack choices, diagnosing production issues, asking how to correctly combine specific technologies, looking up best practices for a particular technology pattern, or feeding the Stack Compatibility Oracle.
---

Surface what the community and real-world experience says about how technologies play together. This is the reference layer that maps concrete best practices to the 15-domain Tech Stack Taxonomy and feeds into the Stack Compatibility Oracle.

## When to Use

- Evaluating a technology choice before committing to it
- Diagnosing why a stack combination is causing problems
- Feeding the Stack Compatibility Oracle with grounded knowledge
- Reviewing architecture decisions during design phases
- Answering "what could go wrong" before it goes wrong

## Query Interface

This skill responds to four query modes:

1. **Domain query** — "What are best practices for Data Storage?" returns all practices for that domain
2. **Combination query** — "Best practices for Next.js + Supabase + Vercel?" returns relevant practices across all domains for that stack
3. **Problem query** — "My API is slow under load" returns relevant practices from Performance, API, Infrastructure, Data Storage domains
4. **Comparison query** — "PostgreSQL vs DynamoDB for this use case?" returns decision criteria with trade-offs

## Process

1. **Receive query** — User asks about a technology, combination, or problem
2. **Map to taxonomy** — Identify which of the 15 domains are relevant
3. **Retrieve practices** — Pull relevant best practices from this knowledge base
4. **Contextualize** — Filter and rank by the user's project context (scale, team size, constraints)
5. **Present** — Structured output with practices, reasoning, and cross-domain impacts

## Domain Best Practices

### 1. Language & Runtime

**Practice:** Pin your runtime version in the project (`.node-version`, `.python-version`, `rust-toolchain.toml`)
**Why:** Version drift between developers and CI causes "works on my machine" bugs. A minor Node.js version difference can change crypto behavior, module resolution, or V8 optimizations.
**Applies when:** Any project with more than one contributor or any CI pipeline
**Cross-domain impact:** CI/CD, Developer Experience, Testing

**Practice:** Use strict/explicit mode for your language (`"strict": true` in tsconfig, `use strict` in JS, `-Wall -Werror` in C/C++, `#![deny(warnings)]` in Rust)
**Why:** Loose mode hides type errors, unused variables, and implicit conversions that become production bugs. Strict mode catches entire categories of errors at compile time.
**Applies when:** Always. The cost of enabling strict mode in an existing project grows exponentially with codebase size — start strict from day one.
**Cross-domain impact:** Testing (fewer runtime errors to test for), Error Handling, Security (type confusion vulnerabilities)

**Practice:** Match your runtime to your deployment target early. If deploying to edge/serverless, develop against those constraints from the start.
**Why:** Node.js APIs available in a full server (fs, child_process, net) do not exist in edge runtimes (Cloudflare Workers, Vercel Edge). Discovering this late means rewriting core logic.
**Applies when:** Serverless or edge deployments, Cloudflare Workers, Deno Deploy, Vercel Edge Functions
**Cross-domain impact:** Infrastructure & Deployment, Framework & Libraries, Performance

**Practice:** Prefer the language's standard library over third-party packages for common operations (path manipulation, crypto, HTTP)
**Why:** Third-party packages add supply chain risk, bundle size, and maintenance burden. The `left-pad` and `event-stream` incidents showed how transitive dependencies become attack vectors.
**Applies when:** The standard library provides equivalent functionality. Exception: when the stdlib implementation is known to be footgun-prone (e.g., Node.js `url.parse` vs `new URL()`).
**Cross-domain impact:** Security, Performance, Developer Experience

### 2. Framework & Libraries

**Practice:** Adopt the framework's conventions for file structure, routing, and data fetching rather than fighting them
**Why:** Frameworks optimize for their intended patterns. Fighting Next.js App Router to do client-side-only rendering, or using Express patterns inside Fastify, creates friction in every feature and breaks on framework updates.
**Applies when:** Always. If the framework's conventions conflict with your requirements, you picked the wrong framework.
**Cross-domain impact:** Developer Experience, Performance, Testing

**Practice:** Minimize client-side JavaScript bundles. Use server components, code splitting, and lazy loading by default.
**Why:** Every 100KB of JavaScript adds ~300ms of parse/compile time on mobile devices. Most web apps ship 2-5x more JavaScript than users need on any given page.
**Applies when:** Web applications, especially those targeting mobile or global audiences
**Cross-domain impact:** Performance, Accessibility & i18n, Cost & Scaling

**Practice:** Evaluate framework upgrade paths before adopting. Check the project's major version history for breaking changes.
**Why:** Angular 1→2, Python 2→3, and React class→hooks transitions cost teams months. A framework with a history of painful upgrades will cost you again.
**Applies when:** Choosing a framework for a project expected to live longer than 2 years
**Cross-domain impact:** Developer Experience, Cost & Scaling

**Practice:** Keep framework-specific code at the edges. Business logic should be framework-agnostic.
**Why:** Coupling business logic to framework APIs (React hooks, Next.js server actions, Rails callbacks) makes testing harder and migration impossible. Pure functions with framework adapters at the boundary survive framework changes.
**Applies when:** Any project with non-trivial business logic
**Cross-domain impact:** Testing, Error Handling & Resilience

### 3. Data Storage

**Practice:** Design your data model around your access patterns, not your entity relationships
**Why:** A normalized relational model that requires 6 JOINs for your most common query will hit a wall at scale. DynamoDB single-table design, PostgreSQL materialized views, or strategic denormalization solve this — but only if designed upfront.
**Applies when:** Any application where read performance matters (most applications)
**Cross-domain impact:** Performance, API & Communication, Cost & Scaling

**Practice:** Always enable connection pooling for database connections from serverless functions
**Why:** Each serverless invocation can open a new database connection. Without pooling (PgBouncer, Supabase connection pooler, RDS Proxy), you exhaust the database connection limit under moderate load — typically 100 connections for most managed PostgreSQL instances.
**Applies when:** Serverless or edge functions connecting to relational databases
**Cross-domain impact:** Infrastructure & Deployment, Performance, Cost & Scaling

**Practice:** Implement database migrations as versioned, idempotent, reversible scripts
**Why:** Ad-hoc schema changes cause drift between environments, break rollbacks, and make incident recovery impossible. Every schema change should be a numbered migration that can run forward and backward.
**Applies when:** Any relational database. Less critical for schemaless stores, but still valuable for index management.
**Cross-domain impact:** CI/CD & Build, Developer Experience, Error Handling & Resilience

**Practice:** Add indexes based on actual query patterns, not speculation. Use `EXPLAIN ANALYZE` before and after.
**Why:** Missing indexes cause slow queries. Unnecessary indexes slow writes and waste storage. Both are common. Measure, don't guess.
**Applies when:** Relational databases under any meaningful load
**Cross-domain impact:** Performance, Observability, Cost & Scaling

**Practice:** Separate your OLTP and OLAP workloads. Do not run analytics queries against your production database.
**Why:** A single unoptimized analytics query can lock tables and spike CPU, degrading the production application. Read replicas, data warehouses, or materialized views isolate these workloads.
**Applies when:** Once you have analytics, reporting, or dashboards reading from the same database as your application
**Cross-domain impact:** Performance, Infrastructure & Deployment, Observability

### 4. API & Communication

**Practice:** Version your APIs from day one. Use URL path versioning (`/v1/`) for public APIs, header versioning for internal APIs.
**Why:** Unversioned APIs force backward compatibility forever or break clients on every change. Adding versioning after clients depend on your API is painful and error-prone.
**Applies when:** Any API consumed by external clients or mobile apps. Internal microservice APIs can use header versioning or contract testing instead.
**Cross-domain impact:** Developer Experience, Testing, Cost & Scaling

**Practice:** Use pagination with cursor-based pagination for large datasets, not offset-based
**Why:** Offset pagination (`LIMIT 20 OFFSET 10000`) performs a sequential scan of 10,020 rows. Cursor pagination (`WHERE id > last_seen_id LIMIT 20`) uses an index seek regardless of position.
**Applies when:** Any list endpoint that could return more than a few hundred items
**Cross-domain impact:** Performance, Data Storage, Cost & Scaling

**Practice:** Set explicit timeouts on all HTTP clients and enforce request/response size limits
**Why:** Missing timeouts cause cascading failures. One slow downstream service blocks your thread pool, which blocks your callers, which blocks their callers. A 30-second timeout with a circuit breaker prevents this cascade.
**Applies when:** Any service making outbound HTTP calls
**Cross-domain impact:** Error Handling & Resilience, Performance, Observability

**Practice:** Use GraphQL only when clients genuinely need flexible queries. Default to REST or RPC for service-to-service communication.
**Why:** GraphQL adds complexity (schema management, N+1 query prevention, authorization per field, caching difficulty). That complexity pays off for mobile apps with bandwidth constraints and diverse data needs. It rarely pays off for backend-to-backend calls.
**Applies when:** Choosing between API paradigms for a new service
**Cross-domain impact:** Performance, Security, Developer Experience

### 5. Authentication & Authorization

**Practice:** Use established auth libraries and services (NextAuth, Supabase Auth, Auth0, Clerk) rather than building auth from scratch
**Why:** Custom auth implementations consistently have vulnerabilities: timing attacks on password comparison, session fixation, token leakage in logs, missing CSRF protection. Auth libraries handle these by default.
**Applies when:** Always. The exception is if auth IS your product.
**Cross-domain impact:** Security, Developer Experience, Cost & Scaling

**Practice:** Implement authorization checks at the data layer, not just the API layer
**Why:** API-layer auth checks (middleware, route guards) can be bypassed through direct database access, internal service calls, or missed routes. Row-Level Security, data-layer policies, or repository-pattern authorization checks are the last line of defense.
**Applies when:** Any multi-tenant application or application with role-based access
**Cross-domain impact:** Security, Data Storage, API & Communication

**Practice:** Store sessions in HTTP-only, Secure, SameSite cookies — not localStorage
**Why:** localStorage is accessible to any JavaScript on the page, including XSS payloads. HTTP-only cookies are inaccessible to JavaScript and automatically included in requests.
**Applies when:** Web applications with session-based auth
**Cross-domain impact:** Security, API & Communication

### 6. Infrastructure & Deployment

**Practice:** Make deployments identical across environments. Use infrastructure-as-code and containerization, not manual configuration.
**Why:** "It works in staging" means nothing if staging differs from production. Docker, Terraform/Pulumi, and environment-specific config files (not environment-specific infrastructure) eliminate this class of bugs.
**Applies when:** Any project deploying to more than one environment
**Cross-domain impact:** CI/CD & Build, Testing, Developer Experience

**Practice:** Deploy with zero-downtime strategies (blue-green, rolling, canary) from the first production deployment
**Why:** Adding zero-downtime deployment after launch requires rearchitecting database migrations (must be backward-compatible), health checks, and connection draining. Starting with it is cheap; retrofitting is expensive.
**Applies when:** Any user-facing application
**Cross-domain impact:** Data Storage (migration compatibility), CI/CD & Build, Error Handling & Resilience

**Practice:** Set resource limits (CPU, memory, connections) on every service and database
**Why:** Without limits, a memory leak in one service consumes all available memory on the host, killing co-located services. A connection leak exhausts the database pool. Limits contain blast radius.
**Applies when:** Always, but especially in shared or containerized environments
**Cross-domain impact:** Performance, Cost & Scaling, Observability

### 7. CI/CD & Build

**Practice:** Keep CI pipeline under 10 minutes. Parallelize tests, cache dependencies, and use incremental builds.
**Why:** Slow CI pipelines cause developers to batch changes (larger, riskier PRs), skip running CI locally, and merge without waiting for results. Every minute of CI time multiplies across every commit by every developer.
**Applies when:** Any team with more than one developer
**Cross-domain impact:** Developer Experience, Testing, Cost & Scaling

**Practice:** Run the same checks locally that CI runs. Provide a single command (`make check`, `npm run validate`) that mirrors the CI pipeline.
**Why:** Discovering failures only in CI adds 5-15 minutes of feedback delay per iteration. Local-first validation catches 90% of issues in seconds.
**Applies when:** Always
**Cross-domain impact:** Developer Experience, Testing

**Practice:** Pin CI runner versions and tool versions. Use lock files for all package managers.
**Why:** A CI run that installs `latest` of anything is a CI run that can break without any code change. Reproducible builds require pinned versions everywhere.
**Applies when:** Always
**Cross-domain impact:** Security (supply chain attacks via unpinned dependencies), Developer Experience

### 8. Testing

**Practice:** Structure tests as a pyramid: many unit tests, fewer integration tests, minimal E2E tests. Invert only when your app is primarily integration logic (CRUD apps, API gateways).
**Why:** E2E tests are slow, flaky, and expensive to maintain. Unit tests are fast and precise. An inverted pyramid (many E2E, few unit) results in 45-minute CI runs and constant test maintenance.
**Applies when:** Most applications. CRUD-heavy apps with thin business logic genuinely benefit from more integration tests than unit tests.
**Cross-domain impact:** CI/CD & Build, Developer Experience, Cost & Scaling

**Practice:** Test behavior, not implementation. Assert on outputs and side effects, not internal state or method calls.
**Why:** Implementation-coupled tests break on every refactor, providing negative value — they make safe changes feel risky and risky changes feel safe.
**Applies when:** Always
**Cross-domain impact:** Developer Experience, Error Handling & Resilience

**Practice:** Use factories or builders for test data, not fixtures or raw object literals
**Why:** Fixtures drift from schema changes and provide no type safety. Factories (like `fishery`, `factory_bot`, `faker`) express only the fields relevant to each test and adapt to schema changes automatically.
**Applies when:** Any project with more than a handful of tests
**Cross-domain impact:** Developer Experience, Data Storage

**Practice:** Test your database migrations in CI by running the full migration chain from scratch on every PR
**Why:** Migrations that work incrementally can fail on a fresh database (missing extensions, ordering issues, circular dependencies). CI should prove the migration chain works from zero.
**Applies when:** Any project with database migrations
**Cross-domain impact:** Data Storage, CI/CD & Build, Infrastructure & Deployment

### 9. Observability

**Practice:** Implement structured logging from day one. Use JSON logs with consistent fields: `timestamp`, `level`, `service`, `trace_id`, `message`, `context`.
**Why:** Unstructured logs (`console.log("user did thing")`) are unsearchable at scale. When an incident hits, you need to filter by user, trace, time range, and severity. Structured logs make this possible; unstructured logs make it impossible.
**Applies when:** Always. Even small projects benefit from structured logs when debugging production issues.
**Cross-domain impact:** Error Handling & Resilience, Security (audit trails), Developer Experience

**Practice:** Add health check endpoints that verify downstream dependencies, not just return 200
**Why:** A health check that returns 200 while the database is down causes load balancers to route traffic to broken instances. Deep health checks (database ping, cache ping, external service check) enable proper failover.
**Applies when:** Any application behind a load balancer or orchestrator
**Cross-domain impact:** Infrastructure & Deployment, Error Handling & Resilience

**Practice:** Set up alerting on the four golden signals: latency, traffic, errors, saturation
**Why:** Without alerts on these signals, you learn about outages from users. The four golden signals (Google SRE book) cover 90% of detectable production issues.
**Applies when:** Any production service
**Cross-domain impact:** Performance, Infrastructure & Deployment, Error Handling & Resilience

### 10. Security

**Practice:** Apply the principle of least privilege to every credential, role, and service account
**Why:** An over-privileged service account that gets compromised gives the attacker access to everything. A scoped credential limits blast radius. This applies to database users, API keys, IAM roles, and OAuth scopes.
**Applies when:** Always
**Cross-domain impact:** Authentication & Authorization, Infrastructure & Deployment, Data Storage

**Practice:** Validate and sanitize all input at system boundaries, not deep inside business logic
**Why:** Validation scattered through business logic is inconsistent and gets skipped. Validation at boundaries (API handlers, form processors, message consumers) guarantees every code path is protected.
**Applies when:** Always
**Cross-domain impact:** API & Communication, Data Storage, Error Handling & Resilience

**Practice:** Keep dependencies updated and audit them regularly. Automate with Dependabot, Renovate, or `npm audit` in CI.
**Why:** 70%+ of application vulnerabilities come from transitive dependencies. Automated tooling catches these without developer effort.
**Applies when:** Always
**Cross-domain impact:** CI/CD & Build, Developer Experience, Cost & Scaling

### 11. Developer Experience

**Practice:** Make the project runnable with a single command after clone. Document it in the README, test it in CI.
**Why:** If setup takes more than 5 minutes, new developers (and your future self) waste hours on environment issues. `docker compose up` or `make dev` should get a working local environment.
**Applies when:** Always
**Cross-domain impact:** CI/CD & Build, Testing, Infrastructure & Deployment

**Practice:** Enforce code style with formatters (Prettier, Black, rustfmt) and linters (ESLint, Ruff, Clippy) — never in code review
**Why:** Code style discussions in reviews waste reviewer time and create friction. Automated formatting makes style a non-issue. Run formatters on save and in CI.
**Applies when:** Always
**Cross-domain impact:** CI/CD & Build, Testing

**Practice:** Use TypeScript (or equivalent typed language) for any JavaScript project expected to last more than 3 months
**Why:** Type safety prevents entire categories of runtime errors, enables IDE refactoring, and serves as living documentation. The initial overhead pays back within weeks on any non-trivial project.
**Applies when:** JavaScript/TypeScript projects. Equivalent advice: use type hints in Python, generics in Go 1.18+.
**Cross-domain impact:** Testing (fewer type-error tests needed), Error Handling & Resilience, Security

### 12. Error Handling & Resilience

**Practice:** Implement circuit breakers on all outbound service calls
**Why:** Without circuit breakers, a failing downstream service causes your service to accumulate blocked threads/connections waiting for timeouts. Circuit breakers fail fast after detecting a pattern of failures, preserving your service's capacity.
**Applies when:** Any service calling external APIs or downstream services
**Cross-domain impact:** API & Communication, Performance, Observability

**Practice:** Design for idempotency in all write operations. Use idempotency keys for payment and state-change APIs.
**Why:** Networks are unreliable. Clients retry. Queues redeliver. Without idempotency, retries cause duplicate charges, duplicate records, or inconsistent state. An idempotency key (client-generated UUID stored with the operation) makes retries safe.
**Applies when:** Any write operation that has side effects (payments, emails, state changes)
**Cross-domain impact:** API & Communication, Data Storage, Security

**Practice:** Return actionable error messages to developers, generic messages to end users
**Why:** Stack traces in API responses leak implementation details to attackers. Vague errors ("something went wrong") leave developers unable to debug. Separate the two: structured error codes and details in logs/response metadata, human-friendly messages in the UI.
**Applies when:** Any application with an API or user interface
**Cross-domain impact:** Security, API & Communication, Observability

### 13. Performance

**Practice:** Measure before optimizing. Profile with real data and real traffic patterns.
**Why:** Developer intuition about performance bottlenecks is wrong more often than right. Profiling reveals that the "fast" hash map lookup is actually a cache-miss-heavy operation, or that the "slow" database query is fine but the serialization is the bottleneck.
**Applies when:** Always. Premature optimization is the root of all evil, but so is premature dismissal of performance concerns.
**Cross-domain impact:** Observability, Data Storage, API & Communication

**Practice:** Cache at the right layer. Browser cache for static assets, CDN for regional content, application cache for computed results, database cache for query results.
**Why:** Caching at the wrong layer causes stale data bugs (too aggressive) or cache misses (too conservative). Each layer has different invalidation characteristics and trade-offs.
**Applies when:** Any application serving repeated requests for the same data
**Cross-domain impact:** Data Storage, Infrastructure & Deployment, Cost & Scaling

**Practice:** Set performance budgets and enforce them in CI. Maximum bundle size, maximum LCP, maximum API response time.
**Why:** Performance degrades gradually — no single commit makes it slow, but 200 commits of "just 5KB more" results in a 1MB bundle. Budgets catch regressions before they compound.
**Applies when:** Web applications, mobile applications, latency-sensitive APIs
**Cross-domain impact:** CI/CD & Build, Developer Experience, Accessibility & i18n

### 14. Accessibility & i18n

**Practice:** Use semantic HTML elements (`button`, `nav`, `main`, `article`) instead of styled `div`s
**Why:** Screen readers, keyboard navigation, and browser features (Reader Mode, search) depend on semantic elements. A `div` with an `onClick` handler is invisible to assistive technology and unreachable by keyboard without explicit ARIA and tabindex — which you will forget to add.
**Applies when:** Any web application
**Cross-domain impact:** Performance (semantic elements are lighter than div+ARIA), Testing (semantic elements are easier to query in tests), Framework & Libraries

**Practice:** Extract all user-facing strings from day one, even if you only support one language
**Why:** Retrofitting i18n into a codebase with hardcoded strings is a multi-week project that touches every file. Extracting strings from the start (using `react-intl`, `next-intl`, `i18next`) costs minutes per feature and makes translation a configuration change.
**Applies when:** Any application that might ever need a second language — which is most applications
**Cross-domain impact:** Developer Experience, Framework & Libraries, Testing

**Practice:** Test with keyboard-only navigation and a screen reader. Automated accessibility tools catch only 30-40% of issues.
**Why:** axe-core and Lighthouse catch missing alt text and color contrast, but miss focus traps, illogical tab order, missing announcements, and broken ARIA patterns. Manual testing catches the other 60%.
**Applies when:** Any web application used by external users
**Cross-domain impact:** Testing, Developer Experience

### 15. Cost & Scaling

**Practice:** Architect for 10x your current load, engineer for 1x. Do not build for 1000x.
**Why:** Under-engineering causes outages. Over-engineering causes complexity, slow development, and wasted money. Design your architecture so it CAN scale (stateless services, horizontal scaling capability), but implement only what current load requires.
**Applies when:** Always. The rare exception is if you have a confirmed launch date with guaranteed traffic (Super Bowl ad, Product Hunt launch).
**Cross-domain impact:** Infrastructure & Deployment, Data Storage, Performance

**Practice:** Use managed services for anything that is not your core differentiator
**Why:** Running your own PostgreSQL, Redis, or Kubernetes cluster costs 10-50x more in engineer time than managed equivalents. That time is better spent on features that make your product unique.
**Applies when:** Teams under 50 engineers. Large teams with dedicated platform/SRE teams may benefit from self-managed infrastructure.
**Cross-domain impact:** Infrastructure & Deployment, Developer Experience, Security

**Practice:** Set up cost alerts and budgets before you need them. Review cloud bills monthly.
**Why:** A misconfigured autoscaler, forgotten development environment, or unoptimized query can generate thousands in unexpected charges. Alerts at 50%, 80%, and 100% of expected spend catch these before the bill arrives.
**Applies when:** Any cloud-hosted project
**Cross-domain impact:** Infrastructure & Deployment, Observability, Data Storage

## Response Template

When answering queries, structure the response as:

```markdown
## Best Practices Report: [Query Topic]

### Relevant Domains
[Which of the 15 domains are involved]

### Recommended Practices
1. **Practice:** [What to do]
   **Why:** [What goes wrong if you don't]
   **Applies when:** [Context/conditions]
   **Cross-domain impact:** [Which other domains this affects]

### Gotchas for This Combination
[Non-obvious problems specific to this technology combination]

### Decision Criteria
[If comparing options: structured comparison with trade-offs]

### Sources
[Community patterns, official docs, known production incidents]
```

## Anti-Patterns for This Skill

- **Presenting best practices as absolute rules.** Context matters. "Always use microservices" is wrong for a two-person team. "Never use MongoDB" is wrong for a document-oriented workload. Every practice has a "when" and "when not."
- **Recommending practices that conflict with each other.** "Move fast" and "100% test coverage" are in tension. Acknowledge trade-offs explicitly rather than listing contradictory advice.
- **Ignoring the user's scale, team, and constraints.** Best practices for a 500-engineer organization are anti-patterns for a solo developer. Always calibrate to context.
- **Treating blog posts as authoritative.** Hierarchy: official documentation > battle-tested open-source examples > conference talks with production data > well-reasoned blog posts > forum answers. Never cite a Medium post as definitive.
- **Over-prescribing.** If the user asks about database indexing, give them 3-5 relevant practices — not a 50-item checklist covering every domain. Signal-to-noise ratio matters.
