---
name: reviewing-developer-documentation
description: Reviews software documentation for developer audiences, with special attention to MkDocs and Material for MkDocs sites. Use when evaluating documentation quality, information architecture, onboarding, task guides, technical reference, examples, troubleshooting, cognitive load, documentation pull requests, or mkdocs.yml configuration, and when producing prioritized documentation improvement recommendations.
---

# Reviewing developer documentation

Review documentation as a developer trying to complete real work. Optimize for correctness, task success, findability, low avoidable cognitive load, trustworthy reference material, and maintainability. Do not reward documentation merely for being long or visually polished.

## Operating rules

- Read project-specific instructions first: `CLAUDE.md`, `CONTRIBUTING.md`, documentation style guides, and relevant repository conventions.
- Treat implementation, schemas, action metadata, configuration definitions, tests, and release behavior as sources of truth. Never invent behavior to fill a documentation gap.
- Separate **incorrect**, **missing**, **ambiguous**, and **unverified** information.
- Verify commands, flags, configuration keys, file paths, URLs, UI labels, and internal page links before treating them as valid. Plausible-looking syntax is not evidence.
- Distinguish intrinsic product/domain complexity from avoidable complexity introduced by the documentation.
- Prioritize reader impact over stylistic preference. Do not flood the review with low-value grammar nits.
- Do not modify files during a review unless the user explicitly asks to fix findings.
- Never expose secrets found in examples, fixtures, workflows, logs, or local configuration. Refer to the file and issue without repeating the secret.
- When current upstream behavior matters, verify it from authoritative sources if network access is available. Avoid hard-coding time-sensitive ecosystem claims into the review.

## Review workflow

### 1. Establish scope and audience

Determine:

- who the intended developers are and what knowledge is assumed;
- the product's main jobs-to-be-done;
- supported versions, environments, permissions, and important constraints;
- whether this is a full-site review, a changed-docs/PR review, or an MkDocs configuration review.

If the user supplied enough context, proceed without asking unnecessary questions.

### 2. Inventory documentation and sources of truth

Inspect the repository structure and locate, when present:

- `mkdocs.yml` / `mkdocs.yaml`;
- `docs/**/*.md` and documentation assets;
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, changelog/release notes;
- GitHub Action metadata such as `action.yml` / `action.yaml`;
- JSON/YAML schemas and configuration definitions;
- representative implementation code and tests;
- CI workflows that build, lint, or publish documentation.

Map documentation claims to their likely sources of truth before judging accuracy.

### 3. Choose direct or parallel review mode

Choose the review mode explicitly before substantive review work and state it to the user in one short sentence, including the reason. For example: `Review mode: parallel — this is a full-site review with several independent review dimensions.` Do not expose internal agent identities.

When the host provides subagents, use parallel review by default for any broad/full-site review, multi-area documentation PR, or other scope where at least three independent review dimensions are materially relevant. A small page count alone does not make a full-site review narrow.

Fresh evidence already gathered by the coordinator, including recent edits, earlier source-of-truth checks, or mechanical validation from the same session, may be reused in the shared review brief and may reduce duplicate work. It does **not** replace independent specialist perspectives and is not, by itself, a reason to downgrade a broad review to direct mode.

Before fan-out, perform a shallow orientation pass and create one shared review brief so subagents do not all rediscover the repository independently. Then launch the independent specialists in the same parallel wave.

For broad reviews, the default specialist set is:

1. technical truth;
2. developer journeys and information architecture;
3. examples and documentation system;
4. cognitive load;
5. risk and maintainability when materially relevant.

Use the orchestration, specialist mandates, numeric confidence contract, deduplication, disagreement handling, and scoring rules in [reference/parallel-review.md](reference/parallel-review.md).

Work directly only when the request is genuinely narrow, such as a simple single-page, single-setting, or tightly sequential review where delegation overhead is likely to exceed the benefit. If subagents are unavailable for a broad review, perform the same specialist passes sequentially and say that parallel execution was unavailable. Do not silently override the broad-review fan-out rule because the coordinator is already familiar with the repository.

The coordinator remains responsible for the final answer. Never paste or concatenate raw subagent reports as the review.

### 4. Validate the site mechanically when practical

Prefer repository-provided commands first (`make`, `just`, `tox`, `nox`, `uv`, `poetry`, project scripts, CI commands).

If MkDocs is already available and no project-specific command supersedes it, run:

```bash
mkdocs build --strict
```

Do not install packages, rewrite lockfiles, or change the environment unless the user asked for that. If a build cannot be run, record the limitation rather than guessing.

In parallel mode, assign expensive/shared mechanical checks to one specialist or the coordinator rather than running the same build in every subagent.

### 5. Review information architecture, page purpose, and cognitive load

Classify content by reader need:

