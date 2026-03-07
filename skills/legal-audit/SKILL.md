---
name: legal-audit
description: Audit a repository for legal, IP, attribution, accuracy, PR, and trademark risks before public promotion. Use before sharing a repo publicly on social media or making it open source.
---

# Legal & Public Relations Audit

## Overview

Thorough audit of every file in a repository for legal exposure, intellectual property risks, attribution gaps, accuracy of claims, public relations hazards, and trademark concerns. Designed for the moment before you promote a repo publicly.

## When to Use
- Before sharing a repository on LinkedIn, Twitter, or other public channels
- Before making a private repo public
- After incorporating content from external open-source projects
- After adding content inspired by books, courses, or proprietary frameworks
- Periodic audit of any repo intended for public visibility

## Audit Procedure

Run all 6 audit categories below. Use parallel Agent subagents where categories are independent. Search every file — do NOT sample or skip.

---

### 1. License Compliance

**Context:** The repo is MIT licensed. All content must be MIT-compatible.

**Checks:**

a) **Upstream compatibility:** For every file derived from or inspired by external projects (especially `obra/superpowers` and `everything-claude-code`), verify their license is compatible with MIT. Read their LICENSE files or headers.

b) **Per-file attribution for adapted content:** Scan all skill files, configs, and commands. If substantial content is adapted from upstream repos, check for per-file attribution comments or headers.

c) **Restrictive licenses:** Search for any indicators of GPL, CC-NC, AGPL, or proprietary license terms:
```
GPL
AGPL
GNU General Public License
Creative Commons.*NonCommercial
CC-BY-NC
CC-BY-SA
All Rights Reserved
proprietary
```

d) **Verbatim book content:** Read through the engineering-mentor concept files and any other instructional content. Flag passages that read like direct excerpts from books rather than original instructional content inspired by them. Look for:
- Long quoted passages without attribution
- Prose that shifts noticeably in style (suggesting copy-paste)
- Specific numbered lists, frameworks, or taxonomies that are signature to a particular book

**Paths to scan:**
```
skills/engineering-mentor/concepts/*.md
skills/**/*.md
```

**Risk type:** LEGAL
**Severity:** CRITICAL if GPL/incompatible license found, HIGH if verbatim book content, MEDIUM if attribution missing on adapted files

---

### 2. Intellectual Property Risks

**Checks:**

a) **Employer IP leakage:** Search all files for content that could be proprietary methodology from any corporate entity. Check the repo owner's background and search for current/past employer names, client names, and internal project codenames. Also look for process descriptions, workflow diagrams, or design patterns that appear company-specific rather than general engineering practice.

b) **Proprietary frameworks:** Review the engineering-mentor skill's concept areas and competency tracking system. Verify the structure is original and not adapted from a proprietary corporate training framework. Check:
```
skills/engineering-mentor/SKILL.md
skills/engineering-mentor/profile/schema.md
skills/engineering-mentor/concepts/*.md
```

c) **Book reproduction vs. reference:** For each concept file in engineering-mentor, assess whether the content:
- Summarizes and teaches concepts in original language (OK)
- Reproduces the structure, taxonomy, or substantial text of the source book (NOT OK)

**Risk type:** IP
**Severity:** CRITICAL if employer IP found, HIGH if proprietary framework adapted, MEDIUM if borderline book reproduction

---

### 3. Attribution & Credit

**Checks:**

a) **README acknowledgements:** Read `README.md` and verify its Acknowledgements section accurately reflects all borrowed or adapted code and content.

b) **Skill file origins:** For each skill file, determine if it originates from `obra/superpowers` or another source. If so, verify clear attribution exists (comment, header, or README reference).

c) **Config file origins:** Check all config files in plugin/tool directories:
```
.claude-plugin/**/*
.cursor-plugin/**/*
.codex/**/*
.opencode/**/*
```
If the structure is from `everything-claude-code` or similar, verify attribution.

d) **Unattributed third-party content:** Flag any files that contain third-party content (code patterns, text, configurations) without attribution.

**Risk type:** ATTRIBUTION
**Severity:** HIGH if substantial adapted content unattributed, MEDIUM if minor config structure unattributed, LOW if attribution exists but could be clearer

---

### 4. Claims & Accuracy

**Checks:**

