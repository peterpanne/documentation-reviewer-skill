#!/usr/bin/env bash
set -euo pipefail

REPO="peterpanne/documentation-reviewer-skill"
SKILL_NAME="reviewing-developer-documentation"
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

Run this helper from the copy installed by `gh skill install --agent claude-code`.
It uses `gh skill list` to resolve the installed skill path and version, then
installs the agents next to that skill under the matching Claude config root.

Usage:
  install-claude-agents.sh [--ref <git-ref>] [--force]

Options:
  --ref     Fetch agent definitions from a specific tag, branch, or commit.
            By default the helper uses the version reported by `gh skill list`.
  --force   Overwrite existing agent files.
  -h, --help
            Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
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

command -v gh >/dev/null 2>&1 || {
  echo "GitHub CLI (gh) is required." >&2
  exit 1
}

if ! gh skill list --help >/dev/null 2>&1; then
  echo "This helper requires a GitHub CLI version with 'gh skill list' support." >&2
  echo "Upgrade GitHub CLI and retry." >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SKILL_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
SKILLS_ROOT="$(dirname -- "$SKILL_DIR")"

ENTRY="$(gh skill list \
  --dir "$SKILLS_ROOT" \
  --json skillName,path,version,sourceURL \
  --jq ".[] | select(.skillName == \"$SKILL_NAME\") | [.path, .version, .sourceURL] | @tsv" \
  | head -n 1)"

if [[ -z "$ENTRY" ]]; then
  echo "Could not find '$SKILL_NAME' with gh skill list under:" >&2
  echo "  $SKILLS_ROOT" >&2
  echo "Run this helper from the copy installed by gh skill." >&2
  exit 1
fi

IFS=$'\t' read -r LISTED_PATH LISTED_VERSION SOURCE_URL <<< "$ENTRY"

if [[ -z "$LISTED_PATH" || "$LISTED_PATH" == "null" ]]; then
  echo "gh skill list did not return an installed path for '$SKILL_NAME'." >&2
  exit 1
fi

LISTED_PATH="$(cd -- "$LISTED_PATH" && pwd -P)"
if [[ "$LISTED_PATH" != "$SKILL_DIR" ]]; then
  echo "The running helper does not match the skill entry returned by gh skill list." >&2
  echo "Helper skill: $SKILL_DIR" >&2
  echo "Listed skill: $LISTED_PATH" >&2
  exit 1
fi

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
  skill:   $LISTED_PATH
  source:  $REPO@$REF

Agents:
$(printf '  - %s\n' "${AGENTS[@]}")

Restart Claude Code or open /agents if the new agents are not visible immediately.
EOF
