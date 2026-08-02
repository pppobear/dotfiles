#!/usr/bin/env zsh
# Core environment variables - cross-platform

# Guard against duplicate loading. This file is sourced from .zshenv and must
# stay cheap for every shell; interactive shells should not re-run it.
if [[ "${__ZSH_CORE_ENVIRONMENT_LOADED:-}" == "$$" ]]; then
  return 0
fi
typeset -g __ZSH_CORE_ENVIRONMENT_LOADED="$$"

_path_prepend() {
  local dir="$1"
  path=("${(@)path:#$dir}")
  path=("$dir" $path)
}

_path_append() {
  local dir="$1"
  path=("${(@)path:#$dir}")
  path+=("$dir")
}

# Locale
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# Editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export MANPAGER='nvim +Man!'

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/runtime-$USER}"

# XDG User Directories
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Terminal
# Do not override TERM here. Ghostty is configured to use xterm-256color for
# compatibility, while TERM_PROGRAM/LC_TERMINAL carry the terminal identity for
# tools that care about the emulator.
#
# Some tools only inspect TERM_PROGRAM/LC_TERMINAL and lose Ghostty detection
# once they are launched inside tmux. Ghostty exposes a stable marker via
# GHOSTTY_RESOURCES_DIR, so use that to restore the outer terminal identity.
if [[ -n "${GHOSTTY_RESOURCES_DIR:-}" || "${TERM:-}" == "xterm-ghostty" || "${TERM_PROGRAM:-}" == "ghostty" ]]; then
  export LC_TERMINAL="${LC_TERMINAL:-ghostty}"

  if [[ -z "${TERM_PROGRAM:-}" || "${TERM_PROGRAM:-}" == "tmux" ]]; then
    export TERM_PROGRAM="ghostty"
  fi
fi

# Homebrew (macOS) - avoid spawning `brew shellenv` on every shell startup.
# The prefix is stable on managed installations, so export the same values
# directly and prepend bin/sbin once.
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  _path_prepend "/opt/homebrew/sbin"
  _path_prepend "/opt/homebrew/bin"
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
  export HOMEBREW_CELLAR="/usr/local/Cellar"
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
  _path_prepend "/usr/local/sbin"
  _path_prepend "/usr/local/bin"
fi

# Common paths
_path_prepend "$HOME/bin"
_path_prepend "$HOME/.local/bin"

# Keep the legacy asdf shims available as a fallback while Nix owns the
# migrated Java/Maven commands.
_asdf_data_dir="${ASDF_DATA_DIR:-$HOME/.asdf}"
if [[ -d "$_asdf_data_dir/shims" ]]; then
  _path_prepend "$_asdf_data_dir/shims"
fi
unset _asdf_data_dir

# Prefer the Nix user/system profiles for tools migrated to Home Manager.
for _nix_profile_dir in \
  "/run/current-system/sw/bin" \
  "/etc/profiles/per-user/${USER:-$LOGNAME}/bin" \
  "$HOME/.nix-profile/bin"; do
  [[ -d "$_nix_profile_dir" ]] && _path_prepend "$_nix_profile_dir"
done
unset _nix_profile_dir

# Maven needs an explicit Java home. Derive it from the Nix-managed `java`
# link so both interactive and non-interactive shells use the JDK 8 contract.
_asdf_java_root="${ASDF_DATA_DIR:-$HOME/.asdf}/installs/java/"
if [[ "${JAVA_HOME:-}" == "$_asdf_java_root"* ]]; then
  unset JAVA_HOME
fi
unset _asdf_java_root
_nix_java_bin="/etc/profiles/per-user/${USER:-$LOGNAME}/bin/java"
if [[ -z "${JAVA_HOME:-}" && -x "$_nix_java_bin" ]]; then
  _nix_java_real="$(readlink -f "$_nix_java_bin" 2>/dev/null || true)"
  case "$_nix_java_real" in
    */Library/Java/JavaVirtualMachines/*/Contents/Home/bin/java)
      export JAVA_HOME="${_nix_java_real%/bin/java}"
      ;;
    */bin/java)
      export JAVA_HOME="${_nix_java_real%/bin/java}"
      ;;
  esac
fi
unset _nix_java_bin _nix_java_real

# Development
export GITHUB_USERNAME=pppobear
if [[ -f "$HOME/.ripgreprc" ]]; then
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# Go
export GOPATH="$HOME/go"
_path_append "$GOPATH/bin"

# Rust
_path_append "$HOME/.cargo/bin"

# Snap (仅在未包含时追加)
_path_append "/snap/bin"

# Bat theme
export BAT_THEME="Catppuccin Mocha"

unfunction _path_prepend _path_append
