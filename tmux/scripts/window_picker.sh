#!/usr/bin/env bash
# fzf window picker with Claude status dots.
# Bound to prefix+w in tmux.conf.
#
# Speed strategy: claude_window_dot.sh writes per-window cache files on every
# status-bar tick (~5s). We read from cache (near-instant). Any window not
# yet in cache falls back to a live parallel compute.
set -euo pipefail

script_dir="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"
cache_dir="${TMPDIR:-/tmp}/tmux-claude-dots"
sess=$(tmux display-message -p '#{session_name}')

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

indices=()
while IFS=$'\t' read -r idx name; do
  indices+=("$idx")
  cache_file="$cache_dir/${sess}_${idx}.ansi"
  if [[ -s "$cache_file" ]]; then
    # Fast path: cached from the last status-bar refresh.
    printf '%s: %s %s\n' "$idx" "$name" "$(cat "$cache_file")" >"$tmpdir/$idx"
  else
    # Cold cache for this window: compute in background so we don't block.
    {
      dots=$("$script_dir/claude_window_dot.sh" --ansi "$sess:$idx" 2>/dev/null || true)
      printf '%s: %s %s\n' "$idx" "$name" "$dots" >"$tmpdir/$idx"
    } &
  fi
done < <(tmux list-windows -F '#{window_index}'$'\t''#{window_name}')
wait

choice=$(for idx in "${indices[@]}"; do cat "$tmpdir/$idx"; done | fzf --ansi --reverse)

[[ -n "$choice" ]] || exit 0
tmux select-window -t "$(printf '%s' "$choice" | cut -d: -f1)"
