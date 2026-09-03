# Page-type review checks

Use these checks after identifying what job a page is supposed to do. Apply the contract that matches the reader need rather than requiring every page to contain every element.

Page types are functional categories, not mandatory navigation labels. A small site may combine several needs on one page if each need remains easy to find and use.

## Landing / overview

A strong landing or section-overview page should quickly establish:

- what the software, component, or section is;
- who it is for and the knowledge it assumes;
- why or when a developer would use it;
- the primary supported workflows or choices;
- the clearest next action for a new or returning developer.

Review whether the page routes readers toward useful journeys instead of making them decode the repository structure.

Do not require marketing-style problem/solution sections, cards, buttons, hidden tables of contents, or other visual patterns unless they improve navigation or comprehension.

## Getting started / tutorial

A first-success path should usually include:

- concise prerequisites;
- installation or setup steps with enough context to know where commands/configuration belong;
- the smallest complete example that exercises the core value;
- an observable success criterion or expected result;
- a clear transition to common real-world tasks and complete reference material.

Flag hidden prerequisites, unexplained placeholders, large detours before first success, or examples that require guessing to complete.

## How-to / task guide

A how-to should be centered on one recognizable outcome. Check for:

- a clear task/result in the title and opening;
- prerequisites that are specific to the task;
- ordered, actionable steps;
- exact commands, configuration, API calls, or code with enough surrounding context to apply them;
- explicit branching when steps differ by environment, language, deployment mode, or other real variant;
- verification or observable success criteria when success is not self-evident;
- task-specific failure cases when they are common or costly;
- relevant next steps rather than a generic link dump.

A procedure that changes state but gives the developer no practical way to confirm the result is incomplete when verification is feasible.

Do not penalize a short task merely for lacking sections that add no value.

## Concept / explanation

Explanation should build a useful mental model rather than repeat reference facts. Check whether it:

- explains why the concept matters to a developer;
- establishes the mental model before implementation detail;
- describes relationships among important components or stages;
- makes constraints, assumptions, trade-offs, or lifecycle behavior clear where they affect decisions;
- distinguishes similar concepts that developers are likely to confuse;
- links to task guidance and reference at the point where the reader is ready to act.

Architecture diagrams should exist only when relationships, flows, states, or interactions are materially clearer visually than in prose.

## Reference

Reference material should optimize precise lookup. For each public command, API operation, action input/output, configuration field, schema field, or comparable surface, check for the relevant subset of:

- exact name and syntax;
- type/shape;
- required versus optional status;
- default value;
- allowed values, limits, and validation constraints;
- semantics and side effects;
- permissions or authentication requirements;
- outputs/return behavior;
- failure behavior when important;
- a concise realistic example when syntax alone is insufficient.

Cross-check these facts against source-of-truth files. Prefer generated or source-derived reference when manual duplication is likely to drift.

Reference pages should not bury required facts inside narrative prose or force developers to infer defaults from examples.

## Troubleshooting

Prefer guidance that a developer can enter through a symptom or searchable error. A useful troubleshooting item commonly follows:

**symptom or error → likely cause → diagnostic evidence → fix → verification**

Check that:

- headings include recognizable symptoms, error messages, or affected operations;
- diagnostic steps help distinguish plausible causes instead of immediately prescribing random fixes;
- commands and log locations are verified against the repository/product;
- fixes state relevant risk or destructive effects;
- the developer can tell whether recovery succeeded;
- an escalation/support path exists where self-service reasonably ends.

Do not require a standalone troubleshooting page when a small number of well-placed entries serve users better.

## FAQ

FAQ content is useful when it reflects recurring uncertainty, not as a bucket for information that lacks a home. Check that:

- questions use language developers actually ask or search for;
- answers are concise and self-contained;
- important setup, security, compatibility, or reference information is not available only inside an FAQ;
- repeated questions point to canonical task/reference pages rather than duplicating large instructions;
- collapsible UI, when used, does not hide information that should be readily visible and is supported by the site's MkDocs configuration.

Do not require collapsible details or a particular admonition type as a universal FAQ style.

## Page-level mechanical checks

Apply repository conventions first, then check generally useful mechanics:

- fenced code blocks use an appropriate language identifier where syntax highlighting is meaningful;
- internal links resolve and anchors target existing headings;
- non-standard MkDocs/Material syntax is enabled by the active configuration;
- heading hierarchy is coherent and does not use heading levels merely for visual sizing;
- tables contain genuinely tabular/comparative information and remain readable;
- important new pages are reachable from navigation or meaningful cross-links;
- examples do not name commands, flags, config keys, file paths, URLs, or page links that cannot be verified.

Treat house-style preferences such as line-length limits, exact heading counts, mandatory relative links, or mandatory collapsible FAQ formatting as requirements only when the repository documents those conventions.
