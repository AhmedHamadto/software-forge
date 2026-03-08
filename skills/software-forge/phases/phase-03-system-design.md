# Phase 3: System Design + Security-by-Design

**Applies to:** Full-Stack, Voice, Edge/IoT+ML, Mobile (with backend)
**Invoke:** `/ddia-design`
**Output:** System design doc at `docs/plans/YYYY-MM-DD-<topic>-system-design.md`

### Security-by-Design Injection Points

**IMPORTANT: Before invoking `/ddia-design`, write down the injection points below as a checklist. At each DDIA phase transition, check the list before proceeding. Do NOT rely on memory — the DDIA skill's own flow will consume your attention.**

While running `/ddia-design`, inject these additional questions at three phases:

**At DDIA Phase 2 (Storage & Data Model):**
- What access control model per table/collection? (RLS, RBAC, ABAC)
- Which fields contain PII? Encryption at rest strategy?
- What are the access patterns per role? (admin sees all, user sees own)
- Audit logging: which mutations need an audit trail?

**At DDIA Phase 3 (Data Flow & Integration):**
- What auth mechanism at each boundary? (JWT, API key, mTLS, webhook signature)
- How are secrets managed? (Environment vars, Vault, Secrets Manager)
- Transport security per channel? (TLS, mTLS for service-to-service)
- Which data crosses trust boundaries? What validation is needed at each?

**At DDIA Phase 5 (Correctness & Cross-Cutting):**
- What is the threat model? (STRIDE per component)
- Input validation strategy per boundary? (Zod schemas, parameterized queries)
- Rate limiting per endpoint tier? (public vs authenticated vs internal)
- What happens if a credential is compromised? Rotation and revocation plan?

### Accessibility-by-Design Injection Point (Web, Mobile, Desktop)

Inject at **DDIA Phase 8 (Frontend & Derived Views)** for any project with a UI:

- What WCAG level are you targeting? (A, AA, AAA — AA is the standard for most products)
- Color contrast: do all text/background combinations meet the target ratio? (4.5:1 for AA normal text, 3:1 for large text)
- Keyboard navigation: can every interactive element be reached and operated without a mouse?
- Screen reader strategy: what semantic HTML / ARIA roles are needed? What's the heading hierarchy?
- Motion: do animations respect `prefers-reduced-motion`? Are there alternatives for motion-dependent interactions?
- Touch targets: are all interactive elements at least 44x44pt (iOS) / 48x48dp (Android)?

These questions are proactive — catching contrast issues and keyboard traps during design costs minutes; fixing them after implementation costs hours.

### Deliverable

The standard DDIA design summary doc, with security and accessibility decisions integrated into each relevant phase (not as a separate section).

Append the following to the design doc:

```markdown
### Decision Log — Phase 3: System Design + Security
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
