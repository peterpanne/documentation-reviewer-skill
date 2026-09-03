---
name: reviewing-developer-documentation
description: Reviews software documentation for developer audiences, with special attention to MkDocs and Material for MkDocs sites. Use when evaluating documentation quality, information architecture, onboarding, task guides, technical reference, examples, troubleshooting, cognitive load, documentation pull requests, or mkdocs.yml configuration, and when producing prioritized documentation improvement recommendations.
---

# Reviewing developer documentation

Review documentation as a developer trying to complete real work. Optimize for correctness, task success, findability, low avoidable cognitive load, trustworthy reference material, and maintainability. Do not reward documentation merely for being long or visually polished.

## Operating rules

- Read project instructions first: `CLAUDE.md`, `CONTRIBUTING.md`, documentation style guides, and repository conventions.
- Treat implementation, schemas, action metadata, configuration definitions, tests, and released behavior as sources of truth. Never invent behavior to fill a documentation gap.
- Separate **incorrect**, **missing**, **ambiguous**, and **unverified** information.
- Verify commands, flags, configuration keys, paths, URLs, UI labels, and internal links before treating them as valid.
- Distinguish intrinsic product/domain complexity from avoidable complexity introduced by the documentation.
- Prioritize developer impact over stylistic preference. Avoid low-value grammar and formatting nits.
- Do not modify files during a review unless the user explicitly asks for fixes.
- Never reproduce secrets discovered in examples, fixtures, workflows, logs, or configuration.

## Review workflow

### 1. Establish scope and audience

Determine:

- intended developer audience and assumed knowledge;
- primary jobs-to-be-done;
- supported versions, environments, permissions, and important constraints;
- whether this is a full-site review, multi-area documentation review/PR, or narrow page/configuration review.

If the user supplied enough context, proceed without unnecessary questions.

### 2. Orient once

Perform a shallow orientation pass before deep review work. Locate the relevant subset of:

- `mkdocs.yml` / `mkdocs.yaml`;
- documentation pages and assets;
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, changelog/release notes;
- `action.yml` / `action.yaml`, schemas, configuration definitions, implementation code, and tests;
- CI workflows that build, validate, or publish documentation.

Map important documentation claims to likely sources of truth. Reuse verified evidence already gathered in the current session rather than repeating identical mechanical checks.

### 3. Select and announce review mode

Before substantive review work, state one short mode line to the user:

```text
Review mode: parallel — full-site review with independent review dimensions.
```

or:

```text
Review mode: direct — narrow single-page/configuration review.
```

#### Mandatory parallel mode

When a subagent mechanism is available, **you MUST use parallel review** for any of the following:

- a full documentation-site review;
- a broad review explicitly requested "from different angles";
- a multi-area documentation PR/review;
- a scope where at least three independent dimensions are materially relevant, such as technical correctness, developer journeys, examples/MkDocs mechanics, cognitive load, or risk/maintainability.

A small page count does not exempt a full-site review. Recent edits, successful builds, earlier source checks, or coordinator familiarity do not exempt it either. Those are reusable evidence for the shared brief, not independent perspectives.

Do not silently downgrade a qualifying review to direct mode.

#### Explicit specialist invocation

For a qualifying broad review, do **not** rely on automatic delegation. Explicitly launch the required specialists in the same parallel wave.

When installed as the Claude Code plugin, invoke these plugin agents:

1. `documentation-reviewer:technical-truth-reviewer`
2. `documentation-reviewer:developer-journey-reviewer`
3. `documentation-reviewer:docs-system-reviewer`
4. `documentation-reviewer:cognitive-load-reviewer`

Also invoke `documentation-reviewer:risk-maintainability-reviewer` when security, accessibility, compatibility, or long-term maintainability is materially relevant.

Give every specialist the same factual shared brief plus its distinct mandate. Do not ask every specialist to rerun the same build or rediscover the entire repository.

If the named plugin agents are unavailable but the host provides general-purpose subagents, explicitly launch equivalent independent subagents with the mandates in [reference/parallel-review.md](reference/parallel-review.md). If the host provides no subagents, perform the same passes sequentially and state that parallel execution was unavailable.

Direct mode is appropriate only for genuinely narrow work such as one short page, one broken link, one `mkdocs.yml` setting, or a tightly sequential question. A user request to avoid subagents also overrides parallel mode.

The coordinator owns the final review. Never paste raw specialist reports into the answer.

### 4. Validate mechanically when practical

Prefer the repository's own documentation command first (`make`, `just`, `tox`, `nox`, project scripts, or CI-equivalent commands).

