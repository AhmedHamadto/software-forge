# Skill Triggering Accuracy Analysis

**Date:** 2026-03-17
**Skills Analyzed:** 5 (software-forge, stack-audit, stack-compatibility-oracle, architecture-best-practices, brownfield-greenfield)
**Test Queries:** 10

---

## Per-Query Analysis

### Query 1
> "ok so I've got this idea for an app that tracks hiking trails... where do I even start with all the design decisions"

**Expected:** software-forge
**Predicted trigger:** software-forge
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** "starting a new project" is the first trigger phrase in software-forge's description. The user is clearly at project inception. No other skill competes here.

---

### Query 2
> "I need to add a dark mode toggle to our settings page, it's just a boolean"

**Expected:** none
**Predicted trigger:** none
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** This is explicitly a minor feature ("just a boolean"). software-forge says "major feature," not minor. No other skill's trigger language matches. Claude should just do the work.

---

### Query 3
> "we're about to pick our tech stack for a new microservices project — fastapi, postgres, kafka, kubernetes. before we commit, can you check if anything here doesn't play well together?"

**Expected:** stack-compatibility-oracle
**Predicted trigger:** stack-compatibility-oracle
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** "evaluating a proposed tech stack for a new project" maps directly. The user lists specific technologies and asks about compatibility. The phrase "doesn't play well together" is a near-synonym for "flags known incompatibilities."

**Minor concern:** architecture-best-practices also mentions "evaluating stack choices" and "gotchas for technology combinations." Claude could reasonably consider it. However, the oracle's description is more specific to pre-flight checks, which matches the user's "before we commit" framing. The oracle should win.

---

### Query 4
> "my boss wants a report on what technologies we're using and where we have gaps"

**Expected:** stack-audit
**Predicted trigger:** stack-audit
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** "coverage report showing what exists, what's missing" maps directly to "what technologies we're using and where we have gaps." The word "report" also aligns. No other skill produces a coverage report.

---

### Query 5
> "what's the best way to handle database connection pooling with serverless functions?"

**Expected:** architecture-best-practices
**Predicted trigger:** architecture-best-practices
**Correct?** YES — but with reservations
**Confidence:** MEDIUM
**Reasoning:** This is a specific technical question about a technology combination pattern. architecture-best-practices describes itself as a "queryable knowledge base" for "community-proven patterns and gotchas for technology combinations." That fits.

**Concern:** This query is narrow enough that Claude might just answer it directly from its own knowledge without invoking any skill. The description says "Use when evaluating stack choices, diagnosing production issues" — this query isn't really evaluating a stack choice or diagnosing an issue. It's asking for a best practice on a specific topic. The description's trigger language doesn't have a clean match for "how do I do X with Y" style questions. Claude might skip the skill entirely, treating it as a straightforward knowledge question.

**Risk:** FALSE NEGATIVE — Claude answers directly instead of invoking the skill.

---

### Query 6
> "this codebase is 8 years old and everyone's afraid to touch it... I want to know what it would look like if we rebuilt it from scratch vs what we should actually migrate"

**Expected:** brownfield-greenfield
**Predicted trigger:** brownfield-greenfield
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** "rebuilt it from scratch" maps to greenfield. "what we should actually migrate" maps to the side-by-side comparison. The description's "what a fresh start would look like" and "presents a side-by-side comparison so the user can decide what (if anything) to change" are near-exact matches.

---

### Query 7
> "can you fix the typo on line 42"

**Expected:** none
**Predicted trigger:** none
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** Trivial fix. No skill's trigger language is anywhere near this.

---

### Query 8
> "I want to build a voice agent for our dental clinic that handles appointment booking over the phone with Twilio and LiveKit"

**Expected:** software-forge
**Predicted trigger:** software-forge
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** "starting a new project" + "voice agent" are both explicitly listed in software-forge's description. Double match.

**Minor concern:** stack-compatibility-oracle could also argue relevance since the user mentions specific technologies (Twilio, LiveKit). But the user's primary intent is "I want to build," not "check compatibility." software-forge should win and will invoke the oracle as a sub-phase if needed.

---

### Query 9
> "run our jest tests and tell me what's failing"

**Expected:** none
**Predicted trigger:** none
**Correct?** YES
**Confidence:** HIGH
**Reasoning:** Operational task. No skill matches. Claude should just run the tests.

---

### Query 10
> "we inherited a python flask API from the previous team. before we add features, can you map out what it does and what the pain points are?"

**Expected:** brownfield-greenfield
**Predicted trigger:** AMBIGUOUS — brownfield-greenfield or stack-audit
**Correct?** PARTIAL
**Confidence:** LOW

**Reasoning:** This is the weakest match in the set. Let me break down the conflict:

- **brownfield-greenfield** triggers on "evaluating an existing project" and "extracts the intent graph from brownfield code." The user inherited a codebase and wants to understand it. However, the user is NOT asking "what would a fresh start look like" — they're asking "map out what it does and what the pain points are." The skill's description is anchored on the fresh-start comparison, which the user didn't request.

- **stack-audit** triggers on "onboarding to a new codebase" (which this is) and produces a "coverage report showing what exists, what's missing, and what's immature." The user wants to understand pain points, which could map to "what's immature."

- **Neither is a clean fit.** The user wants codebase understanding + pain point identification, not a greenfield comparison and not a technology coverage matrix. Claude might trigger stack-audit (because "onboarding to a new codebase" is a direct match in trigger language), brownfield-greenfield (because "inherited a codebase" maps to brownfield), or even software-forge (because "adding a major feature to an existing system" partially matches "before we add features").

**Risk:** MISFIRE — Claude triggers stack-audit instead of brownfield-greenfield, or triggers software-forge. All three have partial claim to this query.