- learning/tutorial;
- task-oriented how-to;
- technical reference;
- explanation/concepts.

Also recognize landing/overview, troubleshooting, and FAQ content where those forms are useful.

A site does not need literal top-level sections for each type, but each important reader need should have an obvious home. Flag navigation that exposes implementation structure while hiding common developer workflows.

For the full rubric, read [reference/review-rubric.md](reference/review-rubric.md).

For page-level expectations, read [reference/page-type-checks.md](reference/page-type-checks.md).

For cognitive-load checks, read [reference/cognitive-load-review.md](reference/cognitive-load-review.md).

For MkDocs-specific checks, read [reference/mkdocs-review.md](reference/mkdocs-review.md).

### 6. Trace critical developer journeys

At minimum, test these journeys when relevant:

1. **First success**: Can a new developer understand the purpose, prerequisites, install/setup, run a minimal example, and verify success without guessing?
2. **Common task**: Can an experienced developer quickly find and complete the most frequent real-world workflow?
3. **Configuration/reference lookup**: Can a developer find exact options, defaults, required/optional status, types, constraints, and examples?
4. **Failure recovery**: Can a developer diagnose a likely error from symptoms/logs and find a concrete resolution?
5. **Upgrade/change**: Can a developer determine compatibility, breaking changes, deprecations, or version-specific behavior when that matters?

For important pages in each journey, identify the page's job and apply the matching page-type contract rather than using one generic checklist everywhere.

Also trace avoidable cognitive burden: how much must the developer remember, infer, reconcile, backtrack, or decide before taking the next correct action? Do not penalize necessary domain complexity.

### 7. Cross-check examples, reference material, and authored syntax

For every important example or reference page sampled:

- compare names, inputs, defaults, outputs, permissions, and constraints with source-of-truth files;
- verify placeholders are obvious and examples contain enough context to copy safely;
- check that success criteria or expected output are stated where useful;
- verify internal links and referenced paths exist before accepting or recommending them;
- when non-standard MkDocs/Material syntax is used, verify the active `mkdocs.yml` enables the required extension or theme support;
- flag stale, impossible, insecure, unsupported-rendering, or contradictory examples with high priority;
- prefer generated or source-derived reference material when manual duplication is likely to drift.

### 8. Merge, verify, score, and prioritize

In parallel mode, merge candidate findings before scoring:

- deduplicate findings that share one root cause;
- use independent corroboration to raise confidence only after verification, not severity;
- resolve disagreements against primary source-of-truth evidence;
- mark unresolved claims as unverified instead of inventing certainty;
- independently verify the decisive evidence for every Critical and High finding;
- require final confidence of at least 80/100 for Critical and High findings;
- compute one final rubric score only after the merged finding set is stable.

In direct mode, apply the same evidence and confidence discipline.

Score the site using the weighted rubric in `reference/review-rubric.md`. A numerical score is a summary, not a substitute for findings.

Cognitive load is a cross-cutting diagnostic, not a separate score. Map each validated load hotspot to the rubric category whose developer impact it explains and do not deduct twice for the same root cause.

Use severities:

- **Critical**: materially incorrect or unsafe guidance likely to cause broken deployments, data/security risk, or severe user harm.
- **High**: blocks or seriously impairs a primary developer journey, or makes core reference unreliable.
- **Medium**: creates recurring friction, ambiguity, poor findability, avoidable cognitive burden, or maintenance risk.
- **Low**: polish or consistency improvement with limited impact.

Do not mark a missing optional page as High merely because a framework recommends it. Tie severity to actual user impact.

### 9. Produce an actionable review

Use this order:

1. **Verdict**: 2-5 sentences on whether developers can successfully use and trust the docs.
2. **Top findings**: Critical and High issues first, each with evidence and a concrete fix.
3. **Scorecard**: category scores and total out of 100.
4. **Coverage gaps**: missing or weak journeys/content types.
5. **Cognitive-load hotspots**: include only meaningful, evidence-backed hotspots that are not already obvious from the top findings.
6. **MkDocs observations**: navigation, search, build validation, versioning, edit links, accessibility, and maintainability.
7. **Suggested next structure**: only if information architecture needs improvement.
8. **Validation limits**: commands or checks that could not be run, including failed/unavailable specialist workstreams when relevant.

For each finding include:

```text
[Severity] Short title
Where: path:line or page/section
Evidence: what the docs say or omit, and what the source of truth shows
Impact: why this matters to a developer
Fix: the smallest concrete improvement that resolves the issue
```

When line numbers are unavailable, use the most precise heading or file reference possible.

Do not expose internal agent identities or present the final review as a collection of specialist transcripts. The final output should be one coherent, evidence-backed assessment.

## Review stance

Prefer a small set of consequential findings over an encyclopedia of preferences. A strong review should make the next documentation change obvious.
