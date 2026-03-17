# Phase 8: Voice Agent Prompt Design

**Applies to:** Voice Agent
**Invoke:** `/voice-agent-prompt`
**Output:** Voice prompt doc at `docs/plans/YYYY-MM-DD-<topic>-voice-prompts.md`

### Questions to Ask

**Agent Persona & Scope:**
1. What is the agent's role? (receptionist, support agent, sales, scheduling, triage)
2. What persona traits? (friendly, professional, casual, formal)
3. What is the business domain? (restaurant, clinic, SaaS support, logistics)
4. What languages must the agent support? (primary + fallback)
5. What is the agent's authority? (can book, can cancel, can escalate, can refund)

**Conversation Architecture:**
6. What is the call flow? (greeting → intent detection → action → confirmation → close)
7. What are the primary intents? (book appointment, place order, get info, file complaint)
8. How does the agent handle multi-turn context? (stateful tool calls, session memory)
9. What are the escalation triggers? (caller asks for human, unresolvable issue, emotional distress)
10. How are interruptions handled? (allow mid-sentence, wait for pause, acknowledge and adjust)

**Tool Integration:**
11. What tools does the agent call? (database queries, booking APIs, CRM lookups)
12. What information must the agent collect before calling each tool? (name, phone, date, ID)
13. What happens when a tool call fails? (retry, apologize, escalate)
14. Are there tools the agent must NEVER call without confirmation? (payments, cancellations, deletions)

**Voice-Specific Constraints:**
15. Target response length? (under 30 words for conversational, under 60 for informational)
16. Latency budget? (prompt size affects LLM response time — shorter = faster)
17. How should the agent handle unclear speech? (ask to repeat, confirm interpretation, skip)
18. How should the agent handle silence? (prompt after N seconds, wait, disconnect after timeout)

**Testing & Quality:**
19. What test scenarios must pass before deployment? (happy path, edge cases, language switching)
20. How is prompt quality measured? (task completion rate, caller satisfaction, escalation rate)

### Deliverable

```markdown
## Voice Agent Prompt Design

### Agent Profile
- Role: [What the agent does]
- Persona: [Traits and tone]
- Domain: [Business context]
- Languages: [Primary + supported]
- Authority: [What the agent can and cannot do]

### Conversation Flow
1. Greeting: [Opening line]
2. Intent Detection: [How the agent identifies what the caller wants]
3. Information Gathering: [What to collect, in what order]
4. Action: [Tool calls, confirmations]
5. Closing: [Summary, next steps, sign-off]

### Intents & Responses
| Intent | Required Info | Tool Call | Confirmation |
|--------|--------------|-----------|-------------|
| [Book] | name, date, time | book_appointment() | Repeat back details |
| [Cancel] | appointment_id | cancel_appointment() | Double-confirm |

### Escalation Rules
- Trigger: [Conditions]
- Handoff: [Transfer to human, create ticket, callback]
- Message: [What the agent says when escalating]

### Voice Constraints
- Max response length: [N words]
- Silence timeout: [N seconds → prompt, N seconds → disconnect]
- Unclear speech: [Strategy]

### System Prompt
[The actual system prompt text, structured per /voice-agent-prompt skill]

### Decision Log — Phase 8: Voice Agent Prompt Design
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
