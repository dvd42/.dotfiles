#!/usr/bin/env bash
# Print a colored "●" per Claude pane in the given tmux window.
# Color reflects session state from ~/.claude_karma/live-sessions/.
#
# Usage: claude_window_dot.sh <session_name>:<window_index>

set -euo pipefail

window_target="${1:-}"
[[ -n "$window_target" ]] || exit 0

live_dir="$HOME/.claude_karma/live-sessions"
now_epoch=$(date +%s)
max_age=86400  # ignore live-session records older than 24h

color_for() {
  case "$1" in
    LIVE)     echo "#87A987" ;;
    WAITING)  echo "#E6C384" ;;
    STARTING) echo "#7E9CD8" ;;
    STOPPED)  echo "#938AA9" ;;
    STALE)    echo "#727169" ;;
    *)        echo "#54546D" ;;  # unknown/no-match → very dim
  esac
}

pane_ttys=$(tmux list-panes -t "$window_target" -F '#{pane_tty}' 2>/dev/null)
[[ -n "$pane_ttys" ]] || exit 0

out=""
while IFS= read -r tty; do
  [[ -n "$tty" ]] || continue
  tty_name=$(basename "$tty")

  claude_pid=$(ps -t "$tty_name" -o pid=,comm= 2>/dev/null \
               | awk '$2 == "claude" { print $1; exit }' \
               | tr -d ' ')
  [[ -n "$claude_pid" ]] || continue

  # Default: dim (no matching live-session)
  state="UNKNOWN"

  if [[ -d "$live_dir" ]]; then
    cwd=$(lsof -p "$claude_pid" 2>/dev/null \
          | awk '$4 == "cwd" { for(i=9;i<=NF;i++) printf "%s%s", $i, (i==NF?"":" "); print "" }')

    if [[ -n "$cwd" ]]; then
      # Prefix match: live-session CWD starts with the PID's CWD (handles subdirs)
      # Also filter out records older than 24h and ENDED sessions
      state=$(jq -rs --arg cwd "$cwd" --argjson cutoff "$((now_epoch - max_age))" '
        [.[] |
         select((.state // "") != "ENDED") |
         select(.cwd // "" | startswith($cwd)) |
         select((.updated_at // "" | sub("\\.[0-9]+.*$"; "Z") |
                  fromdateiso8601) > $cutoff)
        ] | sort_by(.updated_at) | reverse | .[0].state // "UNKNOWN"
      ' "$live_dir"/*.json 2>/dev/null || echo "UNKNOWN")
    fi
  fi

  color=$(color_for "$state")
  out="${out:+${out} }#[fg=${color}]●"
done <<< "$pane_ttys"

[[ -n "${out:-}" ]] || exit 0
printf '%s' "$out"
