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
# Keep Kimi's bundled fallback tools behind Nix-managed commands such as rg.
[ -d "$HOME/.kimi-code/bin" ] && export PATH="$PATH:$HOME/.kimi-code/bin"

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


# Load machine-local shell customizations that should not be managed by chezmoi.
# OpenViking Codex recall tuning. Credentials are read at runtime from ~/.openviking/ovcli.conf.
export OPENVIKING_RECALL_COMPRESS='1'
export OPENVIKING_RECALL_COMPRESS_THINKING='default'

[ -f "$ZDOTDIR/local/local-only.zsh" ] && source "$ZDOTDIR/local/local-only.zsh"
