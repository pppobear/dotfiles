#!/usr/bin/env zsh
# asdf integration

_asdf_data_dir="${ASDF_DATA_DIR:-$HOME/.asdf}"

if command -v asdf >/dev/null 2>&1; then
  export ASDF_DATA_DIR="$_asdf_data_dir"

  # Add shims to PATH if not already present
  if [[ -d "${ASDF_DATA_DIR}/shims" ]] && [[ ":$PATH:" != *":${ASDF_DATA_DIR}/shims:"* ]]; then
    export PATH="${ASDF_DATA_DIR}/shims:$PATH"
  fi

  # macOS Homebrew: support both Apple Silicon and Intel prefixes.
  _asdf_libexec=""
  for _asdf_brew_prefix in /opt/homebrew /usr/local; do
    if [[ -f "${_asdf_brew_prefix}/opt/asdf/libexec/asdf.sh" ]]; then
      _asdf_libexec="${_asdf_brew_prefix}/opt/asdf/libexec/asdf.sh"
      break
    fi
  done
  if [[ -n "$_asdf_libexec" ]]; then
    source "$_asdf_libexec"
  fi
  unset _asdf_brew_prefix
  unset _asdf_libexec

  # Java home hook (asdf-java plugin) - only load when java is actually installed
  _asdf_java_home_hook="${ASDF_DATA_DIR}/plugins/java/set-java-home.zsh"
  if [[ -f "$_asdf_java_home_hook" ]] && [[ -f "${ASDF_DATA_DIR}/shims/java" ]]; then
    source "$_asdf_java_home_hook"
  fi
  unset _asdf_java_home_hook

  # Cache completion
  _asdf_completion="${ZDOTDIR:-$HOME/.config/zsh}/.asdf_completion"
  if [[ ! -f "$_asdf_completion" ]] || [[ $(find "$_asdf_completion" -mtime +7 2>/dev/null) ]]; then
    asdf completion zsh > "$_asdf_completion" 2>/dev/null
  fi
  [[ -f "$_asdf_completion" ]] && source "$_asdf_completion"
  unset _asdf_completion

  _ensure_asdf_java_home() {
    [[ -n "${JAVA_HOME:-}" ]] && return 0
    typeset -f asdf_update_java_home >/dev/null 2>&1 || return 0
    asdf_update_java_home >/dev/null 2>&1 || true
  }

  for _asdf_java_cmd in java javac jar jshell mvn gradle; do
    if command -v "$_asdf_java_cmd" >/dev/null 2>&1; then
      eval "
${_asdf_java_cmd}() {
  unset -f ${_asdf_java_cmd}
  _ensure_asdf_java_home
  command ${_asdf_java_cmd} \"\$@\"
}
"
    fi
  done
  unset _asdf_java_cmd
fi

unset _asdf_data_dir
