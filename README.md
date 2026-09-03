# Developer Documentation Reviewer

A portable AI coding skill for reviewing **developer-facing software documentation**, with first-class support for **MkDocs** and **Material for MkDocs**.

Use it to find documentation problems that make developers fail, guess, backtrack, or lose trust: incorrect examples, missing prerequisites, weak task guidance, confusing navigation, stale reference material, unsupported MkDocs syntax, high cognitive load, and more.

## What you get

A review focuses on the issues that matter to developers, not cosmetic nitpicks. It produces:

- prioritized **Critical / High / Medium / Low** findings
- evidence tied to documentation and source-of-truth files
- concrete fixes instead of vague advice
- a weighted **100-point documentation scorecard**
- coverage of onboarding, common tasks, reference, troubleshooting, accessibility, security, and maintainability
- dedicated **cognitive-load analysis** for avoidable mental effort
- MkDocs and Material-specific checks for navigation, extensions, rendering, CI, links, and reproducibility

For larger documentation sets, the skill can automatically fan out parallel specialist reviewers and merge their findings into one verified assessment. Small reviews stay lightweight.

## Quick start

### Claude Code

Install the repository as a native Claude Code plugin:

```bash
claude plugin marketplace add peterpanne/documentation-reviewer-skill
claude plugin install documentation-reviewer@documentation-reviewer-skill
```

Then ask Claude Code something like:

```text
Review the documentation in this repository for developers.
Focus on the main user journeys, technical accuracy, and avoidable cognitive load.
Do not change files.
```

### Other AI coding tools

The repository also uses the portable `skills/<skill-name>/SKILL.md` layout and can be installed with GitHub CLI's `gh skill` support.

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent <agent-id>
```

Run `gh skill install --help` to see the agent IDs supported by your installed GitHub CLI version.

To install for your user account instead of only the current project:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent claude-code \
  --scope user
```

### Updating

Update an installed skill to the latest version from its recorded source:

```bash
gh skill update reviewing-developer-documentation
```

## What the reviewer checks

### Can developers trust the docs?

The reviewer cross-checks important claims against likely sources of truth such as implementation code, tests, schemas, `action.yml`, configuration definitions, and release behavior.

It looks for stale defaults, wrong flags, invalid commands, incorrect examples, missing permissions, contradictory pages, unsupported versions, and claims that cannot be verified.

### Can developers complete real tasks?

The review follows important developer journeys such as:

- first successful setup
- common day-to-day tasks
- configuration and reference lookup
- failure recovery and troubleshooting
- upgrades, compatibility, and version changes

Pages are judged by their purpose. A how-to is reviewed differently from a reference page, tutorial, explanation, troubleshooting page, or landing page.

### Is the documentation easy to think through?

A dedicated cognitive-load pass checks for avoidable mental effort, including:

- hidden or distant prerequisites
- too many unexplained choices before the main task
- information scattered across several pages
- forward references and poorly sequenced concepts
- inconsistent terminology
- examples that make developers mentally combine incomplete fragments
- tabs, diagrams, tables, or admonitions that add complexity instead of reducing it

The reviewer distinguishes **real product complexity** from complexity introduced by the documentation. A sophisticated system is not penalized merely for being sophisticated.

### Does the MkDocs site actually support the authored content?

For MkDocs and Material for MkDocs projects, the skill checks areas such as:

- `mkdocs.yml` navigation and site metadata
- search and repository/edit integration
- Markdown extensions and Material syntax compatibility
- internal links and anchors
- code examples and fenced-block configuration
- strict builds and documentation CI
- dependency reproducibility
- accessibility of authored content and custom components

It does not recommend Material features simply because they exist. Features should solve a reader or maintenance problem.

## How reviews work

The skill adapts the review strategy to the size of the task.

For a small page or narrow configuration question, one reviewer works directly. For a substantial site or documentation PR, the skill can split independent work across specialists for:

- technical truth and source alignment
- developer journeys and information architecture
- examples and documentation-system behavior
- cognitive load
- security, accessibility, compatibility, and maintainability when relevant

The coordinator then deduplicates overlapping findings, resolves disagreements against primary evidence, verifies high-impact findings, and creates one final scorecard. Multiple agents finding the same issue increases confidence, not severity.

## Example prompts

```text
Review all developer documentation in this repository and give me the highest-impact improvements first.
```

```text
Review this documentation PR. Cross-check changed examples and reference material against the implementation and action metadata.
```

```text
Review mkdocs.yml and the documentation information architecture. Suggest the smallest changes that would improve findability and first-time success.
```

```text
Review our getting-started flow specifically for cognitive load. Show where a new developer has to guess, remember too much, or jump between pages.
```

```text
Review the docs, then implement only the Critical and High findings.
```

## Example finding

```text
[High] Quickstart uses the wrong default deployment mode

Where: docs/getting-started.md → "Deploy"
Evidence: The page says `mode` defaults to `deploy`, while `action.yml` defines the default as `template`.
Impact: A copied quickstart behaves differently from what the developer is told to expect.
Fix: Correct the documented default and check the same value in other examples/reference pages.
```

## Review philosophy

The skill favors a small number of consequential findings over an encyclopedia of preferences.

A good review should answer three questions:

1. **What is wrong or unnecessarily difficult?**
2. **Why does it matter to a developer?**
3. **What is the smallest useful fix?**

The review model is informed by developer-documentation practices including Diátaxis, Google developer documentation guidance, MkDocs and Material conventions, and Anthropic's Agent Skills guidance.

## Manual installation

If you prefer not to use an installer, copy:

```text
skills/reviewing-developer-documentation/
```

into a project as:

```text
.claude/skills/reviewing-developer-documentation/
```

or into your personal Claude Code skills directory:

```text
~/.claude/skills/reviewing-developer-documentation/
```

## For maintainers

Validate the portable skill metadata with:

```bash
gh skill publish --dry-run
```

Evaluation scenarios live under `evals/` and cover source-of-truth drift, developer journeys, page-type behavior, MkDocs rendering, cognitive load, parallel review behavior, confidence filtering, and false-positive resistance.

Repository structure:

```text
.claude-plugin/
├── marketplace.json
└── plugin.json
skills/
└── reviewing-developer-documentation/
    ├── SKILL.md
    └── reference/
        ├── cognitive-load-review.md
        ├── mkdocs-review.md
        ├── page-type-checks.md
        ├── parallel-review.md
        └── review-rubric.md
evals/
├── cognitive-load-evals.json
└── evals.json
```

For stronger evaluation, compare representative prompts with and without the skill enabled and repeat across the coding agents or models you intend to support.
