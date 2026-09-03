# Parallel review orchestration

Use this workflow for substantial documentation reviews when the host exposes subagents or another mechanism for independent parallel work.

The goal is not to maximize agent count. The goal is to reduce wall-clock time and improve coverage by separating independent review dimensions, while keeping one coordinator responsible for evidence quality, severity, confidence, deduplication, and the final verdict.

## When to fan out

Use parallel review when the host supports it and any of these conditions apply:

- the user asks for a full or broad documentation-site review
- a documentation PR changes multiple page types or source-of-truth surfaces
- the repository exposes several actions/APIs/schemas plus task guidance
- at least three independent review dimensions are materially relevant, such as correctness, information architecture, examples, cognitive load, MkDocs mechanics, or risk/maintainability

A small site can still require parallel review. Page count is not the deciding factor when the request is broad and several independent perspectives are useful.

Fresh coordinator context is reusable evidence, not a substitute for independent review. If the coordinator recently edited the docs, already ran source-of-truth checks, or has a successful `mkdocs build --strict` result from the same session, reuse that information in the shared brief and avoid repeating the same mechanical work. Do not use familiarity with the repository as a reason to skip specialist fan-out for a broad review.

Work directly instead only when the request itself is genuinely narrow or tightly sequential, for example:

- one short page with one clear question
- a single broken link or wording issue
- a narrow `mkdocs.yml` setting check
- work where each step depends heavily on the previous step's result

If subagents are unavailable, perform the same specialist passes sequentially. Do not silently reinterpret a broad review as a narrow one merely because parallel execution is unavailable or the coordinator already has context.

Before substantive review work, state the chosen mode and one-line reason to the user. Keep this about orchestration, not internal identities, for example: `Review mode: parallel — this is a full-site review with several independent dimensions.`

Do not spawn subagents merely because the host supports them for genuinely narrow tasks. Parallelism should save time or provide useful independent perspectives.

## Coordinator orientation

Before delegating, the coordinator should do a shallow orientation pass and prepare a shared review brief. Do not make every subagent independently rediscover the project from scratch.

The brief should contain the relevant subset of:

- review scope and user request
- intended developer audience and assumed knowledge
- primary developer jobs-to-be-done
- important documentation paths and navigation structure
- project-specific instructions/style conventions
- likely sources of truth such as implementation, `action.yml`, schemas, tests, configuration definitions, release notes, and CI
- MkDocs configuration/build command
- supported versions/environments if known
- explicit exclusions or validation limitations
- fresh evidence already gathered by the coordinator that specialists can rely on without duplicating the same mechanical check

Keep the brief factual. Do not pre-decide findings for the specialists.

## Default specialist fan-out

For a broad review, launch four specialists concurrently by default. Add the fifth specialist when security, accessibility, compatibility, or long-term maintenance is materially relevant. Give each the same shared brief plus one distinct mandate.

### 1. Technical truth reviewer

Focus on factual alignment between documentation and software behavior.

Review:

- commands, flags, names, defaults, inputs, outputs, types, limits, and validation behavior
- action/API/schema/configuration reference accuracy
- permissions, authentication, environment assumptions, and supported versions
- contradictions between docs, examples, tests, metadata, schemas, and implementation
- stale or unverifiable claims

Prefer source-of-truth evidence over documentation consensus. Two docs repeating the same stale value do not make it true.

### 2. Developer journey and information-architecture reviewer

Focus on whether developers can find and complete real work.

Review:

- landing-page orientation and first success
- getting started/tutorial flow
- common how-to journeys
- troubleshooting and failure recovery
- upgrade/change/compatibility discoverability
- navigation, search language, cross-links, orphaned content, and page boundaries
- page-type contracts from `page-type-checks.md`

Do not impose a framework taxonomy merely for symmetry. Judge the actual journeys.

### 3. Examples and documentation-system reviewer

Focus on executable examples and the MkDocs delivery system.

Review:

- completeness, copyability, placeholders, expected results, and verification steps in examples
- code-fence languages and contextual placement of files/commands
- internal links and anchors
- `mkdocs.yml`, navigation, search, repository/edit links, extensions, Material syntax compatibility, build/CI checks, and dependency reproducibility
- whether tabs, admonitions, grids, diagrams, icons, and highlighting improve comprehension

Use `mkdocs-review.md` for detailed checks.

### 4. Cognitive-load reviewer

Focus on the amount of information a developer must remember, infer, reconcile, or mentally simulate before taking the next correct action.

Use `cognitive-load-review.md` as the detailed contract.

Review especially:

- working-memory burden from distant prerequisites, forward references, and incomplete fragments
- decision load from unexplained alternatives, premature options, and unclear branching criteria
- context switching between pages required to complete one primary task
- terminology churn or implementation language that forces mental translation
- information sequencing, including constraints revealed after the action they qualify
- example complexity and whether required versus optional details are distinguishable
- structural/visual overload from tabs, admonitions, tables, diagrams, or deeply fragmented sections

Distinguish intrinsic product/domain complexity from avoidable complexity introduced by the documentation. Do not flag a difficult concept merely because the underlying software is difficult.

