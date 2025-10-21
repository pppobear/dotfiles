#!/usr/bin/env zsh
# Zoxide integration (smarter cd)

# Only enable if not in Claude Code environment
if [[ -z "$CLAUDECODE" ]] && command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
