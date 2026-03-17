#!/usr/bin/env zsh
# asdf integration

_asdf_opt_prefix="/opt/homebrew/opt/asdf"
_asdf_data_dir="${ASDF_DATA_DIR:-$HOME/.asdf}"
_asdf_libexec="${_asdf_opt_prefix}/libexec/asdf.sh"

if [[ -f "$_asdf_libexec" ]]; then
  export ASDF_DATA_DIR="$_asdf_data_dir"
  source "$_asdf_libexec"

  _asdf_java_home_hook="${ASDF_DATA_DIR}/plugins/java/set-java-home.zsh"
  if [[ -f "$_asdf_java_home_hook" ]]; then
    source "$_asdf_java_home_hook"
    typeset -f asdf_update_java_home >/dev/null 2>&1 && asdf_update_java_home
  fi

  _asdf_completion="${ZDOTDIR:-$HOME/.config/zsh}/.asdf_completion"
  if [[ ! -f "$_asdf_completion" ]] || [[ $(find "$_asdf_completion" -mtime +7 2>/dev/null) ]]; then
    asdf completion zsh > "$_asdf_completion" 2>/dev/null
  fi
  [[ -f "$_asdf_completion" ]] && source "$_asdf_completion"
  unset _asdf_completion
  unset _asdf_java_home_hook
fi

unset _asdf_libexec _asdf_data_dir _asdf_opt_prefix
