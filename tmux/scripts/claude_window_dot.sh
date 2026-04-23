#!/usr/bin/env bash
# Print a colored "●" per Claude pane in the given tmux window.
# Color reflects session state from ~/.claude_karma/live-sessions/.
#
# Matching strategy (per pane, in order):
#   1. Pane tty → claude PID.
#   2. $STATE_DIR/claude-<PID>.json (written by tmux-assistant-resurrect's
#      SessionStart hook) → session_id (UUID). Match the live-session record
#      whose .session_id field equals that UUID. 1:1, survives same-cwd panes.
#   3. Fallback: claude PID cwd (via lsof) → live-session record whose .cwd
#      starts with that path. Used when no state file exists (Claude launched
#      before the hook was registered).
#
# Usage: claude_window_dot.sh <session_name>:<window_index>

set -euo pipefail

# --ansi: emit truecolor ANSI escapes instead of tmux-format codes.
# Used by the window picker (fzf --ansi) since fzf doesn't parse tmux formats.
ansi_mode=0
if [[ "${1:-}" == "--ansi" ]]; then
  ansi_mode=1
  shift
fi

window_target="${1:-}"
[[ -n "$window_target" ]] || exit 0

live_dir="$HOME/.claude_karma/live-sessions"
state_dir="${TMUX_ASSISTANT_RESURRECT_DIR:-${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/tmux-assistant-resurrect}"
pane_seen_dir="${TMPDIR:-/tmp}/tmux-pane-seen"
cache_dir="${TMPDIR:-/tmp}/tmux-claude-dots"
mkdir -p "$cache_dir"
now_epoch=$(date +%s)
# Age cutoff only applies to the cwd-fallback matcher (where false positives
# are possible). The session_id matcher is 1:1 with a running PID, so the
# record is trusted regardless of age.
cwd_cutoff=$((now_epoch - 86400))  # 24h

# Keep each attached client's focused pane fresh so sitting in a pane for
# a long time never makes it look stale. client_active_pane is unreliable
# on some tmux builds, so resolve via display-message -t <client_tty>.
# Skip in --ansi mode: that path is used by the window picker, which fires
# many parallel invocations per prefix+w and doesn't need to refresh here
# (the 5s status-bar tick already handles it).
if (( !ansi_mode )); then
  while IFS= read -r client_tty; do
    [[ -n "$client_tty" ]] || continue
    pid=$(tmux display-message -t "$client_tty" -p '#{pane_id}' 2>/dev/null || true)
    [[ -n "$pid" ]] && "$(dirname "$0")/pane_seen.sh" "$pid" 2>/dev/null || true
  done < <(tmux list-clients -F '#{client_tty}' 2>/dev/null)
fi

color_for() {
  case "$1" in
    LIVE)               echo "#87A987" ;;  # green
    WAITING)            echo "#E6C384" ;;  # yellow
    STOPPED)            echo "#938AA9" ;;  # mauve
    STOPPED_UNVISITED)  echo "#C34043" ;;  # red — demands attention
    STALE)              echo "#727169" ;;  # gray
    *)                  echo "#54546D" ;;  # UNKNOWN, STARTING → very dim
  esac
}

