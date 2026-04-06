#!/usr/bin/env zsh
# User-specific configuration
# This file is for your personal customizations

# Startup commands (interactive shells only)
# Disabled for faster startup - run manually when needed
# To enable, uncomment the following lines or run 'fastfetch' manually
#
# if [[ $- == *i* ]]; then
#   # Display a random pokemon on startup
#   if command -v pokego >/dev/null 2>&1; then
#     pokego --no-title -r 1,3,6
#   elif command -v pokemon-colorscripts >/dev/null 2>&1; then
#     pokemon-colorscripts --no-title -r 1,3,6
#   elif command -v fastfetch >/dev/null 2>&1; then
#     fastfetch --logo-type kitty
#   fi
# fi

# Add your custom configurations below
# Examples:
# - Custom environment variables
# - Personal aliases
# - Project-specific settings
# - Tool configurations

# Custom scripts path
[ -d "$HOME/scripts" ] && export PATH="$HOME/scripts:$PATH"

# Ghostty defaults to TERM=xterm-ghostty, but many jump hosts and older
# servers do not ship that terminfo entry. Downgrade TERM only for outbound
# interactive SSH sessions so remote readline/tput/backspace behavior stays
# compatible without changing the local terminal identity.
ssh() {
  if [[ -t 0 && -t 1 && "${TERM:-}" == "xterm-ghostty" ]]; then
    TERM=xterm-256color command ssh "$@"
  else
    command ssh "$@"
  fi
}

# Load shared API tokens at shell runtime so chezmoi operations don't depend
# on rbw access and secrets are not baked into the rendered file.
_yescode_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
_yescode_api_key_cache="${_yescode_cache_dir}/apirouter_api_key"
_yescode_api_key_cache_ttl_seconds="${YESCODE_API_KEY_CACHE_TTL_SECONDS:-43200}"

load_yescode_api_key_from_cache() {
  local yescode_api_key=""
  local -a _yescode_cache_stat

  if [ -n "${APIROUTER_API_KEY:-}" ] || [ ! -r "$_yescode_api_key_cache" ]; then
    return 0
  fi

  zmodload -F zsh/stat b:zstat 2>/dev/null || return 0
  zstat -A _yescode_cache_stat +mtime -- "$_yescode_api_key_cache" 2>/dev/null || return 0
  if (( EPOCHSECONDS - _yescode_cache_stat[1] > _yescode_api_key_cache_ttl_seconds )); then
    return 0
  fi

  IFS= read -r yescode_api_key < "$_yescode_api_key_cache" || return 0
  [ -z "$yescode_api_key" ] && return 0

  export APIROUTER_API_KEY="$yescode_api_key"
}

load_yescode_api_key() {
  local yescode_api_key=""

  if [ -n "${APIROUTER_API_KEY:-}" ]; then
    return 0
  fi

  load_yescode_api_key_from_cache
  if [ -n "${APIROUTER_API_KEY:-}" ]; then
    return 0
  fi

  if ! command -v rbw >/dev/null 2>&1; then
    return 0
  fi

  yescode_api_key="$(rbw get -f api_key co.yes.vg 2>/dev/null || true)"
  if [ -z "$yescode_api_key" ]; then
    return 0
  fi

  export APIROUTER_API_KEY="$yescode_api_key"
  mkdir -p "$_yescode_cache_dir" 2>/dev/null || return 0
  ( umask 077 && printf '%s\n' "$yescode_api_key" >| "$_yescode_api_key_cache" ) 2>/dev/null || true
}

sync_yescode_api_env() {
  if [ -z "${APIROUTER_API_KEY:-}" ]; then
    return 0
  fi

  # export ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-$APIROUTER_API_KEY}"
  export GEMINI_API_KEY="${GEMINI_API_KEY:-$APIROUTER_API_KEY}"
}

load_yescode_api_key
sync_yescode_api_env

export GOOGLE_GEMINI_BASE_URL="https://co.yes.vg/team/gemini"
export GOOGLE_CLOUD_PROJECT="gen-lang-client-0866326289"

# Load machine-local shell customizations that should not be managed by chezmoi.
[ -f "$ZDOTDIR/local/local-only.zsh" ] && source "$ZDOTDIR/local/local-only.zsh"
