#!/bin/bash
# Toggle a persistent nvim popup for the given cwd.
# Called from tmux bind — opens popup if in main session, closes if in popup.

set -euo pipefail

pane_path="${1:-$HOME}"
session_name="${2:-}"

# If we're already inside a nvim popup session, detach (closes the popup)
if [[ "$session_name" == nvim-* ]]; then
  tmux detach-client
  exit 0
fi

# Otherwise, open/attach the popup
SESSION="nvim-$(echo "$pane_path" | md5 -q | cut -c1-8)"
# Launch nvim via `uv run` so it picks up the cwd's project Python env
# (LSPs, formatters). Falls back to plain nvim if uv isn't on PATH or the
# cwd has no project for uv to resolve.
tmux has-session -t "$SESSION" 2>/dev/null || \
  tmux new-session -d -s "$SESSION" -c "$pane_path" "uv run nvim || nvim"
tmux display-popup -w 95% -h 92% -E "tmux attach-session -t $SESSION"