# jq program: pick the newest non-ENDED record matching a filter expression
# and emit "<state>\t<updated_at_epoch>". Missing → "UNKNOWN\t0".
# If cutoff > 0, drop records older than cutoff seconds before picking.
state_for_filter() {
  local filter="$1"; local cutoff="$2"; shift 2
  jq -rs --argjson cutoff "$cutoff" "
    [.[] |
     select((.state // \"\") != \"ENDED\") |
     select($filter) |
     select(\$cutoff == 0 or
            ((.updated_at // \"\" | sub(\"\\\\.[0-9]+.*\$\"; \"Z\") |
               fromdateiso8601) > \$cutoff))
    ] | sort_by(.updated_at) | reverse | .[0] |
    if . then
      [(.state // \"UNKNOWN\"),
       ((.updated_at // \"\" | sub(\"\\\\.[0-9]+.*\$\"; \"Z\") |
         fromdateiso8601 | floor))]
      | @tsv
    else
      \"UNKNOWN\t0\"
    end
  " "$@" 2>/dev/null || printf 'UNKNOWN\t0'
}

pane_info=$(tmux list-panes -t "$window_target" -F '#{pane_id} #{pane_tty}' 2>/dev/null)
[[ -n "$pane_info" ]] || exit 0

tmux_out=""
ansi_out=""
while IFS=' ' read -r pane_id tty; do
  [[ -n "$tty" ]] || continue
  tty_name=$(basename "$tty")

  claude_pid=$(ps -t "$tty_name" -o pid=,comm= 2>/dev/null \
               | awk '$2 == "claude" { print $1; exit }' \
               | tr -d ' ')
  [[ -n "$claude_pid" ]] || continue

  state="UNKNOWN"
  state_at=0
  session_id=""

  # Preferred path: PID → session_id (UUID) → matching live-session record.
  state_file="$state_dir/claude-$claude_pid.json"
  if [[ -f "$state_file" ]]; then
    session_id=$(jq -r '.session_id // empty' "$state_file" 2>/dev/null || true)
  fi

  if [[ -n "$session_id" && -d "$live_dir" ]]; then
    # Match on current .session_id or any historical one in .session_ids[].
    # Resumed sessions keep one slug-keyed file where prior ids are retained
    # in .session_ids — panes started before the most recent resume would
    # otherwise miss the match and show UNKNOWN.
    IFS=$'\t' read -r state state_at < <(state_for_filter \
      ".session_id == \"$session_id\" or ((.session_ids // []) | any(. == \"$session_id\"))" \
      0 "$live_dir"/*.json)
  fi

  # Fallback: cwd-prefix match (handles Claudes launched before the
  # SessionStart hook was registered, so no state file exists).
  if [[ "$state" == "UNKNOWN" && -d "$live_dir" ]]; then
    cwd=$(lsof -p "$claude_pid" 2>/dev/null \
          | awk '$4 == "cwd" { for(i=9;i<=NF;i++) printf "%s%s", $i, (i==NF?"":" "); print "" }')
    if [[ -n "$cwd" ]]; then
      IFS=$'\t' read -r state state_at < <(state_for_filter \
        "(.cwd // \"\") | startswith(\"$cwd\")" "$cwd_cutoff" "$live_dir"/*.json)
    fi
  fi

  # STOPPED → STOPPED_UNVISITED when the pane hasn't been visited since
  # the Stop happened. Visiting keeps it mauve until Claude transitions
  # again (which advances state_at past last_seen).
  if [[ "$state" == "STOPPED" ]]; then
    last_seen=0
    seen_file="$pane_seen_dir/${pane_id#%}"
    [[ -f "$seen_file" ]] && last_seen=$(cat "$seen_file" 2>/dev/null || echo 0)
    if (( last_seen < state_at )); then
      state="STOPPED_UNVISITED"
    fi
  fi

  color=$(color_for "$state")
  # Build both formats simultaneously so we can stream one and cache both.
  # The cache lets window_picker.sh skip the expensive jq work entirely.
  tmux_out="${tmux_out:+${tmux_out} }#[fg=${color}]●"
  rgb=$(printf '%d;%d;%d' "0x${color:1:2}" "0x${color:3:2}" "0x${color:5:2}")
  ansi_out="${ansi_out:+${ansi_out} }$(printf '\x1b[38;2;%sm●\x1b[0m' "$rgb")"
done <<< "$pane_info"

# Persist both formats. ':' is valid in macOS filenames but we swap for '_'
# to keep cache files easy to eyeball.
safe_target="${window_target//:/_}"
printf '%s' "$tmux_out" >"$cache_dir/$safe_target.tmux"
printf '%s' "$ansi_out" >"$cache_dir/$safe_target.ansi"

if (( ansi_mode )); then
  [[ -n "${ansi_out:-}" ]] || exit 0
  printf '%s' "$ansi_out"
else
  [[ -n "${tmux_out:-}" ]] || exit 0
  printf '%s' "$tmux_out"
fi
