#!/bin/bash
# Pre-commit hook for Claude: checks staged file count and runs ruff on staged Python files.

WARNINGS=""
BLOCK=0

# --- Check 1: Large commit guard ---
if [ "${LARGE_COMMIT_REVIEWED:-0}" != "1" ]; then
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  if [ "$STAGED" -gt 30 ]; then
    WARNINGS="LARGE COMMIT WARNING: $STAGED files are staged. Review whether all files are related to your current task (git diff --cached --name-only). Unstage unrelated files with: git reset HEAD <file>. If intentionally large, prefix with LARGE_COMMIT_REVIEWED=1 to bypass."
    BLOCK=1
  fi
fi

# --- Check 2: Ruff lint on staged .py files ---
MAIN_GIT=$(git rev-parse --git-common-dir 2>/dev/null)
MAIN_REPO=$(dirname "$MAIN_GIT")
ML_DIR="$MAIN_REPO/ml"

if [ -d "$ML_DIR" ]; then
  PY_FILES=$(git diff --cached --name-only --diff-filter=d 2>/dev/null | grep '\.py$')
  if [ -n "$PY_FILES" ]; then
    # Convert to absolute paths
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    ABS_FILES=""
    while IFS= read -r f; do
      ABS_FILES="$ABS_FILES $REPO_ROOT/$f"
    done <<< "$PY_FILES"

    RUFF_OUTPUT=$(cd "$ML_DIR" && uv run --group lint ruff check $ABS_FILES 2>&1)
    RUFF_EXIT=$?
    if [ $RUFF_EXIT -ne 0 ] && [ -n "$RUFF_OUTPUT" ]; then
      if [ -n "$WARNINGS" ]; then
        WARNINGS="$WARNINGS\n\n"
      fi
      WARNINGS="${WARNINGS}RUFF LINT ERRORS in staged files:\n${RUFF_OUTPUT}\n\nFix these issues before committing. Run: uv run ruff check --fix <file> for auto-fixable issues."
      BLOCK=1
    fi

    # --- Check 3: Typecheck (ty) on the whole ml/ tree. ---
    # ty does cross-file resolution, so per-file checking can miss downstream
    # breakage (e.g. renaming a module attribute a caller still references).
    # Only runs when at least one Python file under ml/ is staged.
    ML_PY_STAGED=$(printf '%s\n' "$PY_FILES" | grep -E '^ml/' || true)
    if [ -n "$ML_PY_STAGED" ] && [ -f "$ML_DIR/ty.toml" ]; then
      TY_OUTPUT=$(cd "$ML_DIR" && uv run --group lint ty check . --config-file ty.toml 2>&1)
      TY_EXIT=$?
      if [ $TY_EXIT -ne 0 ]; then
        if [ -n "$WARNINGS" ]; then
          WARNINGS="$WARNINGS\n\n"
        fi
        WARNINGS="${WARNINGS}TYPECHECK ERRORS (ty):\n${TY_OUTPUT}\n\nFix before committing. Run: cd ml && make typecheck"
        BLOCK=1
      fi
    fi
  fi
fi

# --- Output ---
if [ $BLOCK -eq 1 ]; then
  # Use python3 to safely JSON-encode the warnings
  JSON_MSG=$(printf '%s' "$WARNINGS" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":%s}}\n' "$JSON_MSG"
  exit 1
fi
