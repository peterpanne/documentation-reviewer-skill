# Developer Documentation Reviewer

A portable AI coding skill for reviewing **developer-facing software documentation**, with first-class support for **MkDocs** and **Material for MkDocs**.

Use it to find documentation problems that make developers fail, guess, backtrack, or lose trust: incorrect examples, missing prerequisites, weak task guidance, confusing navigation, stale reference material, unsupported MkDocs syntax, excessive cognitive load, and more.

## What you get

The reviewer focuses on problems that matter to developers, not cosmetic nitpicks. A review produces:

- prioritized **Critical / High / Medium / Low** findings;
- evidence tied to documentation and source-of-truth files;
- concrete fixes instead of vague advice;
- a weighted **100-point documentation scorecard**;
- coverage of onboarding, common tasks, reference, troubleshooting, accessibility, security, and maintainability;
- dedicated **cognitive-load analysis** for avoidable mental effort;
- MkDocs and Material-specific checks for navigation, extensions, rendering, CI, links, and reproducibility.

For broad reviews, Claude Code can use dedicated specialist agents to review the documentation independently from different angles and feed one coordinated final assessment.

## Quick start

### Recommended: install with GitHub CLI

The preferred installation method is GitHub CLI's portable `gh skill` support.

Install the skill for Claude Code in the current project:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent claude-code
```

The skill includes an explicit helper for installing the five Claude Code reviewer agents. Locate the installed skill and run the helper:

```bash
SKILL_DIR="$(gh skill list \
  --agent claude-code \
  --scope project \
  --json skillName,path \
  --jq '.[] | select(.skillName == "reviewing-developer-documentation") | .path' \
  | head -n 1)"

bash "$SKILL_DIR/scripts/install-claude-agents.sh"
```

On PowerShell:

```powershell
$SkillDir = gh skill list `
  --agent claude-code `
  --scope project `
  --json skillName,path `
  --jq '.[] | select(.skillName == "reviewing-developer-documentation") | .path' |
  Select-Object -First 1

& "$SkillDir/scripts/install-claude-agents.ps1"
```

The helper installs these Claude agents into the current project's `.claude/agents/` directory:

```text
technical-truth-reviewer
developer-journey-reviewer
docs-system-reviewer
cognitive-load-reviewer
risk-maintainability-reviewer
```

The helper uses the version recorded by `gh skill`, so the skill and agent definitions stay aligned. It refuses to overwrite existing agent files unless you explicitly pass `--force` or `-Force`.

Then ask Claude Code:

```text
Review all developer documentation in this repository.
Focus on the main user journeys, technical accuracy, and avoidable cognitive load.
Do not change files.
```

For a full-site review, the skill explicitly launches the required specialist reviewers in parallel when subagents are available.

### User-scope installation

To make the skill available across projects:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent claude-code \
  --scope user
```

Then install the Claude agents at user scope:

```bash
SKILL_DIR="$(gh skill list \
  --agent claude-code \
  --scope user \
  --json skillName,path \
  --jq '.[] | select(.skillName == "reviewing-developer-documentation") | .path' \
  | head -n 1)"

bash "$SKILL_DIR/scripts/install-claude-agents.sh" --scope user
```

PowerShell uses the same flow with `-Scope user`.

### Other AI coding tools

The skill follows the portable `skills/<skill-name>/SKILL.md` layout and can be installed for other supported coding agents:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent <agent-id>
```

Examples include GitHub Copilot, Cursor, Codex, Gemini CLI, OpenCode, and many others. Run:

```bash
gh skill install --help
```

for the agent IDs supported by your installed GitHub CLI version.

The portable skill adapts to the target tool's own subagent/worker mechanism when available. The helper scripts above are specifically for Claude Code's `.claude/agents` system.

### Updating

Update the skill with:

```bash
gh skill update reviewing-developer-documentation
```

If you installed the Claude agents with the helper, rerun it with overwrite enabled so the agents match the updated skill:

```bash
SKILL_DIR="$(gh skill list \
  --agent claude-code \
  --scope project \
  --json skillName,path \
  --jq '.[] | select(.skillName == "reviewing-developer-documentation") | .path' \
  | head -n 1)"

