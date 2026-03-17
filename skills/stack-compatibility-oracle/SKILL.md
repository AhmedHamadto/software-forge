---
name: stack-compatibility-oracle
description: Pre-flight architecture dependency check — maps the Tech Stack Taxonomy (15 domains) and flags known incompatibilities BEFORE code gets written. Use when evaluating a proposed tech stack for a new project or major feature.
---

# Stack Compatibility Oracle

A dependency resolver for **architectural decisions**, not packages. Before building, check whether the chosen technologies across layers actually work well together. `npm install` succeeding does not mean the architecture is sound.

## When to Use

- Starting a new project and evaluating technology choices
- Adding a major component that introduces a new technology layer
- Migrating from one technology to another (e.g., switching databases, frameworks)
- Reviewing a proposed stack from a brainstorming or design phase
- Sanity-checking a client's or team's pre-selected stack before committing to it

## When NOT to Use

- Adding a small library within an already-decided stack
- Pure package version compatibility (use dependency managers for that)
- Evaluating a single technology in isolation (this skill checks combinations)

## Process

Work through these four stages in order:

### 1. Collect

Gather the proposed tech stack. Sources:
- Design doc from `/brainstorming` or `/ddia-design`
- User's direct input ("we want Next.js + Supabase + Tailwind")
- Existing project files (package.json, Dockerfile, IaC configs)

Map each choice to the 15-domain taxonomy:

| # | Domain | Example Choices |
|---|--------|----------------|
| 1 | Language | TypeScript, Python, Go, Rust |
| 2 | Frontend Framework | React, Vue, Svelte, SwiftUI |
| 3 | CSS / Styling | Tailwind, CSS Modules, Styled Components |
| 4 | UI Component Library | shadcn/ui, MUI, Chakra, Radix |
| 5 | Backend Framework | Next.js, FastAPI, Express, Django |
| 6 | API Style | REST, GraphQL, gRPC, tRPC |
| 7 | Database | PostgreSQL, MongoDB, DynamoDB, SQLite |
| 8 | ORM / Data Access | Prisma, Drizzle, SQLAlchemy, TypeORM |
| 9 | Auth | Supabase Auth, Clerk, Auth0, NextAuth |
| 10 | Hosting / Deployment | Vercel, AWS, Fly.io, Railway |
| 11 | Infrastructure as Code | Terraform, Pulumi, CDK, SST |
| 12 | CI/CD | GitHub Actions, GitLab CI, CircleCI |
| 13 | Monitoring / Observability | Sentry, Datadog, Grafana, OpenTelemetry |
| 14 | Caching / Queues | Redis, BullMQ, SQS, RabbitMQ |
| 15 | Testing | Vitest, Pytest, Playwright, Cypress |

Not every project fills all 15 domains. Mark unused domains as "N/A" and move on.

### 2. Map

Plot each choice into the taxonomy table. Identify any domains with multiple competing choices (red flag) or domains left blank that probably shouldn't be (gap).

### 3. Check

Run compatibility checks across all five dimensions (see below). For each technology pair that interacts, assign a severity level.

### 4. Report

Produce the compatibility report (see Deliverable section).

---

## Compatibility Dimensions

### Dimension 1: Runtime Compatibility

Does the technology actually work at runtime with its neighbors?

- Does the ORM support the chosen database? (e.g., Prisma does not support DynamoDB)
- Does the auth provider have an SDK for the framework? (e.g., Clerk has first-class Next.js support but limited Django support)
- Does the testing framework support the UI library? (e.g., React Testing Library does not test Vue components)
- Does the SSR framework support the chosen CSS solution? (e.g., server components + CSS-in-JS runtime libraries conflict)
- Does the API style have proper tooling for the language? (e.g., gRPC + browser JavaScript requires grpc-web proxy)

### Dimension 2: Deployment Compatibility

Does the stack fit the deployment target?

- Does the framework support the deployment model? (e.g., Django on edge functions is a poor fit)
- Does the database support the scaling model? (e.g., SQLite does not support horizontal scaling)
- Does the IaC tool support the cloud provider? (e.g., CDK is AWS-only)
- Does the CI/CD tool integrate with the artifact registry and deployment target?
- Does the framework's build output match what the hosting platform expects? (e.g., static export vs. server-rendered)

### Dimension 3: Integration Compatibility

Do the tools connect to each other without excessive glue code?

- Does the message queue have client libraries for the language?
- Does the monitoring tool support the runtime? (e.g., Datadog APM supports Node.js and Python but not all runtimes equally)
- Does the CDN support the framework's output format?
- Does the auth provider support the API style? (e.g., API key auth with GraphQL subscriptions over WebSockets)
- Do the chosen tools have maintained integrations? (e.g., official plugins vs. community-maintained adapters)

### Dimension 4: Scale Compatibility

Will this stack hold up at the expected load?

- Does the database handle the expected write volume? (e.g., SQLite under high concurrent writes)
- Does the cache layer support the data structure needs? (e.g., need sorted sets but chose Memcached)
- Does the deployment model support the latency requirements? (e.g., cold starts on serverless for real-time endpoints)
- Does the cost model work at projected scale? (e.g., serverless per-invocation pricing at millions of requests)
- Does the architecture support the growth trajectory? (e.g., monolith with shared state blocking future horizontal scaling)

