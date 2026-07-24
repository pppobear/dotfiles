#!/usr/bin/env zsh
# thefuck integration (command correction) - Lazy loaded for faster startup

# Lazy load thefuck when fuck or fk is called
if command -v thefuck >/dev/null 2>&1; then
  fuck() {
    unset -f fuck
    eval "$(thefuck --alias fuck)"
    fuck "$@"
  }

  fk() {
    unset -f fk
    eval "$(thefuck --alias fk)"
    fk "$@"
  }
fi
