---
name: reviewing-developer-documentation
description: Reviews software documentation for developer audiences, with special attention to MkDocs and Material for MkDocs sites. Use when evaluating documentation quality, information architecture, onboarding, task guides, technical reference, examples, troubleshooting, documentation pull requests, or mkdocs.yml configuration, and when producing prioritized documentation improvement recommendations.
---

# Reviewing developer documentation

Review documentation as a developer trying to complete real work. Optimize for correctness, task success, findability, trustworthy reference material, and maintainability. Do not reward documentation merely for being long or visually polished.

## Operating rules

- Read project-specific instructions first: `CLAUDE.md`, `CONTRIBUTING.md`, documentation style guides, and relevant repository conventions.
- Treat implementation, schemas, action metadata, configuration definitions, tests, and release behavior as sources of truth. Never invent behavior to fill a documentation gap.
- Separate **incorrect**, **missing**, **ambiguous**, and **unverified** information.
- Verify commands, flags, configuration keys, file paths, URLs, UI labels, and internal page links before treating them as valid. Plausible-looking syntax is not evidence.
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

### 3. Validate the site mechanically when practical

Prefer repository-provided commands first (`make`, `just`, `tox`, `nox`, `uv`, `poetry`, project scripts, CI commands).

If MkDocs is already available and no project-specific command supersedes it, run:

```bash
mkdocs build --strict
```

Do not install packages, rewrite lockfiles, or change the environment unless the user asked for that. If a build cannot be run, record the limitation rather than guessing.

### 4. Review information architecture and page purpose

Classify content by reader need:

- learning/tutorial;
- task-oriented how-to;
- technical reference;
- explanation/concepts.

Also recognize landing/overview, troubleshooting, and FAQ content where those forms are useful.

A site does not need literal top-level sections for each type, but each important reader need should have an obvious home. Flag navigation that exposes implementation structure while hiding common developer workflows.

For the full rubric, read [reference/review-rubric.md](reference/review-rubric.md).

For page-level expectations, read [reference/page-type-checks.md](reference/page-type-checks.md).

For MkDocs-specific checks, read [reference/mkdocs-review.md](reference/mkdocs-review.md).

### 5. Trace critical developer journeys

At minimum, test these journeys when relevant:

1. **First success**: Can a new developer understand the purpose, prerequisites, install/setup, run a minimal example, and verify success without guessing?
2. **Common task**: Can an experienced developer quickly find and complete the most frequent real-world workflow?
3. **Configuration/reference lookup**: Can a developer find exact options, defaults, required/optional status, types, constraints, and examples?
4. **Failure recovery**: Can a developer diagnose a likely error from symptoms/logs and find a concrete resolution?
5. **Upgrade/change**: Can a developer determine compatibility, breaking changes, deprecations, or version-specific behavior when that matters?

For important pages in each journey, identify the page's job and apply the matching page-type contract rather than using one generic checklist everywhere.

### 6. Cross-check examples, reference material, and authored syntax

For every important example or reference page sampled:

- compare names, inputs, defaults, outputs, permissions, and constraints with source-of-truth files;
- verify placeholders are obvious and examples contain enough context to copy safely;
- check that success criteria or expected output are stated where useful;
- verify internal links and referenced paths exist before accepting or recommending them;
- when non-standard MkDocs/Material syntax is used, verify the active `mkdocs.yml` enables the required extension or theme support;
- flag stale, impossible, insecure, unsupported-rendering, or contradictory examples with high priority;
- prefer generated or source-derived reference material when manual duplication is likely to drift.

### 7. Score and prioritize

Score the site using the weighted rubric in `reference/review-rubric.md`. A numerical score is a summary, not a substitute for findings.

Use severities:

- **Critical**: materially incorrect or unsafe guidance likely to cause broken deployments, data/security risk, or severe user harm.
- **High**: blocks or seriously impairs a primary developer journey, or makes core reference unreliable.
- **Medium**: creates recurring friction, ambiguity, poor findability, or maintenance risk.
- **Low**: polish or consistency improvement with limited impact.

Do not mark a missing optional page as High merely because a framework recommends it. Tie severity to actual user impact.

### 8. Produce an actionable review

Use this order:

1. **Verdict**: 2-5 sentences on whether developers can successfully use and trust the docs.
2. **Top findings**: Critical and High issues first, each with evidence and a concrete fix.
3. **Scorecard**: category scores and total out of 100.
4. **Coverage gaps**: missing or weak journeys/content types.
5. **MkDocs observations**: navigation, search, build validation, versioning, edit links, accessibility, and maintainability.
6. **Suggested next structure**: only if information architecture needs improvement.
7. **Validation limits**: commands or checks that could not be run.

For each finding include:

```text
[Severity] Short title
Where: path:line or page/section
Evidence: what the docs say or omit, and what the source of truth shows
Impact: why this matters to a developer
Fix: the smallest concrete improvement that resolves the issue
```

When line numbers are unavailable, use the most precise heading or file reference possible.

## Review stance

Prefer a small set of consequential findings over an encyclopedia of preferences. A strong review should make the next documentation change obvious.
