#!/usr/bin/env bash
set -euo pipefail

REPO="peterpanne/documentation-reviewer-skill"
SKILL_NAME="reviewing-developer-documentation"
SCOPE="project"
REF=""
FORCE=0

AGENTS=(
  "technical-truth-reviewer.md"
  "developer-journey-reviewer.md"
  "docs-system-reviewer.md"
  "cognitive-load-reviewer.md"
  "risk-maintainability-reviewer.md"
)

usage() {
  cat <<'EOF'
Install the documentation reviewer's Claude Code subagents.

The helper uses `gh skill list` to locate the installed skill, determine its
version, and derive the matching Claude Code agents directory.

Usage:
  install-claude-agents.sh [--scope project|user] [--ref <git-ref>] [--force]

Options:
  --scope   Resolve the project- or user-scope Claude Code skill installation.
            Default: project.
  --ref     Fetch agent definitions from a specific tag, branch, or commit.
            By default the helper uses the version reported by `gh skill list`.
  --force   Overwrite existing agent files.
  -h, --help
            Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      [[ $# -ge 2 ]] || { echo "Missing value for --scope" >&2; exit 2; }
      SCOPE="$2"
      shift 2
      ;;
    --ref)
      [[ $# -ge 2 ]] || { echo "Missing value for --ref" >&2; exit 2; }
      REF="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$SCOPE" != "project" && "$SCOPE" != "user" ]]; then
  echo "--scope must be 'project' or 'user'" >&2
  exit 2
fi

command -v gh >/dev/null 2>&1 || {
  echo "GitHub CLI (gh) is required." >&2
  exit 1
}

if ! gh skill list --help >/dev/null 2>&1; then
  echo "This helper requires a GitHub CLI version with 'gh skill list' support." >&2
  echo "Upgrade GitHub CLI to 2.99.0 or newer and retry." >&2
  exit 1
fi

ENTRY="$(gh skill list \
  --agent claude-code \
  --scope "$SCOPE" \
  --json skillName,path,version,sourceURL \
  --jq ".[] | select(.skillName == \"$SKILL_NAME\") | [.path, .version, .sourceURL] | @tsv" \
  | head -n 1)"

if [[ -z "$ENTRY" ]]; then
  echo "Could not find '$SKILL_NAME' in Claude Code $SCOPE scope." >&2
  echo "Install it first with:" >&2
  echo "  gh skill install $REPO $SKILL_NAME --agent claude-code --scope $SCOPE" >&2
  exit 1
fi

IFS=$'\t' read -r SKILL_DIR LISTED_VERSION SOURCE_URL <<< "$ENTRY"

if [[ -z "$SKILL_DIR" || "$SKILL_DIR" == "null" ]]; then
  echo "gh skill list did not return an installed path for '$SKILL_NAME'." >&2
  exit 1
fi

SKILL_DIR="$(cd -- "$SKILL_DIR" && pwd -P)"
SKILLS_ROOT="$(dirname -- "$SKILL_DIR")"
CLAUDE_ROOT="$(dirname -- "$SKILLS_ROOT")"
TARGET_DIR="$CLAUDE_ROOT/agents"

if [[ -z "$REF" ]]; then
  REF="$LISTED_VERSION"
fi
if [[ -z "$REF" || "$REF" == "null" ]]; then
  echo "gh skill list did not report a version. Pass --ref <tag-or-commit>." >&2
  exit 1
fi

if [[ -n "$SOURCE_URL" && "$SOURCE_URL" != "null" ]]; then
  SOURCE_REPO="${SOURCE_URL#https://github.com/}"
  SOURCE_REPO="${SOURCE_REPO%.git}"
  if [[ "$SOURCE_REPO" == */* && "$SOURCE_REPO" != *://* ]]; then
    REPO="$SOURCE_REPO"
  fi
fi

for agent in "${AGENTS[@]}"; do
  destination="$TARGET_DIR/$agent"
  if [[ -e "$destination" && "$FORCE" -ne 1 ]]; then
    echo "Refusing to overwrite existing agent: $destination" >&2
    echo "Re-run with --force to update helper-installed agents." >&2
    exit 1
  fi
done

mkdir -p "$TARGET_DIR"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for agent in "${AGENTS[@]}"; do
  tmp_file="$TMP_DIR/$agent"
  gh api \
    --method GET \
    "repos/$REPO/contents/agents/$agent" \
    -f "ref=$REF" \
    -H "Accept: application/vnd.github.raw+json" \
    > "$tmp_file"

  if ! grep -q '^name:' "$tmp_file"; then
    echo "Downloaded agent '$agent' does not look valid; aborting." >&2
    exit 1
  fi
done

for agent in "${AGENTS[@]}"; do
  mv "$TMP_DIR/$agent" "$TARGET_DIR/$agent"
done

cat <<EOF
Installed ${#AGENTS[@]} Claude Code agents into:
  $TARGET_DIR

Resolved by gh skill list:
  skill:   $SKILL_DIR
  scope:   $SCOPE
  source:  $REPO@$REF

Agents:
$(printf '  - %s\n' "${AGENTS[@]}")

Restart Claude Code or open /agents if the new agents are not visible immediately.
EOF
