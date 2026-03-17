---
name: stack-audit
description: Scan any software project against a 15-domain, 7-layer taxonomy to produce a coverage report showing what exists, what's missing, and what's immature. Use before major architecture decisions, onboarding to a new codebase, or planning tech debt work. Focuses on technology coverage and infrastructure maturity, not on understanding application logic or business intent (use brownfield-greenfield for that).
---

# Tech Stack Taxonomy Audit

Systematically evaluate a project's technology choices and infrastructure maturity across 15 domains. Produces a coverage matrix, gap analysis, maturity score, and prioritized recommendations.

Most projects have blind spots. A team might have excellent CI/CD but no observability, or strong testing but zero resilience patterns. This audit makes those gaps visible before they become incidents.

## When to Use

- Onboarding to an unfamiliar codebase — get the full picture fast
- Before major architecture decisions — know what you're building on
- Planning tech debt sprints — prioritize by risk, not gut feel
- Pre-launch readiness check — verify nothing critical is missing
- After a major refactor or migration — confirm nothing was lost
- Periodic health checks (quarterly or after team changes)

## When NOT to Use

- For security-specific audits — use `security-audit` or `web-app-security-audit` instead
- For code quality review — use `design-code-review` or `code-simplifier`
- When you already know the specific gap and just need to fix it

---

## The 15-Domain Taxonomy

Every software project, regardless of scale, touches these 15 domains. Not all need to be at maximum maturity — but all should be consciously addressed.

### 1. Language & Runtime
Programming language, runtime version, build toolchain, compiler settings, language-level features (strict mode, null safety).

**Scan targets:** `package.json`, `tsconfig.json`, `Cargo.toml`, `go.mod`, `requirements.txt`, `pyproject.toml`, `Gemfile`, `.python-version`, `.nvmrc`, `.tool-versions`, `rust-toolchain.toml`

### 2. Framework & Libraries
Core framework, UI library, utility libraries, state management, routing, form handling.

**Scan targets:** `package.json` dependencies, `Cargo.toml`, `go.mod`, `requirements.txt`, `Gemfile`, import statements across source files

### 3. Data Storage
Database, cache layer, file/object storage, search index, data migrations, backup strategy.

**Scan targets:** `docker-compose.yml`, database config files, migration directories, ORM config, `.env` for connection strings, `schema.prisma`, `drizzle.config.ts`, `alembic.ini`

### 4. API & Communication
REST/GraphQL/gRPC endpoints, message queues, webhooks, WebSockets, API versioning, request/response schemas.

**Scan targets:** Route definitions, OpenAPI/Swagger specs, `.proto` files, GraphQL schema files, webhook handlers, WebSocket setup, API client configs

### 5. Authentication & Authorization
Identity provider, session management, RBAC/ABAC, OAuth/OIDC, API key management, MFA.

**Scan targets:** Auth middleware, session config, JWT handling, OAuth provider setup, role/permission definitions, route guards, RLS policies

### 6. Infrastructure & Deployment
Cloud provider, IaC (Terraform/Pulumi/CDK), containers, orchestration, CDN, DNS, domain config, environments (dev/staging/prod).

**Scan targets:** `Dockerfile`, `docker-compose.yml`, `terraform/`, `pulumi/`, `cdk/`, `serverless.yml`, `fly.toml`, `render.yaml`, `vercel.json`, `netlify.toml`, `railway.toml`, Kubernetes manifests

### 7. CI/CD & Build
Pipeline tool, build system, artifact registry, release strategy (semantic versioning, changelogs), branch strategy, deployment automation.

