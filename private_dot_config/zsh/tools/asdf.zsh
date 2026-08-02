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
  if [[ -z "${JAVA_HOME:-}" && -f "$_asdf_java_home_hook" ]] && [[ -f "${ASDF_DATA_DIR}/shims/java" ]]; then
    source "$_asdf_java_home_hook"
  fi
  unset _asdf_java_home_hook

  # asdf shell setup can prepend its shims after the core environment ran.
  # Restore Nix precedence before deciding whether any compatibility wrapper
  # is needed.
  _asdf_shims_dir="${ASDF_DATA_DIR}/shims"
  if [[ -d "$_asdf_shims_dir" ]]; then
    path=("${(@)path:#$_asdf_shims_dir}")
    path+=("$_asdf_shims_dir")
  fi
  for _nix_profile_dir in \
    "/run/current-system/sw/bin" \
    "/etc/profiles/per-user/${USER:-$LOGNAME}/bin" \
    "$HOME/.nix-profile/bin"; do
    [[ -d "$_nix_profile_dir" ]] || continue
    path=("${(@)path:#$_nix_profile_dir}")
    path=("$_nix_profile_dir" $path)
  done
  unset _asdf_shims_dir _nix_profile_dir

  _asdf_java_root="${ASDF_DATA_DIR}/installs/java/"
  if [[ "${JAVA_HOME:-}" == "$_asdf_java_root"* ]]; then
    unset JAVA_HOME
  fi
  unset _asdf_java_root
  _nix_java_bin="/etc/profiles/per-user/${USER:-$LOGNAME}/bin/java"
  if [[ -z "${JAVA_HOME:-}" && -x "$_nix_java_bin" ]]; then
    _nix_java_real="$(readlink -f "$_nix_java_bin" 2>/dev/null || true)"
    case "$_nix_java_real" in
      */Library/Java/JavaVirtualMachines/*/Contents/Home/bin/java|*/bin/java)
        export JAVA_HOME="${_nix_java_real%/bin/java}"
        ;;
    esac
  fi
  unset _nix_java_bin _nix_java_real

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
    _asdf_java_cmd_path="$(whence -p "$_asdf_java_cmd" 2>/dev/null || true)"
    if [[ "$_asdf_java_cmd_path" == "${ASDF_DATA_DIR}/shims/"* ]]; then
      eval "
${_asdf_java_cmd}() {
  unset -f ${_asdf_java_cmd}
  _ensure_asdf_java_home
  command ${_asdf_java_cmd} \"\$@\"
}
"
    fi
  done
  unset _asdf_java_cmd _asdf_java_cmd_path
fi

unset _asdf_data_dir