### Dimension 5: Team Compatibility

Can the team actually build and maintain this stack?

- Does the team have experience with this combination?
- Is the maintenance burden manageable? (count distinct technologies — each one is a learning curve and dependency)
- Are there hiring implications? (niche stack = harder to hire, e.g., Haskell + Nix + CockroachDB)
- Is the community large enough for troubleshooting? (obscure framework + obscure ORM = you are alone)
- Does the stack match the team's velocity goals? (overengineered stack for an MVP burns time)

---

## Severity Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **BLOCKER** | These technologies cannot work together | Must swap one or both |
| **WARNING** | Known friction, workarounds exist but add complexity | Document the workaround, consider alternatives |
| **INFO** | Suboptimal but functional, better options exist | Note for future improvement |
| **OK** | Well-tested combination, community-proven | No action needed |

---

## Knowledge Model

The oracle uses a **hybrid** approach:

1. **Curated base** — Known incompatibilities and proven combos listed below
2. **Claude reasoning** — For unlisted combinations, reason from documentation, community knowledge, and architectural principles
3. **User experience** — Incorporate the team's past experience, existing infrastructure, and constraints

When encountering an unlisted combination, state your confidence level and reasoning. Do not present uncertain assessments with the same confidence as curated entries.

---

## Known Incompatibilities Reference

These are concrete, documented incompatibilities. Use as a starting checklist:

| # | Tech A | Tech B | Severity | Issue |
|---|--------|--------|----------|-------|
| 1 | Prisma | DynamoDB | BLOCKER | Prisma does not support DynamoDB. Use DynamoDB SDK or ElectroDB. |
| 2 | React Server Components | Styled Components | BLOCKER | CSS-in-JS runtime libraries cannot run in server components. Use CSS Modules or Tailwind. |
| 3 | React Server Components | Emotion (runtime) | BLOCKER | Same runtime CSS-in-JS conflict. Emotion's non-runtime extraction mode is experimental. |
| 4 | SQLite | Horizontal scaling | BLOCKER | SQLite is single-writer. Cannot scale horizontally without LiteFS/Turso (adds complexity). |
| 5 | Django | Vercel (serverless) | WARNING | Django's process model is a poor fit for serverless cold starts. Use containers or Railway. |
| 6 | gRPC | Browser (direct) | WARNING | Browsers cannot make gRPC calls directly. Requires grpc-web proxy or Connect protocol. |
| 7 | AWS CDK | GCP / Azure | BLOCKER | CDK is AWS-only. Use Terraform or Pulumi for multi-cloud. |
| 8 | Next.js App Router | Express middleware | WARNING | App Router uses its own middleware system. Express middleware patterns do not transfer directly. |
| 9 | MongoDB | Complex joins | WARNING | MongoDB lacks native joins. $lookup is limited. If your data model is heavily relational, use PostgreSQL. |
| 10 | Prisma | Edge runtimes | WARNING | Prisma requires a query engine binary. Edge deployments need Prisma Accelerate or Drizzle as an alternative. |
| 11 | GraphQL | File uploads | WARNING | GraphQL has no native file upload spec. Requires multipart request spec or separate REST endpoint. |
| 12 | Serverless functions | WebSockets | WARNING | Stateless functions cannot hold persistent connections. Use dedicated WebSocket services (Ably, Pusher, AWS API Gateway WebSocket). |
| 13 | Tailwind CSS | Component library theming | INFO | Tailwind's utility-first approach can conflict with component libraries that use their own design tokens. shadcn/ui is built for Tailwind; MUI is not. |
| 14 | TypeORM | Modern TypeScript | WARNING | TypeORM's decorator-based approach has stale maintenance. Drizzle or Prisma are more actively maintained. |
| 15 | Redis | Persistent storage | WARNING | Redis is primarily in-memory. Using it as a primary database risks data loss without AOF/RDB persistence configured. |
| 16 | Next.js | Python backend | INFO | Using Next.js as a frontend with a separate Python backend is fine but negates Next.js's full-stack capabilities. Consider whether you need Next.js or a lighter React setup. |
| 17 | Cypress | Unit testing | INFO | Cypress is an E2E tool. Using it for unit tests is slow and overcomplicated. Use Vitest or Jest for unit/integration tests. |
| 18 | Supabase Auth | Non-Supabase DB | WARNING | Supabase Auth is tightly coupled to Supabase's PostgreSQL. Using it with a different database requires custom session management. |
| 19 | React Native | Web CSS frameworks | BLOCKER | React Native does not use CSS. Tailwind, Bootstrap, and other web CSS frameworks do not work. Use NativeWind for Tailwind-like syntax. |
| 20 | Terraform | Niche cloud providers | WARNING | Terraform provider quality varies. Major clouds have mature providers; niche platforms may have incomplete or community-only providers. |

---

## Proven Stacks Reference