Report concrete load hotspots and their likely developer effect. Avoid subjective findings such as "this page feels dense" without evidence from a real task flow.

### 5. Risk and maintainability reviewer

Use this specialist when security, accessibility, compatibility, or long-term maintenance is materially relevant.

Review:

- secret handling, least privilege, destructive operations, untrusted input, and supply-chain implications
- accessibility of headings, links, tables, images, diagrams, custom HTML, and non-text cues
- compatibility/versioning/deprecation guidance
- generated/source-derived documentation and drift risk
- CI quality gates, dependency pinning, regeneration/contribution paths, and documentation-change expectations

For smaller reviews, fold this mandate into the other specialists rather than spawning an extra agent.

## Specialist output contract

Each specialist should return findings only from its mandate, not a complete final review.

For every proposed finding include:

```text
Title: concise issue name
Suggested severity: Critical | High | Medium | Low
Where: file:line, page/heading, or configuration path
Evidence: exact observed fact and relevant source-of-truth evidence
Developer impact: concrete effect on a developer
Suggested fix: smallest useful correction
Confidence: 0-100
Status: verified | unverified
```

Also include a short `No issue found` note for important checks that were explicitly examined and passed. This helps the coordinator distinguish coverage from silence.

### Confidence scale

Use confidence independently from severity:

- **0**: false positive or unsupported speculation
- **25**: plausible but weakly supported and not verified
- **50**: real issue is likely, but evidence or practical impact is limited
- **75**: strongly supported and likely to affect developers in practice
- **100**: directly confirmed by primary evidence or an unavoidable task-flow failure

Intermediate scores are allowed. Do not inflate confidence because multiple specialists repeat the same assumption.

Specialists must:

- read relevant files before making code/configuration claims
- avoid editing files during review mode
- avoid scoring the whole documentation site
- avoid duplicating another specialist's mandate unless cross-domain evidence is necessary
- mark uncertain claims as unverified instead of filling gaps by inference
- report only findings with developer or maintenance impact, not cosmetic preferences

## Merge and adjudication

The coordinator owns the final review. Never concatenate specialist reports verbatim.

### Normalize

Convert all candidate findings to the common finding format. Remove commentary that does not support a finding or an explicit passed check.

### Deduplicate

Merge findings that describe the same root cause. Preserve the strongest evidence and the most useful fix.

Independent detection by multiple specialists may increase confidence after verification, but never severity by itself. Never count the same issue twice in the scorecard.

### Resolve disagreements

When specialists disagree on a fact, severity, confidence, or recommendation:

1. inspect the primary source of truth directly
2. prefer verified repository/product evidence over opinion or documentation consensus
3. distinguish factual disagreement from prioritization disagreement
4. if the evidence remains incomplete, keep the finding as `unverified` and lower confidence rather than inventing certainty

For every Critical and High candidate, independently verify the decisive evidence before including it in the final answer and require final confidence of at least 80. If a host supports cheap narrow delegation, a targeted validation subagent may be used for a disputed high-impact claim; otherwise the coordinator should verify it directly.

For Medium and Low findings, drop weakly supported observations that are primarily taste. Cognitive-load observations below 80 confidence should normally be omitted from scored findings unless they reveal a repeatable pattern worth explicitly recommending for usability testing.

### Re-evaluate severity

Specialist severities are suggestions. Reassign severity based on the merged evidence and actual developer impact:

- **Critical**: unsafe or materially wrong guidance with severe consequences
- **High**: blocks or seriously impairs a primary journey or makes core reference unreliable
- **Medium**: recurring friction, ambiguity, poor findability, avoidable cognitive burden, or maintenance risk
- **Low**: limited-impact polish or consistency issue

Corroboration alone must not inflate severity.

### Score once

Apply `review-rubric.md` only after findings are merged and contradictions resolved. The coordinator computes one scorecard for the documentation set. Never average or sum independent agent scorecards.

Cognitive load is a cross-cutting diagnostic, not an extra scoring category. Map a validated load hotspot to the rubric category whose developer impact it explains, and do not deduct twice for one root cause.

### Final synthesis

The final review should read as one coherent expert assessment, not as a meeting transcript. Preserve useful diversity of perspective through evidence and coverage, not by labeling findings with agent names.

## Efficiency rules

- Launch independent specialists in the same parallel wave whenever the host supports concurrent subagents
- Keep specialist mandates non-overlapping enough to avoid multiple full-repository rescans
- Give specialists the shared brief and point them at the most relevant paths, while allowing them to follow evidence where necessary
- Prefer four focused specialists for a broad review over many tiny agents; add the fifth only when its risk/maintainability mandate is material
- Reuse fresh coordinator evidence in the shared brief instead of rerunning identical mechanical checks, but do not count that evidence as an independent specialist perspective
- Do not ask every specialist to run the same build or expensive validation command. Assign shared mechanical checks to one specialist or the coordinator
- Do not block the whole review on a low-impact specialist failure. Record the coverage limitation and continue with verified findings from successful workstreams
- If subagents are unavailable, execute the same specialist passes sequentially and use the same merge rules