**Scan targets:** `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `bitbucket-pipelines.yml`, `.circleci/`, `Makefile`, build scripts, `release.config.js`, `CHANGELOG.md`

### 8. Testing
Unit, integration, E2E, load, contract testing tools and coverage. Test structure, fixtures, mocking strategy.

**Scan targets:** `jest.config.*`, `vitest.config.*`, `pytest.ini`, `cypress.config.*`, `playwright.config.*`, `*.test.*`, `*.spec.*`, `__tests__/`, `tests/`, `.nycrc`, `coverage/`, `k6/`, `artillery/`

### 9. Observability
Logging, metrics, tracing, alerting, dashboards, error tracking, uptime monitoring.

**Scan targets:** Logger configuration, Sentry/Datadog/New Relic setup, OpenTelemetry config, Prometheus metrics, Grafana dashboards, PagerDuty/OpsGenie integration, health check endpoints

### 10. Security
Dependency scanning, SAST/DAST, secrets management, CSP headers, WAF, vulnerability disclosure policy.

**Scan targets:** `npm audit` config, Snyk/Dependabot/Renovate config, CSP meta tags or headers, `.env` handling, `.gitignore`, secrets in CI/CD, security headers in deployment config

### 11. Developer Experience
Linting, formatting, type checking, local dev environment, documentation, onboarding, editor config, git hooks.

**Scan targets:** `.eslintrc.*`, `.prettierrc.*`, `biome.json`, `.editorconfig`, `lefthook.yml`, `.husky/`, `lint-staged` config, `Makefile`, `docker-compose.yml` (dev services), `CONTRIBUTING.md`, `docs/`

### 12. Error Handling & Resilience
Circuit breakers, retries with backoff, fallbacks, graceful degradation, health checks, timeout configuration, dead letter queues.

**Scan targets:** Error boundary components, retry logic, circuit breaker libraries, health check endpoints, timeout configs, fallback UI, error logging patterns

### 13. Performance
Bundling, code splitting, caching strategy (HTTP, application, CDN), lazy loading, SSR/SSG, image optimization, database query optimization.

**Scan targets:** Webpack/Vite/esbuild config, bundle analysis, `Cache-Control` headers, CDN config, lazy/dynamic imports, SSR/SSG config, database indexes, query plans, lighthouse config

### 14. Accessibility & i18n
Screen reader support, WCAG compliance level, keyboard navigation, translation system, RTL support, locale handling.

**Scan targets:** ARIA attributes, `a11y` lint rules, `axe-core` config, `i18next`/`react-intl`/`vue-i18n` setup, translation files, `lang` attributes, focus management patterns

### 15. Cost & Scaling
Auto-scaling config, cost monitoring/alerts, resource limits, capacity planning, usage quotas, cost optimization (reserved instances, spot instances).

**Scan targets:** Auto-scaling policies, cloud billing alerts, resource requests/limits in Kubernetes, cost monitoring tools (Infracost, AWS Cost Explorer), usage-based pricing config, load balancer config

---

## The 7 Layers (per domain)

For each of the 15 domains, assess across these 7 layers to determine true maturity:

| Layer | Question | Possible Values |
|-------|----------|-----------------|
| **1. Exists** | Is there any tooling or config for this domain? | Yes / No / Partial |
| **2. Tool Choice** | What specific tool or service is used? | Name the tool, or "None" |
| **3. Configuration** | Is it configured beyond defaults? | Default / Custom / Tuned |
| **4. Integration** | Does it connect to other domains properly? | Isolated / Partial / Integrated |
| **5. Automation** | Is it automated (CI/CD, scripts) or manual? | Manual / Scripted / Fully Automated |
| **6. Documentation** | Is the choice and config documented? | None / Inline / Dedicated |
| **7. Maturity** | Overall maturity rating for this domain | None / Ad-hoc / Defined / Managed / Optimized |

**Maturity definitions:**
- **None** — Domain not addressed at all
- **Ad-hoc** — Something exists but it's inconsistent, incomplete, or accidental
- **Defined** — Deliberate choice made, basic configuration in place
- **Managed** — Configured, integrated with other domains, monitored
- **Optimized** — Automated, documented, continuously improved, team-wide adoption

---

## Process

### Step 1: Scan the Project

Read and analyze these file categories:

```
# Package/dependency manifests
package.json, Cargo.toml, go.mod, requirements.txt, pyproject.toml, Gemfile, pom.xml, build.gradle

# Configuration files
tsconfig.json, .eslintrc.*, .prettierrc.*, biome.json, jest.config.*, vitest.config.*

# Infrastructure files
Dockerfile, docker-compose.yml, terraform/, pulumi/, serverless.yml, fly.toml, vercel.json, netlify.toml

