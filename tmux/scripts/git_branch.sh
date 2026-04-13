#!/usr/bin/env bash
# Output: " <branch> [+N] [~N] [?N] [↑N] [↓N]"
#   +N = staged changes
#   ~N = unstaged modifications
#   ?N = untracked files
#   ↑N = commits ahead of upstream
#   ↓N = commits behind upstream
# Each segment only appears when non-zero.

set -euo pipefail

path="${1:-}"
[[ -d "$path" ]] || exit 0

branch=$(git -C "$path" symbolic-ref --short -q HEAD 2>/dev/null \
         || git -C "$path" describe --tags --exact-match 2>/dev/null \
         || git -C "$path" rev-parse --short HEAD 2>/dev/null \
         || true)
[[ -n "$branch" ]] || exit 0

suffix=""

# Staged / unstaged / untracked from porcelain output
staged=0 modified=0 untracked=0
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  x="${line:0:1}"
  y="${line:1:1}"
  if [[ "$x" == "?" ]]; then
    (( untracked++ ))
  else
    [[ "$x" != " " && "$x" != "?" ]] && (( staged++ ))
    [[ "$y" != " " && "$y" != "?" ]] && (( modified++ ))
  fi
done < <(git -C "$path" status --porcelain 2>/dev/null)

[[ "$staged" -gt 0 ]]    && suffix="${suffix} +${staged}"
[[ "$modified" -gt 0 ]]  && suffix="${suffix} ~${modified}"
[[ "$untracked" -gt 0 ]] && suffix="${suffix} ?${untracked}"

# Ahead/behind
if git -C "$path" rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  ahead=$(git -C "$path" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
  behind=$(git -C "$path" rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)
  [[ "${ahead:-0}" -gt 0 ]]  && suffix="${suffix} ↑${ahead}"
  [[ "${behind:-0}" -gt 0 ]] && suffix="${suffix} ↓${behind}"
fi

# Fork point: where this branch diverged from origin's default branch
base_info=""
default_branch=$(git -C "$path" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/||')
if [[ -n "$default_branch" && "$branch" != "${default_branch#origin/}" ]]; then
  fork=$(git -C "$path" merge-base HEAD "$default_branch" 2>/dev/null || true)
  if [[ -n "$fork" ]]; then
    short=$(git -C "$path" rev-parse --short "$fork" 2>/dev/null)
    age=$(git -C "$path" log -1 --format='%cr' "$fork" 2>/dev/null | sed 's/ ago//')
    base_info=" (${short} ${age})"
  fi
fi

printf ' %s%s%s' "$branch" "$suffix" "$base_info"
