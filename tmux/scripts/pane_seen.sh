#!/usr/bin/env bash
# Record when a tmux pane was last focused.
# Called from after-select-pane hook and from claude_window_dot.sh.
set -euo pipefail

pane_id="${1:-}"
[[ -n "$pane_id" ]] || exit 0

dir="${TMPDIR:-/tmp}/tmux-pane-seen"
mkdir -p "$dir"
# Strip leading '%' from pane_id so it's a cleaner filename.
date +%s >"$dir/${pane_id#%}"
