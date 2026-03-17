# Phase 13: Cost Analysis & Risk Assessment

**Applies to:** All project types (after all design phases complete)
**Input:** All design docs produced in Phases 1-12
**Output:** Cost & risk section appended to design doc

### Purpose

Gate between design and implementation. Before committing engineering effort, verify that the designed system is feasible, affordable, and that risks are identified early enough to influence the plan.

### Cost Analysis

1. **Infrastructure Costs:**
   - Compute: How many instances/containers? What size? Estimated monthly cost?
   - Storage: How much data? Growth rate? Hot vs cold storage split?
   - Network: Data transfer between services, regions, CDN egress?
   - Managed services: Database, cache, queue, search — per-unit pricing?

2. **Third-Party API Costs:**
   - Per-call pricing for each external API (Stripe, OpenAI, Twilio, etc.)
   - Expected call volume at launch and at 10x scale
   - Rate limits that could become bottlenecks
   - Fallback costs if a provider goes down or changes pricing

3. **Operational Costs:**
   - Monitoring and observability tooling (Datadog, New Relic, etc.)
   - CI/CD pipeline costs (build minutes, artifact storage)
   - Domain, certificates, email services

4. **Unit Economics:**
   - Cost per user/request/transaction at current design
   - Does it scale linearly, sub-linearly, or super-linearly?
   - At what scale does this design become uneconomical?

### Risk Assessment

1. **Technical Risks:**
   - New technology the team hasn't used before
   - Scaling unknowns (will this design handle 10x traffic?)
   - Single points of failure identified in system design
   - Data migration complexity (if modifying an existing system)

2. **Dependency Risks:**
   - External services with no SLA or poor reliability history
   - Open-source libraries that are unmaintained or pre-1.0
   - Vendor lock-in — how hard is it to switch providers?

3. **Timeline Risks:**
   - Components with uncertain scope (ML model accuracy, hardware integration)
   - Sequential dependencies that block parallel work
   - Integration points that require coordination with external teams

4. **Security & Compliance Risks:**
   - Data handling requirements (PII, HIPAA, GDPR, PCI)
   - Regulatory approvals needed before launch
   - Audit trail requirements

### Decision Point

After completing the analysis, present a summary:

```markdown
## Cost & Risk Assessment

### Estimated Costs
| Category | Monthly (Launch) | Monthly (10x) |
|----------|-----------------|---------------|
| Infrastructure | $X | $Y |
| Third-Party APIs | $X | $Y |
| Operational | $X | $Y |
| **Total** | **$X** | **$Y** |

### Risk Register
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [description] | [low/med/high] | [low/med/high] | [strategy] |

### Go/No-Go
[Proceed / Proceed with mitigations / Redesign required]
```

### Go/No-Go Decision Gate

If the verdict is **Redesign Required:**
1. **STOP.** Do not proceed to Phase 14.
2. Identify which design phases need revisiting based on the failure reason:
   - Cost too high → revisit Phase 9 (Infrastructure) or Phase 3 (System Design)
   - Risk unacceptable → revisit Phase 4 (Resilience) or Phase 3 (System Design)
   - Fundamental scope issue → revisit Phase 1 (Brainstorming)
3. Present the loop-back recommendation to the user for approval.
4. Return to the identified phase and re-execute from there.
5. Re-run Phase 13 after the redesign to verify the issues are resolved.

Append the following to the design doc:

```markdown
### Decision Log — Phase 13: Cost Analysis & Risk
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
