# Cognitive-load review

Use this reference when reviewing how mentally demanding the documentation is for a developer trying to complete real work.

The goal is not to make complex software look artificially simple. Distinguish **intrinsic complexity** of the product/domain from **avoidable cognitive load introduced by the documentation**. Flag the latter.

## Core question

For each important developer journey, ask:

> How much information must the developer remember, infer, reconcile, or mentally simulate at the same time before they can make the next correct decision?

Prefer evidence from the actual task flow over subjective statements such as "this feels dense."

## What to inspect

### Working-memory burden

Look for places where the reader must hold several unresolved facts in mind at once:

- prerequisites introduced far from the step that needs them;
- multiple variables, file paths, names, IDs, or modes that must be remembered across sections;
- configuration fragments that only make sense after mentally combining several distant examples;
- steps that refer to concepts not yet explained;
- instructions that require remembering an earlier exception or caveat without restating it at the decision point.

Prefer local context, complete examples, meaningful defaults, and reminders at decision points.

### Decision load

Count meaningful choices, not buttons or headings.

Flag avoidable decision burden such as:

- several approaches presented before explaining which one most developers should choose;
- alternatives with no comparison criteria;
- configuration options exposed before the reader needs them;
- optional tuning mixed into the critical path;
- branches whose conditions are unclear or use different terminology from the rest of the docs.

A choice is not a problem when the product genuinely requires it and the documentation gives the reader enough information to decide quickly.

### Context switching

Trace how often a developer must leave the current flow to gather information elsewhere.

Examples of avoidable switching:

- a quickstart that repeatedly sends readers to reference pages to discover required values;
- a task guide that requires bouncing among several pages to assemble one command;
- prerequisites, permissions, compatibility limits, and verification steps scattered across unrelated sections;
- examples whose required schema or environment assumptions are documented elsewhere but not linked at the point of need.

Do not treat every link as harmful. Cross-links are useful when they provide optional depth without interrupting the main path.

### Terminology load

Check whether the documentation forces readers to translate between names or learn vocabulary before it is useful.

Flag:

- multiple names for the same concept without an explicit relationship;
- abbreviations used before expansion when the audience cannot safely be assumed to know them;
- product-internal or implementation terminology used where user-facing task language would be clearer;
- headings, navigation labels, examples, and reference fields that use inconsistent terms for the same thing;
- dense introductions that define many concepts before the reader has a concrete reason to care about them.

Do not recommend removing precise domain terms that developers need. Prefer defining them at first useful contact and then using them consistently.

### Information sequencing

Check whether information appears when it becomes actionable.

Useful sequencing often follows:

**goal → minimum prerequisites → action → immediate explanation when needed → verification → optional depth**

Potential load hotspots include:

- long conceptual preambles before a simple first success;
- warnings after the destructive or security-sensitive step they qualify;
- important constraints only revealed after an example;
- reference-level detail embedded inside a task flow;
- troubleshooting instructions that require understanding implementation internals before trying basic diagnostics.

### Example complexity

Review examples as cognitive tools, not decoration.

Check whether examples:

- start with the smallest complete case that demonstrates the task;
- introduce one important variation at a time;
- clearly distinguish required lines from optional customization;
- use consistent placeholder names;
- show where the example belongs;
- provide an observable result so the reader can close the mental loop;
- avoid mixing several independent concepts into one "complete" example when smaller staged examples would teach better.

A realistic example can be large when the task genuinely requires it. The issue is unexplained complexity, not line count.

### Visual and structural load

Assess whether formatting helps readers chunk information or instead creates more objects to interpret.

Flag cases where:

- tabs hide sequential steps or important prerequisites;
- admonitions interrupt nearly every paragraph so nothing has visual priority;
- tables force readers to scan large matrices for a simple recommendation;
- diagrams introduce more labels/arrows than the prose they replace;
- deeply nested headings fragment one coherent procedure;
- code blocks mix commands, output, placeholders, and commentary without clear separation.

## Journey-level checks

### First success

Estimate the number of unresolved decisions and external lookups required before a developer can observe success.

High-value improvements often include:

- one recommended default path;
- prerequisites adjacent to setup;
- a minimal complete example;
- explicit placeholders;
- immediate verification;
- optional complexity moved after first success.

### Common task

Check whether an experienced developer can scan directly to the action without rereading introductory material or reconstructing context from multiple pages.

### Reference lookup

Reference should reduce memory burden by making exact facts easy to retrieve. Flag fields/options whose type, default, constraints, semantics, or relationships must be inferred from prose or examples.

### Troubleshooting

Troubleshooting should reduce search space. Prefer symptom/error → likely cause → diagnostic evidence → fix → verification. Flag pages that present a flat list of possible causes without helping the developer narrow them.

## Reporting cognitive-load findings

Do not report "high cognitive load" by itself. Identify the concrete avoidable burden.

Use this format:

```text
Load hotspot: concise description
Journey: first success | common task | reference | troubleshooting | other
Where: page/section or path:line
Burden: what the developer must remember, infer, reconcile, or decide
Evidence: concrete structure/content that creates the burden
Impact: likely mistake, delay, backtracking, or abandonment
Fix: smallest change that removes avoidable load
Confidence: 0-100
```

Useful fixes include reordering information, adding a recommended default, colocating prerequisites, splitting unrelated decisions, making an example complete, adding a decision table, naming the condition for a branch, or moving optional detail out of the critical path.

## Confidence guidance

Use confidence to distinguish observable load problems from taste:

- **0-25**: mostly stylistic preference or unsupported intuition;
- **26-50**: plausible burden but weak evidence that it affects a real developer journey;
- **51-79**: concrete avoidable burden with credible developer impact;
- **80-94**: strong evidence from the task flow that developers must remember, infer, backtrack, or make unclear decisions;
- **95-100**: direct, repeatable evidence such as required information appearing only after use, contradictory terminology, or a primary task that cannot be completed without reconstructing missing context.

Prefer reporting findings at 80+ confidence. A lower-confidence observation may still be useful as a non-scored note when it reveals a pattern worth usability testing.

## Scoring relationship

Cognitive load is a **cross-cutting lens**, not a separate weighted category in `review-rubric.md`.

Map validated cognitive-load findings to the category whose user impact they explain, for example:

- too many guesses before first success → First success and primary task completion;
- repeated page hopping → Information architecture and findability;
- reference facts that must be inferred → Reference completeness and precision;
- complex examples with unclear required/optional parts → Examples and verification;
- inconsistent terms and overpacked prose → Writing clarity and terminology;
- troubleshooting that does not narrow causes → Troubleshooting and recovery.

Do not deduct twice for the same root cause merely because it affects cognitive load and another rubric category.