These combinations are battle-tested and well-documented. When a team has no strong preferences, these are safe recommendations:

### 1. The Vercel Full-Stack (TypeScript Web Apps)
Next.js + TypeScript + Tailwind + shadcn/ui + Prisma/Drizzle + PostgreSQL + Vercel + NextAuth/Clerk

**Why it works:** Tight integration across all layers. Vercel optimizes for Next.js. Prisma/Drizzle handle PostgreSQL well. shadcn/ui is built for Tailwind. Massive community.

### 2. The Django Monolith (Python Web Apps)
Django + Python + HTMX + PostgreSQL + Redis + Celery + Docker + AWS/Railway

**Why it works:** Django's batteries-included philosophy means fewer integration decisions. HTMX avoids a separate frontend framework. Celery + Redis is the standard async task pattern.

### 3. The Go Microservice (High-Performance APIs)
Go + Chi/Echo + PostgreSQL + gRPC (internal) + REST (external) + Docker + Kubernetes + Prometheus + Grafana

**Why it works:** Go's standard library is strong. Chi/Echo are thin routers. gRPC is native to Go. Prometheus client is first-class. Kubernetes handles Go binaries efficiently.

### 4. The Supabase Startup (Rapid MVP)
Next.js/React + Supabase (Auth + DB + Storage + Realtime) + Tailwind + Vercel

**Why it works:** Supabase bundles auth, database, storage, and realtime into one platform. Minimal integration decisions. Fast time-to-market. Good for prototypes and MVPs.

### 5. The AWS Enterprise (Large-Scale Systems)
TypeScript/Python + CDK + Lambda + API Gateway + DynamoDB/Aurora + SQS + CloudWatch + CodePipeline

**Why it works:** All AWS-native, single vendor. CDK provides type-safe IaC. Scales to zero with Lambda. Enterprise support available. Well-documented patterns.

### 6. The Mobile Full-Stack (React Native Apps)
React Native + Expo + TypeScript + NativeWind + tRPC + PostgreSQL + Supabase/Firebase + EAS Build

**Why it works:** Expo simplifies React Native. NativeWind brings Tailwind patterns to mobile. tRPC gives end-to-end type safety. EAS handles builds and submissions.

---

## Deliverable: Compatibility Report

Produce this report after running all checks:

```markdown
# Stack Compatibility Report

**Project:** [name]
**Date:** [date]
**Verdict:** GO | GO WITH CAVEATS | NO-GO

## Stack Map

| Domain | Choice | Notes |
|--------|--------|-------|
| Language | | |
| Frontend Framework | | |
| CSS / Styling | | |
| UI Component Library | | |
| Backend Framework | | |
| API Style | | |
| Database | | |
| ORM / Data Access | | |
| Auth | | |
| Hosting / Deployment | | |
| Infrastructure as Code | | |
| CI/CD | | |
| Monitoring | | |
| Caching / Queues | | |
| Testing | | |

## Compatibility Matrix

| Tech A | Tech B | Dimension | Status | Notes |
|--------|--------|-----------|--------|-------|
| | | Runtime | OK/WARNING/BLOCKER/INFO | |

## Risk Items

### BLOCKERS
<!-- Must be resolved before proceeding -->

### WARNINGS
<!-- Should be addressed, workarounds documented -->

### INFO
<!-- Noted for future consideration -->

## Recommended Alternatives

| Current Choice | Suggested Alternative | Reason |
|---------------|----------------------|--------|
| | | |

## Final Verdict

[GO / GO WITH CAVEATS / NO-GO]

**Rationale:** [1-2 sentence summary]

**Conditions (if GO WITH CAVEATS):**
- [ ] [condition 1]
- [ ] [condition 2]
```

---

## Verdict Criteria

- **GO** — No blockers, no more than 2 warnings, all warnings have documented workarounds
- **GO WITH CAVEATS** — No blockers, warnings present with workarounds, conditions listed that must be met
- **NO-GO** — One or more blockers exist, or warnings accumulate to unacceptable risk

---

## Anti-Patterns

**Only checking package-level compatibility.** `npm install` working does not mean the architecture is sound. Prisma installs fine alongside DynamoDB — it just cannot connect to it.

**Ignoring team experience.** A technically perfect stack the team cannot maintain is worse than a "boring" stack they know well. Always weigh Dimension 5.

**Recommending complete rewrites for minor incompatibilities.** If the team has a working Django app and one WARNING-level issue, do not suggest rewriting in Next.js. Suggest targeted fixes.

**Treating all warnings as blockers.** Warnings mean friction, not impossibility. Document the workaround and move on. Only blockers require technology swaps.

**Not considering migration cost when suggesting alternatives.** Swapping a database on a running system is not the same as choosing one for a greenfield project. Factor in migration effort and risk.

**Checking only adjacent layers.** Frontend-backend compatibility is obvious. Check diagonal relationships too: does the monitoring tool work with the deployment target? Does the testing framework support the API style?

**Rubber-stamping popular stacks.** Popular does not mean compatible for your use case. Next.js + MongoDB is popular but painful if your data is relational. Evaluate against the actual requirements.
