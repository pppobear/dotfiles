#!/usr/bin/env zsh
# Zsh plugins configuration
# Plugins loaded via zplug (separate from oh-my-zsh plugins in core/omz.zsh)

# Load widget-wrapping plugins after oh-my-zsh/fzf-tab so Tab completion stays intact.
_zsh_plugin_dir="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

if typeset -f zsh-defer >/dev/null 2>&1; then
  zsh-defer source "${_zsh_plugin_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh"
  zsh-defer source "${_zsh_plugin_dir}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
else
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zdharma-continuum/fast-syntax-highlighting"
fi

unset _zsh_plugin_dir
