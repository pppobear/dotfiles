#!/usr/bin/env zsh
# Plugin manager setup

# Source the defer utility, which is managed by chezmoi external
source "${ZDOTDIR:-$HOME/.config/zsh}/plugins/zsh-defer/zsh-defer.plugin.zsh"

# Custom plugin function to source plugins (assumes plugins are already installed by chezmoi)
zplug() {
  local repo="$1"
  local lazy_trigger="$2"
  local plugin_dir="${ZDOTDIR:-$HOME/.config/zsh}/plugins/${repo##*/}"
  local plugin_file=""

  # Find the plugin entry point
  if [ -f "${plugin_dir}/${repo##*/}.plugin.zsh" ]; then
    plugin_file="${plugin_dir}/${repo##*/}.plugin.zsh"
  elif [ -f "${plugin_dir}/${repo##*/}.zsh" ]; then
    plugin_file="${plugin_dir}/${repo##*/}.zsh"
  elif [ -f "${plugin_dir}/init.zsh" ]; then
    plugin_file="${plugin_dir}/init.zsh"
  fi

  # Source the plugin immediately or defer it
  if [ -n "$plugin_file" ]; then
    if [ -n "$lazy_trigger" ]; then
      zsh-defer source "$plugin_file"
      zsh-defer-lazy "$lazy_trigger"
    else
      source "$plugin_file"
    fi
  fi
}

# Update all plugins (now managed by chezmoi)
zplug-update() {
  echo "Plugins are now managed by 'chezmoi'. Run 'chezmoi update' to update them."
}