bash "$SKILL_DIR/scripts/install-claude-agents.sh" --force
```

For user scope, add `--scope user`. PowerShell users can run the `.ps1` helper with `-Force`.

### Alternative: native Claude Code plugin

If you prefer Claude Code's native plugin system, it still installs the skill and bundled agents together:

```bash
claude plugin marketplace add peterpanne/documentation-reviewer-skill
claude plugin install documentation-reviewer@documentation-reviewer-skill
```

With the plugin installation, the agents appear under scoped names such as `documentation-reviewer:technical-truth-reviewer`.

## What the reviewer checks

### Can developers trust the docs?

The reviewer cross-checks important claims against likely sources of truth such as implementation code, tests, schemas, `action.yml`, configuration definitions, and released behavior.

It looks for stale defaults, wrong flags, invalid commands, incorrect examples, missing permissions, contradictory pages, unsupported versions, and claims that cannot be verified.

### Can developers complete real tasks?

The review traces important journeys such as:

- first successful setup;
- common day-to-day tasks;
- configuration and reference lookup;
- failure recovery and troubleshooting;
- upgrades, compatibility, and version changes.

Pages are judged by their purpose. A how-to is reviewed differently from a reference page, tutorial, explanation, troubleshooting page, or landing page.

### Is the documentation easy to think through?

A dedicated cognitive-load pass checks for avoidable mental effort, including:

- hidden or distant prerequisites;
- too many unexplained choices before the main task;
- information scattered across several pages;
- forward references and poorly sequenced concepts;
- inconsistent terminology;
- examples that make developers mentally combine incomplete fragments;
- tabs, diagrams, tables, or admonitions that add complexity instead of reducing it.

The reviewer distinguishes **real product complexity** from complexity introduced by the documentation.

### Does the MkDocs site support the authored content?

For MkDocs and Material for MkDocs projects, the skill checks areas such as:

- `mkdocs.yml` navigation and site metadata;
- search and repository/edit integration;
- Markdown extensions and Material syntax compatibility;
- internal links and anchors;
- code examples and fenced-block configuration;
- strict builds and documentation CI;
- dependency reproducibility;
- accessibility of authored content and custom components.

It does not recommend Material features simply because they exist. Features should solve a reader or maintenance problem.

## Parallel review in Claude Code

A full-site or broad review uses four required independent specialists:

1. **Technical truth**: implementation/source alignment, defaults, commands, schemas, compatibility.
2. **Developer journeys**: onboarding, common tasks, troubleshooting, navigation, findability.
3. **Examples and docs system**: examples, links, MkDocs configuration, Material syntax, CI/build behavior.
4. **Cognitive load**: working-memory burden, unclear choices, context switching, terminology, sequencing.

A fifth **risk and maintainability** reviewer is added when security, accessibility, compatibility, or long-term maintenance is materially relevant.

For qualifying broad reviews, the skill explicitly invokes the available named agents concurrently. Recent edits, a small page count, or an already-passing MkDocs build are not reasons to skip independent review. Fresh evidence is reused in the shared brief so agents do not repeat unnecessary work.

The coordinator then:

- deduplicates overlapping findings;
- resolves disagreements against primary evidence;
- treats multiple detections as increased confidence, not increased severity;
- independently verifies Critical and High findings;
- creates one final scorecard after the merged finding set is stable.

Small, genuinely narrow reviews stay in direct mode instead of paying multi-agent overhead.

## Example prompts

```text
Review all developer documentation in this repository and give me the highest-impact improvements first.
```

```text
Review the documentation from different angles. Cross-check technical truth, developer journeys, MkDocs behavior, and cognitive load.
```

```text
Review this documentation PR. Cross-check changed examples and reference material against the implementation and action metadata.
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

A useful review answers:

1. **What is wrong or unnecessarily difficult?**
2. **Why does it matter to a developer?**
3. **What is the smallest useful fix?**

## For maintainers

Validate portable skill metadata with:

```bash
gh skill publish --dry-run
```

Evaluation scenarios under `evals/` cover source-of-truth drift, developer journeys, page-type behavior, MkDocs rendering, cognitive load, multi-agent fan-out, explicit specialist invocation, confidence filtering, and false-positive resistance.

Repository structure:

```text
.claude-plugin/
├── marketplace.json
└── plugin.json
agents/
├── cognitive-load-reviewer.md
├── developer-journey-reviewer.md
├── docs-system-reviewer.md
├── risk-maintainability-reviewer.md
└── technical-truth-reviewer.md
skills/
└── reviewing-developer-documentation/
    ├── SKILL.md
    ├── scripts/
    │   ├── install-claude-agents.ps1
    │   └── install-claude-agents.sh
    └── reference/
        ├── cognitive-load-review.md
        ├── mkdocs-review.md
        ├── page-type-checks.md
        ├── parallel-review.md
        └── review-rubric.md
evals/
├── cognitive-load-evals.json
├── orchestration-evals.json
└── evals.json
```

For stronger evaluation, compare representative prompts with and without the skill enabled and repeat across the coding agents or models you intend to support.
