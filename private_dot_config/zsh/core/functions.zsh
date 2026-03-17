#!/usr/bin/env zsh
# Core functions - cross-platform

# File manager integrations
# lf - change directory on exit
lfcd() {
  local tmp="$(mktemp -t "lf-cwd.XXXXXX")"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    local dir="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -d "$dir" ] && [ "$dir" != "$PWD" ]; then
      cd "$dir" || return
    fi
  fi
}

# yazi - change directory on exit
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd" || return
  fi
  rm -f -- "$tmp"
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Extract various archive formats
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.tar.xz)    tar xJf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick find
qfind() {
  fd -i "$1"
}

# Show PATH in readable format
path() {
  echo "$PATH" | tr ':' '\n'
}

# Detect and export the rbw ssh-agent socket when available.
setup_rbw_ssh_auth_sock() {
  local rbw_candidates=()
  local rbw_tmp_base="${TMPDIR:-/tmp}"
  local rbw_uid="$(id -u)"
  local sock

  if [[ -n ${XDG_RUNTIME_DIR:-} ]]; then
    if [[ -n ${RBW_PROFILE:-} ]]; then
      rbw_candidates+=("${XDG_RUNTIME_DIR%/}/rbw-${RBW_PROFILE}/ssh-agent-socket")
    fi
    rbw_candidates+=("${XDG_RUNTIME_DIR%/}/rbw/ssh-agent-socket")
  fi

  if [[ -n ${RBW_PROFILE:-} ]]; then
    rbw_candidates+=("${rbw_tmp_base%/}/rbw-${RBW_PROFILE}-${rbw_uid}/ssh-agent-socket")
    rbw_candidates+=("${rbw_tmp_base%/}/rbw-${RBW_PROFILE}/ssh-agent-socket")
  fi
  rbw_candidates+=("${rbw_tmp_base%/}/rbw-${rbw_uid}/ssh-agent-socket")
  rbw_candidates+=("${rbw_tmp_base%/}/rbw/ssh-agent-socket")

  for sock in "${rbw_candidates[@]}"; do
    if [[ -S $sock ]]; then
      export SSH_AUTH_SOCK="$sock"
      return 0
    fi
  done

  return 1
}
