# MkDocs and Material for MkDocs review guide

Use this reference when the project is built with MkDocs, especially Material for MkDocs.

## Configuration checks

Inspect `mkdocs.yml` / `mkdocs.yaml` for:

- `site_name`: recognizable product/project name;
- `site_description`: concise description using search-friendly developer terminology;
- `site_url`: correct canonical deployment URL;
- `repo_url`, `repo_name`, and `edit_uri`: useful source/edit affordances;
- `nav`: reflects developer tasks and content hierarchy;
- search: enabled and useful for the site's language/content;
- theme features: chosen deliberately, not accumulated as decoration;
- Markdown extensions: only those needed by authored content, with fenced code/diagrams configured correctly;
- plugins and dependencies: pinned/reproducible enough for CI;
- versioning: present when multiple supported software versions require different docs.

Do not recommend a feature simply because Material offers it. Recommend it only when it fixes a reader or maintenance problem.

## Strong default navigation for a developer tool

Adapt to the product rather than copying literally:

```yaml
nav:
  - Home: index.md
  - Getting started: getting-started.md
  - Guides:
      - <Common workflow 1>: guides/workflow-1.md
      - <Common workflow 2>: guides/workflow-2.md
  - Concepts:
      - Overview: concepts/index.md
  - Reference:
      - Actions: reference/actions.md
      - Schemas: reference/schemas.md
  - Troubleshooting: troubleshooting.md
  - Contributing: contributing.md
```

For a small project, fewer pages are better if one page can cleanly satisfy a reader need. Avoid empty taxonomy.

## Landing page checks

A strong `index.md` should usually answer, above the fold or shortly after:

1. What is this?
2. Why/when would a developer use it?
3. What are the prerequisites?
4. What is the shortest working example?
5. What should success look like?
6. Where do I go for common workflows, complete reference, and troubleshooting?

Do not turn the landing page into a complete reference dump.

## Navigation and search

Check that:

- top-level labels use user language, not repository-internal names;
- important pages are in `nav` or intentionally discoverable through clear links/search;
- page titles/headings contain terms users will search for, including important errors or feature names;
- cross-links connect concepts → guides → reference where a decision is made;
- headings are stable enough to serve as anchors;
- there are no duplicate pages competing for the same query without a clear distinction.

## Code blocks and developer examples

Check for:

- correct language identifiers (`yaml`, `bash`, `json`, etc.);
- copy buttons only on blocks where copying the full block is sensible;
- tabs used for true alternatives, not to hide sequential steps;
- tab labels that make the choice explicit;
- Mermaid diagrams that add understanding and have nearby textual explanation for accessibility;
- annotations/admonitions used sparingly for important constraints, warnings, and context.

## Mechanical quality gates

Prefer the project's own CI/build command. Otherwise, when available:

```bash
mkdocs build --strict
```

Review whether CI should fail on warnings and broken internal links/navigation. When supported by the installed MkDocs version, link/nav validation settings can strengthen this gate.

Also inspect for:

- orphaned Markdown files;
- nav entries pointing to missing files;
- stale links to renamed headings/pages;
- documentation warnings hidden by permissive configuration;
- generated docs checked in without a clear regeneration process.

## Reproducibility and ecosystem compatibility

- Determine the installed/pinned MkDocs and Material versions from lockfiles or project metadata.
- Flag unbounded dependency ranges when a future major version could break the site.
- If toolchain lifecycle or compatibility is material to the review, verify current upstream status rather than relying on remembered version facts.
- Avoid recommending a migration solely because a newer tool exists. Tie migration advice to maintenance, security, compatibility, or team needs.

## Accessibility with Material

Material provides accessible foundations, but authored content can still break them. Check:

- semantic heading order;
- alt text or equivalent prose for meaningful visuals;
- descriptive link text;
- no color/icon/direction-only instructions;
- custom HTML, CSS, and JavaScript do not remove keyboard or screen-reader usability;
- large tables remain usable on mobile/narrow widths.

## Suggested changes for a sparse reference-heavy site

If navigation currently resembles:

```yaml
nav:
  - Home: index.md
  - Actions Reference: actions.md
  - Schemas: schemas.md
  - Contributing: contributing.md
```

first inspect `index.md`, `actions.md`, and `schemas.md`. Only then recommend additions. Common gaps to test for are:

- a dedicated getting-started path;
- task-oriented guides for each major workflow/mode;
- “which mode should I use?” conceptual guidance;
- troubleshooting based on real errors;
- compatibility/version behavior;
- examples that connect reference fields to a complete GitHub Actions workflow.

A good next structure may be:

```yaml
nav:
  - Home: index.md
  - Getting started: getting-started.md
  - Guides:
      - Helm workflows: guides/helm.md
      - Kustomize workflows: guides/kustomize.md
      - Kubernetes manifests: guides/manifests.md
  - Reference:
      - Actions: actions.md
      - Schemas: schemas.md
  - Troubleshooting: troubleshooting.md
  - Contributing: contributing.md
```

Keep this compact if the project does not have enough content to justify every page.
