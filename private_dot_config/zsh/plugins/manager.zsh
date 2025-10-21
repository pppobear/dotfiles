#!/usr/bin/env zsh
# Plugin manager setup

# Custom plugin function (zplug-like)
zplug() {
  local repo="$1"
  local plugin_dir="${ZDOTDIR:-$HOME/.config/zsh}/plugins/${repo##*/}"
  local plugin_file="${plugin_dir}/${repo##*/}.plugin.zsh"

  # Create plugins directory if it doesn't exist
  [ ! -d "${ZDOTDIR:-$HOME/.config/zsh}/plugins" ] && mkdir -p "${ZDOTDIR:-$HOME/.config/zsh}/plugins"

  # Clone plugin if it doesn't exist
  if [ ! -d "$plugin_dir" ]; then
    echo "Installing $repo..."
    git clone --depth=1 "https://github.com/${repo}.git" "$plugin_dir" 2>/dev/null
  fi

  # Source the plugin
  if [ -f "$plugin_file" ]; then
    source "$plugin_file"
  elif [ -f "${plugin_dir}/${repo##*/}.zsh" ]; then
    source "${plugin_dir}/${repo##*/}.zsh"
  elif [ -f "${plugin_dir}/init.zsh" ]; then
    source "${plugin_dir}/init.zsh"
  fi
}

# Update all plugins
zplug-update() {
  local plugin_dir="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

  if [ ! -d "$plugin_dir" ]; then
    echo "No plugins installed"
    return 1
  fi

  for dir in "$plugin_dir"/*; do
    if [ -d "$dir/.git" ]; then
      echo "Updating $(basename "$dir")..."
      (cd "$dir" && git pull --quiet)
    fi
  done

  echo "All plugins updated!"
}
