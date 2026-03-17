# Software Forge Expansion — 2026-03-17

## Board

| # | Task | Status | Notes |
|---|------|--------|-------|
| 1 | Fix Phase 8 (voice prompt phase truncated to 5 lines) | DONE | Expanded to 81 lines with questions, deliverable, decision log |
| 2 | Build `stack-audit` skill | DONE | 310 lines. 15-domain × 7-layer taxonomy, scoring formula, calibration table |
| 3 | Build Stack Compatibility Oracle skill | DONE | 302 lines. 5 compatibility dimensions, 20 known incompatibilities, 6 proven stacks |
| 4 | Build Architecture Best Practices Knowledge Base | DONE | 352 lines. All 15 domains covered with concrete practices |
| 5 | Build Brownfield → Greenfield Diff Engine skill | DONE | 309 lines. 5-phase process, intent classification system, comparison matrix |
| 5b | Update orchestrator SKILL.md to reference new skills | DONE | Added cross-cutting skills section, new anti-patterns |
| 5c | Update plugin.json metadata (both claude + cursor) | DONE | Version 1.1.0 → 1.2.0, skill count 26 → 30, new keywords |
| 6 | Full audit of software-forge | DONE | See audit findings below |

## Audit Findings (Task 6)

### Fixed

| # | Severity | Issue | Fix |
|---|----------|-------|-----|
| 1 | HIGH | Route table phase counts wrong for all 6 project types | Recounted from route table, updated all ranges |
| 2 | HIGH | iOS count 8-16 (agent miscounted Infrastructure as conditional) | Corrected to 8-15 |
| 3 | CRITICAL | Executing-plans dead end — Phases 16-20 never run if user forgets to return | Added explicit handoff instructions with warning in Phase 15 |
| 4 | HIGH | Phase 15 → 16 handoff implicit for subagent-driven path | Added explicit "announce completion, summarize, proceed" instructions |
| 5 | MEDIUM | Phase 13 Go/No-Go has no loop-back for "Redesign Required" | Added Decision Gate with specific phase-to-revisit mapping |
| 6 | MEDIUM | Phase 19 has no concrete deliverable/artifact | Added review summary deliverable template |
| 7 | MEDIUM | Phase 0.5 missing Decision Log | Added |
| 8 | LOW | Phase 16 missing Decision Log | Added |
| 9 | LOW | Phase 18 missing Decision Log | Added |
| 10 | LOW | Phase 20 missing Decision Log | Added |
| 11 | LOW | Book References: Phase 14 labeled "Testing Strategy" | Changed to "Writing Plans" |
| 12 | LOW | code-simplifier orphaned `license: MIT` frontmatter | Removed |
| 13 | MEDIUM | Skill count "26" in README, FULL-GUIDE, QUICK-REFERENCE, install.sh, marketplace.json, ARCHITECTURE.md | Updated to 30 |
| 14 | MEDIUM | 4 new skills missing from documentation tables | Added to FULL-GUIDE and QUICK-REFERENCE |

### Accepted / Not Fixed

| # | Issue | Reason |
|---|-------|--------|
| 1 | 7 skills missing "When to Use" section | Mostly operational skills where context is implicit. Low impact. |
| 2 | 5 skills missing anti-patterns section | Would add bulk without clear value for skills like engineering-mentor. |
| 3 | `requesting-code-review` references `software-forge:code-reviewer` | Intentional — it's a subagent prompt template, not a skill. Works as designed. |
| 4 | `run-hook.cmd` Unix polyglot path potential recursion | In practice, Claude Code runs hook commands differently on Unix. No reports of issues. |
| 5 | `docs/improvement.md` says "26 skills" | Historical document — accurate at time of writing. |

## Flow Analysis Summary

### Clean
- Phase sequence has no redundancy — each phase has a distinct job
- Artifact chain is correct (design → plans → code → validation)
- Compaction points are in the right places
- No infinite loops possible

### Fixed
- Executing-plans dead end (Phases 16-20 would be skipped)
- Phase 15 → 16 implicit handoff
- Phase 13 Go/No-Go missing loop-back
- Phase 19 missing artifact for resumption detection

### Architecture Notes
- Max delegation depth: 4 (orchestrator → subagent-driven → implementer → reviewer)
- Engineering-mentor is a transparent wrapper (not a separate flow)
- Cross-cutting skills (stack-audit, oracle, KB, diff engine) are invokable but not mandatory phases

## Decision Log

- **Build order:** Chose bottom-up (taxonomy → KB → oracle → diff engine) because each layer depends on the one below it.
- **stack-audit creation:** Skill is listed in the manifest but had zero code. Built from scratch.
- **Local tracking over Jira:** No Jira MCP connected, only Confluence. User chose local file.
- **iOS phase count:** Agent counted 8-16 but Infrastructure (Phase 9) is blank for iOS, not conditional. Corrected to 8-15.
- **Phase 15 fix approach:** Added explicit handoff instructions to BOTH paths (subagent-driven and executing-plans) rather than restructuring the phase. The flow is correct; it just needed explicit signals.
- **Phase 13 loop-back:** Added specific phase-to-revisit mapping based on failure reason rather than a generic "go back" instruction.
