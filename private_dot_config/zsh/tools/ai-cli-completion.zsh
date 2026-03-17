#!/usr/bin/env zsh
# Claude/Codex CLI completions

_zsh_config_dir="${ZDOTDIR:-$HOME/.config/zsh}"
_zsh_completion_dir="${_zsh_config_dir}/completions"

if command -v claude >/dev/null 2>&1; then
  if [[ -f "${_zsh_completion_dir}/_claude" ]]; then
    fpath=("${_zsh_completion_dir}" $fpath)
    autoload -Uz _claude
    compdef _claude claude
  fi
fi

if command -v codex >/dev/null 2>&1; then
  _codex_completion="${_zsh_config_dir}/.codex_completion"
  if [[ ! -f "$_codex_completion" ]] || [[ $(find "$_codex_completion" -mtime +7 2>/dev/null) ]]; then
    codex completion zsh > "$_codex_completion" 2>/dev/null
  fi
  [[ -f "$_codex_completion" ]] && source "$_codex_completion"
  unset _codex_completion
fi

unset _zsh_completion_dir _zsh_config_dir
