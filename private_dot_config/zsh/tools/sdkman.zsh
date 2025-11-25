#!/usr/bin/env zsh
# SDKMAN! (Software Development Kit Manager) integration

# SDKMAN directory
export SDKMAN_DIR="$HOME/.sdkman"

# Check if SDKMAN is installed
if [ ! -d "$SDKMAN_DIR" ]; then
  return 0
fi

# Load SDKMAN initialization script
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