---

## Triggering Accuracy Score

| Query | Expected | Predicted | Correct? |
|-------|----------|-----------|----------|
| 1 | software-forge | software-forge | YES |
| 2 | none | none | YES |
| 3 | stack-compatibility-oracle | stack-compatibility-oracle | YES |
| 4 | stack-audit | stack-audit | YES |
| 5 | architecture-best-practices | architecture-best-practices (or none) | PARTIAL |
| 6 | brownfield-greenfield | brownfield-greenfield | YES |
| 7 | none | none | YES |
| 8 | software-forge | software-forge | YES |
| 9 | none | none | YES |
| 10 | brownfield-greenfield | ambiguous (brownfield-greenfield / stack-audit / software-forge) | PARTIAL |

**Score: 8/10 confident correct, 2/10 partial/ambiguous**

---

## Identified Conflicts and Weak Spots

### 1. Query 10: Three-way ambiguity (brownfield-greenfield vs stack-audit vs software-forge)

**Root cause:** The trigger boundaries between these three skills overlap on the scenario "inherited codebase, want to understand it before doing work."

- stack-audit says "onboarding to a new codebase" — exact match
- brownfield-greenfield says "evaluating an existing project" — exact match
- software-forge says "adding a major feature to an existing system" — partial match via "before we add features"

The user's actual intent (understand what's there + find pain points) doesn't cleanly map to any single skill. brownfield-greenfield is the expected answer, but its description over-indexes on the "fresh start comparison" outcome, while the user never asked for that.

### 2. Query 5: False negative risk for architecture-best-practices

**Root cause:** The description's trigger language ("evaluating stack choices, diagnosing production issues, feeding the Stack Compatibility Oracle") is oriented toward decision-making contexts. A standalone "how do I do X" question doesn't feel like any of those. Claude may just answer from general knowledge.

### 3. Persistent overlap: architecture-best-practices vs stack-compatibility-oracle

Both descriptions mention evaluating technology choices. The distinction (oracle = compatibility check, best-practices = patterns knowledge base) is clear to a human reading both descriptions side-by-side, but in the moment of a single query, Claude has to choose. The "feeding the Stack Compatibility Oracle" phrase in architecture-best-practices helps disambiguate (it positions itself as subordinate), but this is subtle.

### 4. software-forge as a catch-all risk

The phrase "when unsure which skills to run and in what order" makes software-forge a valid fallback for any ambiguous query. This is intentional (it's an orchestrator), but it means that in conflict scenarios, software-forge can always justify triggering. For query 10, this fallback could actually fire.

---

## Description Improvement Suggestions

### brownfield-greenfield — Needs a broader trigger for "understand an inherited codebase"

**Current:** "Use when evaluating an existing project to understand what a fresh start would look like..."

**Problem:** The description gates on the greenfield comparison outcome. Users who want to understand an inherited codebase without necessarily wanting a fresh-start comparison won't match cleanly.

**Suggested revision:**
> "Use when inheriting or evaluating an existing codebase — maps what the system does (intent graph), identifies pain points and accidental complexity, and optionally redesigns with current best practices for a side-by-side comparison. Helps decide what to keep, what to migrate, and what to leave alone."

**Key changes:** Added "inheriting" as a trigger word. Added "identifies pain points" to match query 10's language. Made the greenfield comparison "optional" rather than the primary framing. This lets the skill claim "understand this codebase" queries without requiring the user to ask for a rebuild comparison.

### architecture-best-practices — Needs a trigger for standalone "how to" questions

**Current:** "Use when evaluating stack choices, diagnosing production issues, or feeding the Stack Compatibility Oracle."

**Problem:** Doesn't cover the common case of "what's the best way to do X with Y" — a direct best-practice lookup.

**Suggested revision:**
> "Queryable knowledge base of community-proven patterns and gotchas for technology combinations across the 15-domain Tech Stack Taxonomy. Use when asking how to combine specific technologies correctly, evaluating stack choices, diagnosing production issues, or feeding the Stack Compatibility Oracle."

**Key change:** Added "asking how to combine specific technologies correctly" as the first trigger phrase, which directly matches "what's the best way to handle X with Y" queries.

### stack-audit — Add a negative boundary to reduce overlap with brownfield-greenfield

**Current description is fine for its own queries**, but it competes on "onboarding to a new codebase." Consider adding a disambiguation hint:

**Suggested addition to description (append):**
> "Focuses on technology coverage and maturity, not on understanding application logic or business intent (use brownfield-greenfield for that)."

This explicit boundary would help Claude disambiguate when a query involves an inherited codebase.

### stack-compatibility-oracle — No changes needed

The description is precise. "Pre-flight" and "BEFORE code gets written" are strong discriminators. The "flags known incompatibilities" language is specific enough to avoid false positives.

### software-forge — No changes needed to the description itself

The catch-all behavior ("when unsure which skills to run") is intentional and correct for an orchestrator. The risk of over-triggering is managed by the specificity of the other skills — if they have strong enough descriptions, they should win over software-forge for their domains.

---

## Summary

| Metric | Value |
|--------|-------|
| Clean correct triggers | 8/10 |
| Ambiguous/partial triggers | 2/10 |
| Clean misfires | 0/10 |
| Skills needing description updates | 3 (brownfield-greenfield, architecture-best-practices, stack-audit) |
| Skills with good descriptions | 2 (stack-compatibility-oracle, software-forge) |

The biggest risk is query 10, where three skills have legitimate claim. The fix is primarily on brownfield-greenfield (broaden trigger language to cover "understand inherited codebase" without requiring a greenfield comparison ask) and stack-audit (add a negative boundary). Query 5's risk is lower severity — the worst case is Claude answers the question correctly without a skill, which is an acceptable outcome.
