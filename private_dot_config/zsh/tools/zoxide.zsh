#!/usr/bin/env zsh
# Zoxide integration (smarter cd) - Cached for faster startup

# Only enable if not in Claude Code environment
if [[ -z "$CLAUDECODE" ]] && command -v zoxide >/dev/null 2>&1; then
  # Cache zoxide initialization to avoid eval on every startup
  _zoxide_cache="${ZDOTDIR:-$HOME/.config/zsh}/.zoxide_cache"
  if [[ ! -f "$_zoxide_cache" ]] || [[ $(find "$_zoxide_cache" -mtime +7 2>/dev/null) ]]; then
    zoxide init zsh > "$_zoxide_cache" 2>/dev/null
  fi
  [[ -f "$_zoxide_cache" ]] && source "$_zoxide_cache"
  unset _zoxide_cache
fi
