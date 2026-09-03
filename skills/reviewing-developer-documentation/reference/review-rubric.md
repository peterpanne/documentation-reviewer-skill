# Developer documentation review rubric

Use the rubric to make reviews consistent. Score each category proportionally to its weight. Reserve full credit for evidence that the documentation actually serves the reader need, not merely for the presence of a page with the right title.

## 1. Technical correctness and source alignment — 18 points

Full-credit signals:

- documented behavior matches implementation, schemas, action metadata, tests, and supported releases;
- names, defaults, required fields, types, outputs, limits, permissions, and failure behavior are accurate;
- no contradictions exist between pages, README, examples, and generated/reference material;
- deprecations and version-specific behavior are clear when applicable;
- claims that cannot be verified are explicitly qualified.

Severe defects include wrong commands, stale option names, incorrect defaults, missing required permissions, or examples that cannot work.

## 2. First success and primary task completion — 15 points

Full-credit signals:

- purpose and value are obvious on the landing page;
- prerequisites are explicit and concise;
- a minimal end-to-end example exists for the main use case;
- examples state where code/config belongs;
- the reader can verify the result;
- next steps point to common real-world workflows rather than dumping the reader into reference material.

Measure time-to-first-success and number of guesses required.

## 3. Reference completeness and precision — 12 points

Full-credit signals:

- all public inputs/options/fields/outputs are discoverable;
- type, required/optional status, default, constraints, semantics, and small examples are provided where useful;
- reference organization mirrors the product/API/configuration structure;
- reference pages remain descriptive and do not bury facts inside tutorials or prose;
- schemas and tables are readable on narrow screens and searchable by terminology developers use.

## 4. Examples and verification — 10 points

Full-credit signals:

- examples are realistic, minimal, copyable, and syntactically complete;
- placeholders are unmistakable;
- secure/default-safe behavior is demonstrated;
- language tags are present on fenced code blocks;
- code and configuration are tested or otherwise kept in sync with the implementation;
- complex examples include expected output, observable effect, or verification steps;
- omitted code is clearly marked rather than silently hidden.

## 5. Information architecture and findability — 10 points

Full-credit signals:

- navigation is organized around developer intent and common workflows;
- learning, how-to, reference, and explanation needs are distinguishable even if not named explicitly;
- page titles and headings use terms developers are likely to search for;
- related pages cross-link at decision points;
- important pages are reachable in a small number of choices;
- there are no orphaned important pages, redundant near-duplicates, or giant mixed-purpose pages.

## 6. Troubleshooting and recovery — 8 points

Full-credit signals:

- common failure modes are documented by symptom or error message;
- guidance explains likely causes, diagnostic steps, and fixes;
- readers know what logs/output to inspect;
- recovery guidance distinguishes configuration mistakes, environmental problems, permissions, unsupported versions, and product defects;
- escalation/support paths are clear when self-service ends.

## 7. Concepts, constraints, and compatibility — 7 points

Full-credit signals:

- developers understand when to use the tool and when not to;
- architecture/data flow is explained only as far as it helps decisions and debugging;
- important trade-offs, limits, assumptions, supported platforms/versions, and interoperability constraints are explicit;
- similar features or modes are compared where developers must choose between them.

## 8. Security and safe usage — 5 points

Full-credit signals:

- examples never encourage committing secrets or broad unnecessary privileges;
- authentication, token/permission requirements, and trust boundaries are explained where relevant;
- examples prefer least privilege and safe defaults;
- documentation calls out risky execution contexts, untrusted input, destructive operations, or supply-chain concerns when relevant;
- secret values in repository fixtures or logs are not reproduced in review output.

## 9. Writing clarity and terminology — 5 points

Full-credit signals:

- concise, direct, active language;
- consistent terminology for the same concept;
- second person is preferred for instructions;
- headings are descriptive and usually sentence case;
- code-related identifiers are formatted as code;
- links use descriptive text rather than “click here”;
- conditions appear before the action they qualify;
- paragraphs and procedures are scannable.

Do not deduct heavily for harmless house-style differences.

## 10. Accessibility — 3 points

Full-credit signals:

- heading hierarchy is semantic;
- meaningful images/diagrams have useful text alternatives or equivalent explanation;
- information is not encoded by color, position, or icon alone;
- link text is meaningful out of context;
- tables are not used when a list would be more accessible;
- custom HTML/components remain keyboard- and screen-reader-friendly where practical.

## 11. MkDocs implementation and maintainability — 7 points

Full-credit signals:

- `mkdocs.yml` metadata, repository/edit links, `site_url`, navigation, search, and Markdown extensions support the content rather than fight it;
- documentation builds in CI and warnings can fail the build where appropriate;
- internal links/nav references are validated;
- documentation dependencies are reproducible and compatible;
- versioned docs are provided when released behavior differs materially across supported versions;
- generated/reference data has a clear source of truth;
- docs changes are expected alongside behavior/configuration changes;
- contribution guidance makes documentation fixes easy.

## Interpreting the total

- **90–100**: highly trustworthy and task-effective; remaining work is mostly refinement.
- **75–89**: solid foundation with meaningful gaps or maintenance risks.
- **60–74**: developers can succeed, but only with avoidable searching, guessing, or external knowledge.
- **40–59**: major journeys or reference areas are unreliable/incomplete.
- **0–39**: documentation is not a dependable interface to the software.

## Quality gates independent of score

Regardless of score, call out these conditions prominently:

- a core example is factually wrong or cannot run;
- required permissions/security behavior are misstated;
- a primary workflow has no successful path through the docs;
- documented configuration contradicts the source of truth;
- the documentation site does not build or contains broken navigation to core pages.