# CI/CD configs
.github/workflows/*.yml, .gitlab-ci.yml, Jenkinsfile, bitbucket-pipelines.yml

# Documentation
README.md, docs/, CONTRIBUTING.md, CHANGELOG.md, ADRs

# Source patterns (sample key directories)
src/, lib/, app/, pages/, components/, middleware/, routes/, migrations/
```

For each file found, extract: tools used, versions pinned or floating, configuration depth, connections to other domains.

### Step 2: Map Findings to the Taxonomy

For each of the 15 domains, fill in all 7 layers based on evidence found in the scan. Do not guess — mark "Unknown" if evidence is insufficient and note what would need manual verification.

### Step 3: Produce the Coverage Matrix

Build the full 15x7 matrix. Use icons for quick scanning:
- Exists: Y / N / ~
- Configuration: D (default) / C (custom) / T (tuned)
- Automation: M (manual) / S (scripted) / A (automated)
- Documentation: 0 / 1 / 2
- Maturity: 0-4 scale (None=0, Ad-hoc=1, Defined=2, Managed=3, Optimized=4)

### Step 4: Identify Gaps and Risks

Flag domains that are:
- **Missing entirely** (Exists = No) — severity depends on project type
- **Present but immature** (Maturity = Ad-hoc) — often worse than missing because it creates false confidence
- **Isolated** (Integration = Isolated) — tools that don't talk to each other waste effort
- **Undocumented** (Documentation = None) — bus factor risk
- **Manual** (Automation = Manual) — toil that compounds over time

### Step 5: Rate Overall Project Maturity

Calculate a maturity score (0-100):

```
Score = (sum of all domain maturity ratings) / (15 domains x 4 max) x 100

Where maturity ratings are:
  None = 0, Ad-hoc = 1, Defined = 2, Managed = 3, Optimized = 4
```

| Score Range | Rating | Interpretation |
|-------------|--------|----------------|
| 0-20 | Prototype | Minimal infrastructure, acceptable for experiments |
| 21-40 | Early | Key gaps exist, not ready for production traffic |
| 41-60 | Developing | Core domains covered, gaps in supporting domains |
| 61-80 | Mature | Most domains addressed, focus on optimization |
| 81-100 | Optimized | Comprehensive coverage, continuous improvement |

---

## Deliverable Template

```markdown
# Tech Stack Audit Report
**Project:** [name]
**Date:** [date]
**Auditor:** [name]

## Executive Summary
[2-3 sentences: overall maturity rating, biggest strengths, most critical gaps]

**Maturity Score: XX/100 — [Rating]**

## Coverage Matrix

| Domain | Exists | Tool | Config | Integration | Automation | Docs | Maturity |
|--------|--------|------|--------|-------------|------------|------|----------|
| 1. Language & Runtime | Y | Node 20 + TS 5.3 | C | Integrated | A | 1 | Defined |
| 2. Framework & Libraries | Y | Next.js 14 | C | Integrated | A | 1 | Managed |
| 3. Data Storage | Y | PostgreSQL + Redis | C | Integrated | S | 1 | Managed |
| 4. API & Communication | Y | REST + tRPC | C | Partial | S | 0 | Defined |
| 5. Auth & AuthZ | Y | NextAuth.js | D | Partial | M | 0 | Ad-hoc |
| 6. Infrastructure | ~ | Vercel | D | Isolated | A | 0 | Ad-hoc |
| 7. CI/CD & Build | Y | GitHub Actions | C | Integrated | A | 1 | Managed |
| 8. Testing | ~ | Vitest (unit only) | D | Isolated | S | 0 | Ad-hoc |
| 9. Observability | N | — | — | — | — | — | None |
| 10. Security | ~ | npm audit only | D | Isolated | M | 0 | Ad-hoc |
| 11. Developer Experience | Y | ESLint + Prettier | C | Integrated | A | 1 | Managed |
| 12. Error Handling | ~ | React Error Boundary | D | Isolated | M | 0 | Ad-hoc |
| 13. Performance | ~ | Next.js defaults | D | Partial | M | 0 | Ad-hoc |
| 14. Accessibility & i18n | N | — | — | — | — | — | None |
| 15. Cost & Scaling | N | — | — | — | — | — | None |

## Gap Analysis

### Critical Gaps (address before production)
| Domain | Gap | Severity | Risk |
|--------|-----|----------|------|
| Observability | No logging, metrics, or error tracking | HIGH | Blind to production issues, slow incident response |
| Auth & AuthZ | Default NextAuth config, no RBAC | HIGH | Potential unauthorized access |
| Security | No SAST, no secrets management, no CSP | HIGH | Vulnerable to common attacks |

### Important Gaps (address within next quarter)
| Domain | Gap | Severity | Risk |
|--------|-----|----------|------|
| Testing | No integration or E2E tests | MEDIUM | Regressions caught late |
| Error Handling | No retry logic, no circuit breakers | MEDIUM | Cascade failures under load |
| Accessibility | No a11y testing or ARIA patterns | MEDIUM | Excludes users, legal risk |

### Nice-to-Have (plan for future)
| Domain | Gap | Severity | Risk |
|--------|-----|----------|------|
| Cost & Scaling | No auto-scaling or cost monitoring | LOW | Surprise bills, manual scaling |
| Performance | No bundle analysis or caching strategy | LOW | Suboptimal load times |

## Recommendations (prioritized by risk)

### Immediate (this sprint)
1. **Add error tracking** — integrate Sentry or equivalent. Connects observability to error handling.
2. **Configure CSP headers** — add Content-Security-Policy to deployment config.
3. **Set up RBAC** — define roles and enforce in middleware, not just UI.

### Short-term (next 2-4 weeks)
4. **Add E2E tests** — cover critical user flows with Playwright.
5. **Set up structured logging** — use pino/winston with correlation IDs.
6. **Add dependency scanning** — enable Dependabot or Renovate.

### Medium-term (next quarter)
7. **Implement retry/circuit breaker patterns** for external service calls.
8. **Add accessibility testing** — axe-core in CI, manual screen reader testing.
9. **Set up cost monitoring** — billing alerts at 50%, 80%, 100% of budget.

## Stack Diagram
[Optional: dependency graph showing how domains connect]

## Notes
[Caveats, assumptions, areas that need manual verification]
```

---

## Calibrating Expectations by Project Type

Not every project needs all 15 domains at Optimized. Use this guide to set appropriate expectations:

| Project Type | Must Be Managed+ | Should Be Defined+ | Can Be Ad-hoc/None |
|-------------|-------------------|---------------------|---------------------|
| **Solo side project** | 1, 2, 8 | 3, 7, 11 | 5, 6, 9, 10, 12-15 |
| **Startup MVP** | 1, 2, 3, 5, 7 | 4, 6, 8, 10, 11 | 9, 12, 13, 14, 15 |
| **Production SaaS** | 1-11 | 12, 13 | 14, 15 (depends on market) |
| **Enterprise platform** | 1-13 | 14, 15 | None — all should be Defined+ |
| **Open source library** | 1, 2, 7, 8, 11 | 10 | 3-6, 9, 12-15 |

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | What to Do Instead |
|-------------|----------------|-------------------|
| Auditing only `package.json` | Misses IaC, CI/CD, deployment config, documentation, and runtime configuration | Scan all file categories listed in Step 1 |
| Treating "exists" as "mature" | Having Jest installed doesn't mean good test coverage; having a Dockerfile doesn't mean proper container security | Assess all 7 layers for each domain |
| Recommending tools without context | Suggesting Kubernetes for a solo dev project wastes time and adds complexity | Use the calibration table to set appropriate expectations |
| Over-engineering the stack | Not every project needs all 15 domains at Optimized — some domains are irrelevant for certain project types | Match recommendations to project type and team size |
| Rating based on tool count | More tools does not mean more mature — three overlapping linters is worse than one well-configured one | Rate based on integration, automation, and actual effectiveness |
| Ignoring the "documentation" layer | Undocumented choices create bus factor risk and slow onboarding | Flag undocumented domains even if tooling is solid |
| Auditing in isolation | A stack audit without action items is just a report that gets filed and forgotten | Always end with prioritized, actionable recommendations |
| Conflating this with security audit | This audit covers breadth across 15 domains; security depth requires a dedicated security audit skill | Use this for coverage overview, `security-audit` for depth |
