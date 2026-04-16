#!/usr/bin/env zsh
# Early SSH agent environment setup.
# This file is sourced from .zshenv so non-interactive shells can also resolve
# the preferred agent socket before invoking git/ssh.

if [[ -n "${__ZSH_CORE_SSH_AGENT_LOADED:-}" ]]; then
  return 0
fi
export __ZSH_CORE_SSH_AGENT_LOADED=1

setup_rbw_ssh_auth_sock() {
  local rbw_candidates=()
  local rbw_tmp_base="${TMPDIR:-/tmp}"
  local rbw_uid="${EUID:-$(id -u)}"
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

if [[ -z ${DISABLE_RBW_SSH_AGENT:-} ]]; then
  setup_rbw_ssh_auth_sock
fi
