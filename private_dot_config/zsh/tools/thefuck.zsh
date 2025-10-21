#!/usr/bin/env zsh
# thefuck integration (command correction)

# Initialize thefuck with alias 'fk'
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias fk)"
fi
