#!/usr/bin/env zsh
# rbw ssh-agent socket auto-detection

rbw_candidates=()

if [[ -n ${XDG_RUNTIME_DIR:-} ]]; then
  if [[ -n ${RBW_PROFILE:-} ]]; then
    rbw_candidates+=("${XDG_RUNTIME_DIR%/}/rbw-${RBW_PROFILE}/ssh-agent-socket")
  fi
  rbw_candidates+=("${XDG_RUNTIME_DIR%/}/rbw/ssh-agent-socket")
fi

rbw_tmp_base="${TMPDIR%/}"
rbw_uid="$(id -u)"
if [[ -n ${RBW_PROFILE:-} ]]; then
  rbw_candidates+=("${rbw_tmp_base}/rbw-${RBW_PROFILE}-${rbw_uid}/ssh-agent-socket")
  rbw_candidates+=("${rbw_tmp_base}/rbw-${RBW_PROFILE}/ssh-agent-socket")
fi
rbw_candidates+=("${rbw_tmp_base}/rbw-${rbw_uid}/ssh-agent-socket")
rbw_candidates+=("${rbw_tmp_base}/rbw/ssh-agent-socket")

for sock in "${rbw_candidates[@]}"; do
  if [[ -S $sock ]]; then
    export SSH_AUTH_SOCK="$sock"
    break
  fi
done