If MkDocs is already available and no project command supersedes it, run:

```bash
mkdocs build --strict
```

Do not install packages, rewrite lockfiles, or change the environment unless asked. If a build cannot run, record the limitation.

In parallel mode, assign shared mechanical checks to one specialist or the coordinator rather than repeating them in every workstream.

### 5. Review information architecture and page purpose

Classify content by reader need:

- learning/tutorial;
- task-oriented how-to;
- technical reference;
- explanation/concepts;
- landing/overview, troubleshooting, and FAQ when useful.

A site does not need literal top-level sections for every type. Judge whether important reader needs have an obvious home and whether navigation reflects developer intent.

Use:

- [reference/review-rubric.md](reference/review-rubric.md) for the weighted review;
- [reference/page-type-checks.md](reference/page-type-checks.md) for page-level contracts;
- [reference/cognitive-load-review.md](reference/cognitive-load-review.md) for avoidable mental effort;
- [reference/mkdocs-review.md](reference/mkdocs-review.md) for MkDocs/Material checks;
- [reference/parallel-review.md](reference/parallel-review.md) for specialist orchestration and merging.

### 6. Trace critical developer journeys

When relevant, test:

1. **First success**: purpose, prerequisites, setup, minimal example, observable success.
2. **Common task**: fast path to a frequent real-world workflow.
3. **Reference lookup**: exact options, defaults, types, constraints, outputs, and examples.
4. **Failure recovery**: symptom/error to diagnosis, fix, and verification.
5. **Upgrade/change**: compatibility, breaking changes, deprecations, version-specific behavior.

For each important page, apply its page-type contract rather than one generic checklist.

Also trace cognitive burden: what must the developer remember, infer, reconcile, backtrack, or decide before the next correct action? Do not penalize necessary domain complexity.

### 7. Cross-check examples and authored syntax

For important examples/reference material:

- compare names, defaults, inputs, outputs, permissions, and constraints with sources of truth;
- verify placeholders and surrounding context are sufficient to copy safely;
- verify success criteria where useful;
- verify internal links and referenced paths exist;
- verify non-standard MkDocs/Material syntax is enabled by the active configuration;
- flag stale, impossible, insecure, unsupported-rendering, or contradictory examples;
- prefer generated/source-derived reference material where manual duplication is likely to drift.

### 8. Merge and verify specialist findings

In parallel mode, wait for all required specialist workstreams to return or fail before final synthesis.

Then:

- normalize candidate findings into one format;
- deduplicate findings with the same root cause;
- treat independent corroboration as higher confidence, not higher severity;
- resolve factual disagreements against primary source-of-truth evidence;
- mark unresolved claims unverified rather than inventing certainty;
- independently verify decisive evidence for every Critical and High finding;
- require final confidence of at least 80/100 for Critical and High findings;
- omit weak taste-based Medium/Low findings;
- compute one rubric score only after the merged finding set is stable.

Cognitive load is cross-cutting, not a separate weighted score. Map a validated load hotspot to the rubric category whose developer impact it explains and do not deduct twice for one root cause.

Severity:

- **Critical**: unsafe or materially wrong guidance with severe consequences.
- **High**: blocks or seriously impairs a primary journey or makes core reference unreliable.
- **Medium**: recurring friction, ambiguity, poor findability, avoidable cognitive burden, or maintenance risk.
- **Low**: limited-impact polish or consistency issue.

### 9. Produce one actionable review

Use this order:

1. **Verdict**: whether developers can successfully use and trust the docs.
2. **Top findings**: Critical and High first, each with evidence and a concrete fix.
3. **Scorecard**: category scores and total out of 100.
4. **Coverage gaps**: missing or weak journeys/content types.
5. **Cognitive-load hotspots**: only meaningful hotspots not already obvious from top findings.
6. **MkDocs observations**: navigation, search, build validation, edit links, accessibility, reproducibility, maintainability.
7. **Suggested next structure**: only when information architecture materially needs improvement.
8. **Validation limits**: checks that could not run and any required specialist workstream that failed/unavailable.

Finding format:

```text
[Severity] Short title
Where: path:line or page/section
Evidence: what the docs say or omit, and what the source of truth shows
Impact: why this matters to a developer
Fix: the smallest concrete improvement that resolves the issue
```

Do not expose specialist transcripts or internal agent identities in the final review. Present one coherent, evidence-backed assessment.

## Review stance

Prefer a small set of consequential findings over an encyclopedia of preferences. A strong review makes the next documentation change obvious.
