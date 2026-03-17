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

# Load shared API tokens at shell runtime so chezmoi operations don't depend
# on rbw access and secrets are not baked into the rendered file.
load_yescode_api_key() {
  local yescode_api_key=""

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
}

load_yescode_api_key
unset -f load_yescode_api_key

if [ -n "${APIROUTER_API_KEY:-}" ]; then
  export ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-$APIROUTER_API_KEY}"
  export GEMINI_API_KEY="${GEMINI_API_KEY:-$APIROUTER_API_KEY}"
fi

export GOOGLE_GEMINI_BASE_URL="https://co.yes.vg/team/gemini"
export GOOGLE_CLOUD_PROJECT="gen-lang-client-0866326289"

# Load machine-local shell customizations that should not be managed by chezmoi.
[ -f "$ZDOTDIR/local/local-only.zsh" ] && source "$ZDOTDIR/local/local-only.zsh"
