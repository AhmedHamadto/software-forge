# Phase 9: Infrastructure Design

**Applies to:** Edge/IoT+ML, and any project with self-managed cloud infrastructure
**Source:** *Infrastructure as Code* (Kief Morris)
**Output:** Infrastructure section appended to system design doc

### Questions to Ask

1. **IaC Tool & Module Structure:**
   - What IaC tool? (Terraform, Pulumi, CDK, CloudFormation)
   - Module boundaries — which resources belong together?
   - Shared vs environment-specific modules?

2. **State Management:**
   - Remote state backend? (S3, Terraform Cloud, Azure Blob)
   - State locking mechanism?
   - State file per environment or per module?

3. **Environment Strategy:**
   - How many environments? (dev, staging, prod)
   - How do changes promote? (manual apply, CI/CD pipeline, GitOps)
   - Blast radius of a bad apply — what's the worst case?

4. **CI/CD Pipeline:**
   - Plan on PR, apply on merge?
   - Who approves infrastructure changes?
   - Rollback strategy for infrastructure?

5. **IaC Testing:**
   - Static analysis? (tfsec, Checkov, OPA)
   - Plan validation? (terraform plan diff review)
   - Integration tests? (test environment that mirrors prod)

6. **Secrets Management:**
   - Where do secrets live? (Vault, Secrets Manager, SSM Parameter Store)
   - Rotation schedule?
   - Emergency revocation process?

7. **Cost Estimation:**
   - What's the compute cost per unit of work? (per API call, per inference, per voice minute)
   - What are the third-party API costs at projected volume? (Twilio per-minute, Deepgram per-hour, Stripe per-transaction, S3 per-GB)
   - What's the storage growth projection? (GB/month now, in 6 months, in 2 years)
   - What's the monthly burn at current scale? At 10x scale?
   - Where are the cost cliffs? (Aurora serverless scaling tiers, Lambda invocation thresholds, data transfer costs)
   - Is there a cost ceiling / budget constraint?
   - What's the cost-per-user or cost-per-unit-of-value? (Does the unit economics work?)

### Deliverable

```markdown
## Infrastructure Design

### IaC Structure
- Tool: [Terraform/Pulumi/etc.]
- Modules: [List with responsibilities]
- State: [Backend, locking, per-environment strategy]

### Environment Promotion
- Environments: [List]
- Promotion Flow: [PR -> plan -> review -> apply]
- Rollback: [Strategy]

### Secrets
- Store: [Tool]
- Rotation: [Schedule]
- Emergency Revocation: [Process]

### Cost Estimation
| Resource | Unit Cost | Current Volume | Monthly Cost | At 10x |
|----------|-----------|----------------|-------------|--------|
| [Compute] | [$/unit] | [units/month] | [$] | [$] |
| [Storage] | [$/GB] | [GB] | [$] | [$] |
| [Third-party API] | [$/call] | [calls/month] | [$] | [$] |
| **Total** | | | **[$]** | **[$]** |

Cost Ceiling: [Budget constraint if any]
Cost-per-User: [$/user/month at projected scale]

### Decision Log — Phase 9: Infrastructure
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
