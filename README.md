# Developer Documentation Reviewer

A portable AI coding skill for reviewing **developer-facing software documentation**, with first-class support for **MkDocs** and **Material for MkDocs**.

It focuses on problems that make developers fail, guess, backtrack, or lose trust: incorrect examples, missing prerequisites, stale reference material, confusing navigation, unsupported MkDocs syntax, excessive cognitive load, and similar high-impact issues.

## What it reviews

- technical correctness against implementation, schemas, tests, `action.yml`, and configuration;
- first success, common tasks, reference lookup, troubleshooting, and upgrades;
- information architecture, navigation, terminology, and cognitive load;
- copyable examples with clear verification;
- MkDocs/Material configuration, links, extensions, rendering, CI, and reproducibility;
- security, accessibility, compatibility, and maintainability when relevant.

Reviews return prioritized **Critical / High / Medium / Low** findings, concrete fixes, and a weighted 100-point scorecard.

## Install

### Claude Code with `gh skill` (recommended)

The Claude-agent helper requires **GitHub CLI 2.99.0+**.

Install the skill into the current project:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent claude-code
```

Install the five Claude Code reviewer agents:

```bash
gh api \
  repos/peterpanne/documentation-reviewer-skill/contents/skills/reviewing-developer-documentation/scripts/install-claude-agents.sh \
  -H "Accept: application/vnd.github.raw+json" \
  | bash
```

The helper uses `gh skill list` internally to locate the installed skill, resolve its version, and install matching agents into the corresponding `.claude/agents/` directory.

For a user-scoped installation, add `--scope user` to both steps:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent claude-code \
  --scope user

gh api \
  repos/peterpanne/documentation-reviewer-skill/contents/skills/reviewing-developer-documentation/scripts/install-claude-agents.sh \
  -H "Accept: application/vnd.github.raw+json" \
  | bash -s -- --scope user
```

<details>
<summary>PowerShell agent installer</summary>

```powershell
$Installer = gh api `
  repos/peterpanne/documentation-reviewer-skill/contents/skills/reviewing-developer-documentation/scripts/install-claude-agents.ps1 `
  -H "Accept: application/vnd.github.raw+json"

$Installer | pwsh -NoProfile -Command -
```

Pass `-Scope user` for a user-scoped installation.

</details>

### Other AI coding tools

Install the portable skill for any agent supported by your GitHub CLI:

```bash
gh skill install peterpanne/documentation-reviewer-skill \
  reviewing-developer-documentation \
  --agent <agent-id>
```

Run `gh skill install --help` for the available agent IDs. Non-Claude hosts use their own subagent/worker mechanism when available.

### Alternative: native Claude Code plugin

```bash
claude plugin marketplace add peterpanne/documentation-reviewer-skill
claude plugin install documentation-reviewer@documentation-reviewer-skill
```

The plugin bundles the skill and all five Claude Code agents in one install.

## Update skill + agents

Update the installed skill first:

```bash
gh skill update reviewing-developer-documentation --all
```

Then refresh the Claude Code agents so they match the updated skill:

```bash
gh api \
  repos/peterpanne/documentation-reviewer-skill/contents/skills/reviewing-developer-documentation/scripts/install-claude-agents.sh \
  -H "Accept: application/vnd.github.raw+json" \
  | bash -s -- --force
```

For user-scoped Claude agents:

```bash
gh api \
  repos/peterpanne/documentation-reviewer-skill/contents/skills/reviewing-developer-documentation/scripts/install-claude-agents.sh \
  -H "Accept: application/vnd.github.raw+json" \
  | bash -s -- --scope user --force
```

PowerShell users can rerun the `.ps1` installer with `-Force` and, when needed, `-Scope user`.

## Usage

```text
Review all developer documentation in this repository.
Focus on the main user journeys, technical accuracy, and avoidable cognitive load.
Do not change files.
```

Other useful prompts:

```text
Review this documentation PR and cross-check changed examples against the implementation.
```

```text
Review our getting-started flow specifically for cognitive load.
```

```text
Review the docs, then implement only the Critical and High findings.
```

## How parallel review works

Broad/full-site reviews use four independent specialists when subagents are available:

1. **Technical truth**: source alignment, commands, defaults, schemas, compatibility.
2. **Developer journeys**: onboarding, common tasks, troubleshooting, navigation, findability.
3. **Docs system**: examples, links, MkDocs configuration, Material syntax, CI/build behavior.
4. **Cognitive load**: working-memory burden, unclear choices, context switching, terminology, sequencing.

A fifth **risk and maintainability** reviewer is added when relevant.

The coordinator launches required reviewers concurrently, deduplicates overlapping findings, resolves disagreements against primary evidence, verifies high-impact findings, and produces one final scorecard. Small, genuinely narrow reviews stay in direct mode.

## Review philosophy

The skill favors a small number of consequential findings over an encyclopedia of preferences. Each finding should answer:

1. What is wrong or unnecessarily difficult?
2. Why does it matter to a developer?
3. What is the smallest useful fix?

Cognitive load is treated as a cross-cutting diagnostic, not an extra score, so the same root cause is not penalized twice.

## For maintainers

Validate the portable skill metadata with:

```bash
gh skill publish --dry-run
```

Evaluation scenarios live under `evals/` and cover source-of-truth drift, developer journeys, MkDocs rendering, cognitive load, parallel orchestration, confidence filtering, and false-positive resistance.

The main implementation lives in:

```text
skills/reviewing-developer-documentation/
├── SKILL.md
├── scripts/
└── reference/

agents/
├── technical-truth-reviewer.md
├── developer-journey-reviewer.md
├── docs-system-reviewer.md
├── cognitive-load-reviewer.md
└── risk-maintainability-reviewer.md
```
