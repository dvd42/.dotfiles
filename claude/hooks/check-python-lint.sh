#!/bin/bash
# PostToolUse hook: auto-run ruff on edited Python files.
# Works in worktrees by resolving the main repo root for the venv.

FILE=$(jq -r '.tool_response.filePath // .tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE" ]; then
  exit 0
fi

# Only check Python files
case "$FILE" in
  *.py) ;;
  *) exit 0 ;;
esac

# Skip if file doesn't exist (was deleted)
if [ ! -f "$FILE" ]; then
  exit 0
fi

# Find the ml/ subproject root — ruff config lives there
MAIN_GIT=$(git rev-parse --git-common-dir 2>/dev/null)
MAIN_REPO=$(dirname "$MAIN_GIT")
ML_DIR="$MAIN_REPO/ml"

if [ ! -d "$ML_DIR" ]; then
  exit 0
fi

# Run ruff check from ml/ so it picks up pyproject.toml config
OUTPUT=$(cd "$ML_DIR" && uv run ruff check "$FILE" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ] && [ -n "$OUTPUT" ]; then
  # Escape for JSON
  ESCAPED=$(printf '%s' "$OUTPUT" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"RUFF LINT ERRORS in %s:\\n%s\\n\\nFix these issues before moving on."}}\n' "$FILE" "$OUTPUT"
fi
