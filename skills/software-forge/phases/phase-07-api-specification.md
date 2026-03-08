# Phase 7: API Specification

**Applies to:** Full-Stack, Voice, Edge/IoT+ML, Mobile (with backend)
**Output:** API spec appended to system design doc or separate doc

### Process

For **each system boundary** identified in Phase 3 (Data Flow):

1. **List all endpoints/contracts:**
   - REST endpoints (method, path)
   - Event schemas (SQS messages, EventBridge events)
   - Webhook contracts (incoming from third parties)
   - Device protocols (MQTT topics, IoT shadow schemas)
   - Tool interfaces (voice agent tools, function calling schemas)

2. **For each endpoint, define:**
   - Auth requirement (JWT, API key, service role, webhook signature, mTLS)
   - Request schema (with types, required/optional, validation rules)
   - Response schema (success + error shapes)
   - Rate limiting tier (public, authenticated, internal, service-to-service)
   - Idempotency (safe to retry? idempotency key?)

3. **Error format standard:**
   - Agree on ONE error shape across all APIs
   - Include: status code, error code, human message, details object

### Deliverable

```markdown
## API Specification

### Error Format
{ status, code, message, details }

### Endpoints

#### [Boundary Name]
| Method | Path | Auth | Rate Limit | Idempotent |
|--------|------|------|------------|------------|
| POST | /api/example | JWT | 100/min | Yes (key) |

**Request:** { ... }
**Response:** { ... }
**Errors:** 400 (validation), 401 (auth), 429 (rate limit)

### Decision Log — Phase 7: API Specification
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