a) **Misleading claims:** Read `README.md` and all docs. Flag any statements that:
- Overstate originality (e.g., claiming everything is built from scratch when content is adapted)
- Imply endorsement by Anthropic or any other company
- Misrepresent the scope or capabilities of the tool

b) **Count verification:** Extract claimed counts from README (skill count, book count, phase count, etc.) and verify against actual repo contents:
```bash
# Count actual skills
ls -d skills/*/SKILL.md | wc -l

# Count actual phases
ls skills/software-forge/phases/*.md | wc -l

# Count actual commands
ls commands/*.md | wc -l

# Count engineering-mentor concept files
ls skills/engineering-mentor/concepts/*.md | wc -l
```

c) **Promise vs. delivery:** Cross-reference any skills listed or described in README against what actually exists in the `skills/` directory. Flag anything listed but missing, or present but unlisted.

**Risk type:** ACCURACY
**Severity:** HIGH if endorsement implied or originality overstated, MEDIUM if counts are wrong, LOW if minor inconsistencies

---

### 5. Public Relations Risk

**Checks:**

a) **Unprofessional content:** Search all files for:
```
TODO
HACK
FIXME
WORKAROUND
WTF
damn
shit
fuck
crap
stupid
hate
sucks
```
Review each match in context — coding TODOs are fine, but complaints about employers, sarcastic remarks about tools/companies, or unprofessional commentary should be flagged.

b) **Company/individual references:** Search for references to specific clients, companies, or individuals beyond credited open-source authors. Check the repo owner's background and search for current/past employer names, university names, client names, city names, and internal project codenames. Also search for any person's full name that isn't an open-source contributor being credited.

c) **Competitive positioning:** Look for content that could be interpreted as positioning against Anthropic's products or other companies' tools. Flag statements that compare this tool favorably against commercial offerings.

d) **False official relationship:** Search for language that implies an official relationship with Anthropic:
```
official
endorsed
partnership
affiliated
supported by Anthropic
Anthropic's
built by Anthropic
```
Verify all such references are clearly descriptive (e.g., "built for Claude Code" is fine, "Anthropic's official toolkit" is not).

**Risk type:** PR
**Severity:** CRITICAL if complaints about employers found, HIGH if false endorsement implied, MEDIUM if unprofessional language, LOW if minor tone issues

---

### 6. Trademark Concerns

**Checks:**

a) **Project name conflicts:** Note whether "Software Forge" could conflict with known trademarks in the software tools space. Search for:
- Existing products named "Software Forge"
- Similar names in the developer tools category

b) **Claude Code usage:** Verify that all references to "Claude Code" in README and skill files are descriptive only and don't imply endorsement. Acceptable: "a skill library for Claude Code". Not acceptable: "the official Claude Code extension".

c) **Brand name usage:** Search all files for logos, brand names, or trademarked terms:
```
Claude
Anthropic
OpenAI
GPT
Supabase
Vercel
Stripe
```
Verify each use is fair descriptive reference, not implying endorsement or affiliation.

**Risk type:** TRADEMARK
**Severity:** HIGH if name conflict found or endorsement implied, MEDIUM if brand usage is borderline, LOW if all usage is clearly descriptive

---

## Report Format

For each finding:

```
### [SEVERITY] [RISK_TYPE] — Brief description

**File:** `path/to/file`
**Line:** 42
**Content:** `the exact content found`
**Risk:** Explanation of why this is a concern
**Fix:** Recommended remediation
```

Group findings by severity: CRITICAL > HIGH > MEDIUM > LOW.

## Summary

End the report with:

```
## Audit Summary

| Category            | Risk Type   | Status | Findings |
|---------------------|-------------|--------|----------|
| License Compliance  | LEGAL       | ...    | X        |
| Intellectual Property | IP        | ...    | X        |
| Attribution & Credit | ATTRIBUTION | ...   | X        |
| Claims & Accuracy   | ACCURACY    | ...    | X        |
| Public Relations     | PR         | ...    | X        |
| Trademark Concerns   | TRADEMARK  | ...    | X        |

**Total findings:** X
**Critical:** X | **High:** X | **Medium:** X | **Low:** X

**Verdict:** CLEAR FOR PUBLIC PROMOTION / NEEDS REMEDIATION BEFORE PROMOTION
```

If the repo is clean, confirm with a per-category summary of what was checked and the result.
