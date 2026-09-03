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

Usage:
  install-claude-agents.sh [--scope project|user] [--ref <git-ref>] [--force]

Options:
  --scope   Install into the current project's .claude/agents directory
            or the user's Claude config directory. Default: project.
  --ref     Fetch agent definitions from a specific tag, branch, or commit.
            By default the helper uses the version recorded by gh skill.
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

if [[ "$SCOPE" == "project" ]]; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  if [[ -z "$PROJECT_ROOT" ]]; then
    echo "Project scope requires running inside a Git repository." >&2
    exit 1
  fi
  TARGET_DIR="$PROJECT_ROOT/.claude/agents"
else
  CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  TARGET_DIR="$CLAUDE_HOME/agents"
fi

if [[ -z "$REF" ]]; then
  REF="$(gh skill list \
    --agent claude-code \
    --scope "$SCOPE" \
    --json skillName,version \
    --jq ".[] | select(.skillName == \"$SKILL_NAME\") | .version" \
    | head -n 1 || true)"
fi

if [[ -z "$REF" || "$REF" == "null" ]]; then
  REF="main"
  echo "Could not determine the installed skill version; using ref '$REF'." >&2
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

Source:
  $REPO@$REF

Agents:
$(printf '  - %s\n' "${AGENTS[@]}")

Restart Claude Code or open /agents if the new agents are not visible immediately.
EOF
