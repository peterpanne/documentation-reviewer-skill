# Developer documentation review skill

A portable Agent Skill for reviewing software documentation written for developers, with additional checks for MkDocs and Material for MkDocs. It can be installed for Claude Code and other Agent Skills-compatible coding tools.

## What it reviews

The skill emphasizes:

- technical correctness and synchronization with source code/configuration;
- time-to-first-success and common developer tasks;
- precise reference documentation;
- copyable, verifiable examples;
- information architecture and searchability;
- troubleshooting and recovery;
- security-sensitive guidance;
- accessibility;
- MkDocs configuration, build validation, and maintainability.

It uses a 100-point weighted rubric but prioritizes actionable findings over the score itself.

## Install with GitHub CLI for different AI coding tools

GitHub CLI can discover this repository through the standard `skills/*/SKILL.md` layout and install the skill into the correct directory for many supported coding agents.

`gh skill` is currently a GitHub CLI public-preview feature. Use GitHub CLI 2.90.0 or newer.

Preview the skill before installing it:

```bash
gh skill preview peterpanne/documentation-reviewer-skill reviewing-developer-documentation
```

Install it into the current project for a specific coding agent:

```bash
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent <agent-id>
```

Examples:

```bash
# GitHub Copilot
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent github-copilot

# Claude Code
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent claude-code

# Cursor
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent cursor

# Codex
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent codex

# Gemini CLI
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent gemini-cli
```

The default scope is the current project. To make the skill available across projects for an agent, use user scope:

```bash
gh skill install peterpanne/documentation-reviewer-skill reviewing-developer-documentation --agent claude-code --scope user
```

GitHub CLI records source provenance when it installs a skill, so installed copies can later be checked and updated with:

```bash
gh skill update reviewing-developer-documentation
```

Run `gh skill install --help` to see all currently supported `--agent` values.

## Install as a Claude Code plugin

This repository also remains a native Claude Code plugin marketplace.

Add the GitHub repository as a marketplace:

```bash
claude plugin marketplace add peterpanne/documentation-reviewer-skill
```

Then install the plugin:

```bash
claude plugin install documentation-reviewer@documentation-reviewer-skill
```

Restart/reload Claude Code if your current session does not immediately discover the installed skill.

The installed skill is `reviewing-developer-documentation` and is activated automatically when a documentation-review task matches its description.

### Manual project-scoped alternative

If you do not want an installer, copy `skills/reviewing-developer-documentation/` into the target repository as:

```text
.claude/skills/reviewing-developer-documentation/
```

Claude Code discovers project skills from `.claude/skills/` automatically.

For a personal standalone Claude Code skill, copy it to:

```text
~/.claude/skills/reviewing-developer-documentation/
```

## Example prompts

```text
Review the documentation in this repository for developers. Focus on the main user journeys and technical accuracy. Do not change files.
```

```text
Review this documentation PR. Cross-check changed examples and reference material against the implementation and action metadata.
```

```text
Review mkdocs.yml and the documentation information architecture. Suggest the smallest set of changes that would improve findability and first-time success.
```

```text
Review the docs, then implement only the Critical and High findings.
```

## Repository structure

```text
.claude-plugin/
├── marketplace.json
└── plugin.json
skills/
└── reviewing-developer-documentation/
    ├── SKILL.md
    └── reference/
        ├── mkdocs-review.md
        ├── page-type-checks.md
        └── review-rubric.md
evals/
└── evals.json
```

The root `skills/<skill-name>/SKILL.md` layout is intentionally portable. GitHub CLI and Agent Skills-compatible tools can discover it directly, while `.claude-plugin/` provides the additional Claude Code plugin distribution path.

## Validation and evaluation

For maintainers, GitHub CLI can validate repository skills against the Agent Skills specification:

```bash
gh skill publish --dry-run
```

The scenarios in `evals/evals.json` cover developer journeys, source-of-truth drift, page-type behavior, MkDocs rendering compatibility, and house-style boundaries. For stronger skill evaluation, run representative prompts both without the skill and with the skill enabled, compare the results, and repeat across the Claude models you intend to support.

## Design notes

The skill is intentionally concise at the entry point and keeps the scoring rubric, page-type contracts, and MkDocs-specific guidance in one-level-deep reference files. This follows the progressive-disclosure model recommended for Agent Skills.

The review approach is informed by:

- Anthropic Agent Skills authoring guidance: concise entry points, explicit trigger descriptions, progressive disclosure, workflows, feedback loops, and evaluations;
- Diátaxis: distinguish tutorial, how-to, reference, and explanation needs;
- Google developer documentation style guidance: clarity, consistency, developer-oriented code formatting, and accessibility;
- MkDocs and Material for MkDocs guidance: meaningful navigation/search, strict builds, repository/edit integration, versioning when needed, and reproducible documentation builds.

## Repository

https://github.com/peterpanne/documentation-reviewer-skill
