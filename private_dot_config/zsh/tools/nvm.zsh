#!/usr/bin/env zsh
# NVM (Node Version Manager) integration

# NVM directory
export NVM_DIR="$HOME/.config/nvm"

# Check if NVM_DIR exists
if [ ! -d "$NVM_DIR" ]; then
  # Fallback to legacy location
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
fi

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load nvm bash completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
