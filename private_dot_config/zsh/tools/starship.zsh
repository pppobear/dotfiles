#!/usr/bin/env zsh
# Starship prompt integration

# Initialize starship if available
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
