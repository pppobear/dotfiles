#!/usr/bin/env zsh
# Core environment variables - cross-platform

# Guard against duplicate loading. This file is sourced from .zshenv and must
# stay cheap for every shell; interactive shells should not re-run it.
if [[ -n "${__ZSH_CORE_ENVIRONMENT_LOADED:-}" ]]; then
  return 0
fi
export __ZSH_CORE_ENVIRONMENT_LOADED=1

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
# Let the terminal emulator expose its native TERM; forcing xterm-256color
# breaks Ghostty feature detection and can confuse tmux/app key handling.
#
# Some tools only inspect TERM_PROGRAM/LC_TERMINAL and lose Ghostty detection
# once they are launched inside tmux. Ghostty exposes a stable marker via
# GHOSTTY_RESOURCES_DIR, so use that to restore the outer terminal identity
# without touching TERM itself.
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
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
  export HOMEBREW_CELLAR="/usr/local/Cellar"
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# Common paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Development
export GITHUB_USERNAME=pppobear
if [[ -f "$HOME/.ripgreprc" ]]; then
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Snap (仅在未包含时追加)
case ":$PATH:" in
  *":/snap/bin:"*) ;;
  *) export PATH="$PATH:/snap/bin" ;;
esac

# Bat theme
export BAT_THEME="gruvbox-light"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
