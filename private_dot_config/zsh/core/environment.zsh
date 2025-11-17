#!/usr/bin/env zsh
# Core environment variables - cross-platform

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
[ -z "$TMUX" ] && export TERM=xterm-256color

# Common paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Development
export GITHUB_USERNAME=pppobear
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

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
export BAT_THEME="Catppuccin Mocha"
