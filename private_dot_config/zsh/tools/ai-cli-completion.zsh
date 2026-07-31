#!/usr/bin/env zsh
# Cached completions for CLIs that generate their own zsh definitions

_zsh_config_dir="${ZDOTDIR:-$HOME/.config/zsh}"
_zsh_completion_dir="${_zsh_config_dir}/completions"
_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

_cache_completion() {
  local cache_file="$1"
  local refresh_cmd="$2"
  local completion_func="$3"
  local completion_cmd="$4"

  if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mtime +7 2>/dev/null) ]]; then
    mkdir -p "$_zsh_cache_dir"
    eval "$refresh_cmd" >| "$cache_file" 2>/dev/null
  fi

  if [[ -f "$cache_file" ]]; then
    source "$cache_file"
  elif [[ -n "$completion_func" && -n "$completion_cmd" ]]; then
    autoload -Uz "$completion_func"
    compdef "$completion_func" "$completion_cmd"
  fi
}

if command -v claude >/dev/null 2>&1; then
  if [[ -f "${_zsh_completion_dir}/_claude" ]]; then
    fpath=("${_zsh_completion_dir}" $fpath)
    autoload -Uz _claude
    compdef _claude claude
  fi
fi

if command -v codex >/dev/null 2>&1; then
  _codex_completion="${_zsh_cache_dir}/codex_completion.zsh"
  _cache_completion "$_codex_completion" "codex completion zsh" "" ""
  unset _codex_completion
fi

if command -v gh >/dev/null 2>&1; then
  _gh_completion="${_zsh_cache_dir}/gh_completion.zsh"
  _cache_completion "$_gh_completion" "gh completion --shell zsh" "_gh" "gh"
  unset _gh_completion
fi

if command -v uv >/dev/null 2>&1; then
  _uv_completion="${_zsh_cache_dir}/uv_completion.zsh"
  _cache_completion "$_uv_completion" "uv generate-shell-completion zsh" "_uv" "uv"
  unset _uv_completion
fi

if command -v uvx >/dev/null 2>&1; then
  _uvx_completion="${_zsh_cache_dir}/uvx_completion.zsh"
  _cache_completion "$_uvx_completion" "uvx --generate-shell-completion zsh" "_uvx" "uvx"
  unset _uvx_completion
fi

if command -v chezmoi >/dev/null 2>&1; then
  _chezmoi_completion="${_zsh_cache_dir}/chezmoi_completion.zsh"
  _cache_completion "$_chezmoi_completion" "chezmoi completion zsh" "_chezmoi" "chezmoi"
  unset _chezmoi_completion
fi

unset -f _cache_completion
unset _zsh_cache_dir _zsh_completion_dir _zsh_config_dir
