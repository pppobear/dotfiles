#!/usr/bin/env zsh
# NVM (Node Version Manager) integration - Lazy loaded for faster startup

# NVM directory
export NVM_DIR="$HOME/.config/nvm"

# Check if NVM_DIR exists
if [ ! -d "$NVM_DIR" ]; then
  # Fallback to legacy location
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
fi

# Add current node version to PATH without loading nvm
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # Try to use default node version
  _nvm_default_version="$(cat "$NVM_DIR/alias/default" 2>/dev/null || echo 'node')"
  if [ -d "$NVM_DIR/versions/node/$_nvm_default_version/bin" ]; then
    export PATH="$NVM_DIR/versions/node/$_nvm_default_version/bin:$PATH"
  elif [ -d "$NVM_DIR/versions/node/$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | tail -1)/bin" ]; then
    export PATH="$NVM_DIR/versions/node/$(ls -1 "$NVM_DIR/versions/node" | tail -1)/bin:$PATH"
  fi
  unset _nvm_default_version
fi

# Lazy load nvm when actually needed
_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() {
  unset -f nvm node npm npx
  _load_nvm
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  _load_nvm
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  _load_nvm
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  _load_nvm
  npx "$@"
}
