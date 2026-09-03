# Parallel review orchestration

Use this reference for broad documentation reviews where independent specialist perspectives improve coverage and confidence.

The coordinator owns scope, orchestration, evidence quality, deduplication, severity, scoring, and the final verdict. Specialists propose findings only.

## Hard trigger for parallel review

When subagents are available, parallel review is **required** for:

- full documentation-site reviews;
- requests to review documentation from multiple/different angles;
- multi-area documentation PRs;
- scopes with at least three materially independent dimensions such as correctness, developer journeys, examples/MkDocs mechanics, cognitive load, or risk/maintainability.

Do not skip fan-out because:

- the site has only a few pages;
- the coordinator just edited the docs;
- the coordinator already knows the repository;
- `mkdocs build --strict` already passed;
- source-of-truth checks were performed earlier in the session.

Reuse that evidence in the shared brief. It does not replace independent perspective.

Direct mode is for genuinely narrow tasks: one short page, one setting, one broken link, or work whose phases depend tightly on one another.

Always announce the selected mode and one-line reason before substantive review work.

## Explicit invocation, not hopeful delegation

For broad reviews, do not merely describe specialist roles and wait for automatic delegation. Explicitly launch the workstreams concurrently.

### Claude Code plugin agents

When the plugin-provided agents are available, invoke these four required agents in the same wave:

- `documentation-reviewer:technical-truth-reviewer`
- `documentation-reviewer:developer-journey-reviewer`
- `documentation-reviewer:docs-system-reviewer`
- `documentation-reviewer:cognitive-load-reviewer`

Add this fifth agent when its mandate is material:

- `documentation-reviewer:risk-maintainability-reviewer`

The plugin agents are deliberately read-only and use focused system prompts. They are independent reviewers, not mini-coordinators.

### Portable-skill fallback

When the skill was installed without the Claude plugin or the named agents are unavailable, explicitly launch equivalent host-native/general-purpose subagents with the mandates below.

If no subagent mechanism is available, execute the same specialist passes sequentially and record that limitation. Do not pretend sequential passes were independent parallel reviews.

## Shared review brief

Before launching specialists, do a shallow orientation and prepare one factual brief containing the relevant subset of:

- user request and review scope;
- intended developer audience and assumed knowledge;
- primary jobs-to-be-done;
- documentation paths and navigation structure;
- project instructions/style conventions;
- likely sources of truth such as implementation, `action.yml`, schemas, tests, configuration, release notes, and CI;
- MkDocs configuration and known build result;
- supported versions/environments;
- explicit exclusions/limitations;
- fresh verified evidence from the current session that specialists may reuse.

Do not pre-decide findings in the shared brief.

## Specialist mandates

### Technical truth

Verify factual alignment between documentation and software behavior:

- commands, flags, defaults, inputs, outputs, types, limits, validation;
- API/Action/schema/configuration reference;
- permissions, authentication, environment assumptions, compatibility;
- contradictions among docs, tests, metadata, schemas, and implementation;
- stale or unverifiable claims.

Primary implementation evidence outranks documentation consensus.

### Developer journeys and information architecture

Trace whether developers can find and complete real work:

- landing-page orientation and first success;
- getting started/tutorial flow;
- common how-to journeys;
- reference lookup;
- troubleshooting/recovery;
- upgrade/change discoverability;
- navigation, headings, search language, cross-links, orphaned content, page boundaries.

Judge task success, not taxonomy symmetry.

### Examples and documentation system

Review:

- example completeness, copyability, placeholders, context, expected results;
- links and anchors;
- `mkdocs.yml`, navigation, search, repo/edit integration;
- Markdown extensions and Material syntax compatibility;
- docs CI/build checks and dependency reproducibility;
- whether tabs, admonitions, grids, diagrams, icons, and highlighting help comprehension.

Do not rerun shared expensive validation unless assigned by the coordinator.

### Cognitive load

Identify avoidable documentation-created mental burden:

- distant prerequisites and forward references;
- unexplained alternatives and premature choices;
- page hopping required to complete one task;
- terminology churn and mental translation;
- constraints revealed too late;
- examples that mix required and optional concepts;
- visual/structural overload.

Distinguish intrinsic domain complexity from avoidable documentation complexity. Report concrete load hotspots, not `this feels dense` opinions.

### Risk and maintainability

Use when material. Review:

- secrets, least privilege, destructive actions, untrusted input, supply-chain risk;
- accessibility of headings, links, tables, visuals, and custom components;
- compatibility/versioning/deprecation guidance;
- generated/source-derived docs and drift risk;
- CI quality gates, dependency pinning, regeneration and contribution paths.

## Specialist output contract

Each specialist returns candidate findings only, not a complete review or scorecard.

```text
Title: concise issue name
Suggested severity: Critical | High | Medium | Low
Where: file:line, page/heading, or configuration path
Evidence: exact observed fact and relevant source evidence
Developer impact: concrete effect on a developer
Suggested fix: smallest useful correction
Confidence: 0-100
Status: verified | unverified
```

Also report important checks explicitly examined with no issue so the coordinator can distinguish coverage from silence.

Confidence guidance:

- **0-25**: speculation/likely false positive;
- **26-50**: plausible but weakly verified;
- **51-79**: concrete issue with credible evidence/impact;
- **80-94**: strongly verified and likely to affect developers;
- **95-100**: directly confirmed by primary evidence or an unavoidable task-flow failure.

## Merge and adjudication

Wait for all required specialist workstreams to return or fail before synthesis.

Then:

1. **Normalize** all candidate findings.
2. **Deduplicate** shared root causes. Preserve the strongest evidence and smallest useful fix.
3. **Resolve factual disagreements** against primary source-of-truth evidence.
4. **Use corroboration to raise confidence, not severity.**
5. **Re-evaluate severity** based on actual developer impact, not specialist voting or averaging.
6. **Independently verify Critical/High candidates** and require final confidence of at least 80.
7. **Drop weak taste-based Medium/Low findings.** Cognitive-load observations below 80 normally stay out of scored findings unless explicitly framed as usability-testing hypotheses.
8. **Score once** after the merged finding set is stable. Never average specialist scorecards.

Cognitive load is cross-cutting. Map a validated load hotspot to the rubric category whose impact it explains and do not deduct twice for one root cause.

## Failure and override handling

A broad review may use direct/sequential execution only when:

- the user explicitly requests no subagents;
- the host has no usable subagent mechanism;
- subagent invocation is disabled or fails due to permissions/runtime limitations.

State the reason and include it under validation limits. `I already reviewed this recently` is not a valid broad-review override.

If one specialist fails, continue with successful workstreams when possible, record the coverage gap, and do not invent findings for the missing perspective.

## Efficiency rules

- Launch independent specialists in one parallel wave.
- Use one shared orientation brief instead of making each agent rediscover the repository.
- Keep mandates distinct enough to reduce duplicate full-repository scans.
- Reuse verified coordinator evidence without treating it as independent corroboration.
- Run shared builds/expensive validation once.
- Prefer four focused required specialists over a swarm of tiny agents.
- Add the risk/maintainability agent only when its perspective is material.
