#!/bin/bash
# PostToolUse hook: append Claude's bash commands to zsh history.
# Lets you Ctrl+R or arrow-up to find commands Claude has run.

CMD=$(jq -r '.tool_input.command // empty' 2>/dev/null)

if [ -z "$CMD" ]; then
  exit 0
fi

# Zsh multi-line history: every line except the last ends with a backslash,
# which signals line continuation. Preserves readability and executability.
ESCAPED=$(printf '%s' "$CMD" | sed '$!s/$/\\/')
TS=$(date +%s)

printf ': %s:0;%s\n' "$TS" "$ESCAPED" >> ~/.zsh_history
