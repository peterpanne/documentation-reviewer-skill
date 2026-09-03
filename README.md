# Developer documentation review skill

A project-scoped Agent Skill for reviewing software documentation written for developers, with additional checks for MkDocs and Material for MkDocs.

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

## Install in Claude Code

Copy the skill directory into the target repository:

```text
.claude/skills/reviewing-developer-documentation/
```

Claude Code discovers project skills from `.claude/skills/` automatically.

For a personal skill, copy the same directory to:

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

## Design notes

The skill is intentionally concise at the entry point and keeps the scoring rubric and MkDocs-specific guidance in one-level-deep reference files. This follows the progressive-disclosure model recommended for Agent Skills.

The review approach is informed by:

- Anthropic Agent Skills authoring guidance: concise entry points, explicit trigger descriptions, progressive disclosure, workflows, feedback loops, and evaluations;
- Diátaxis: distinguish tutorial, how-to, reference, and explanation needs;
- Google developer documentation style guidance: clarity, consistency, developer-oriented code formatting, and accessibility;
- MkDocs and Material for MkDocs guidance: meaningful navigation/search, strict builds, repository/edit integration, versioning when needed, and reproducible documentation builds.

## Repository

This skill is maintained in `peterpanne/documentation-reviewer-skill`.
