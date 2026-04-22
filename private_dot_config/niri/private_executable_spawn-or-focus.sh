#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"

if [[ -z "${target}" ]]; then
  echo "usage: spawn-or-focus.sh <target>" >&2
  exit 64
fi

is_workspace_scratchpad_target() {
  [[ "${target}" == "Spotify" || "${target}" == "ticktick" ]]
}

find_window_id() {
  niri msg --json windows 2>/dev/null \
    | jq -r --arg target "${target}" '
        map(select(.app_id == $target or .title == $target))
        | sort_by(.is_focused, .focus_timestamp.secs, .focus_timestamp.nanos)
        | last
        | .id // empty
      '
}

move_to_scratchpad() {
  local window_id="$1"

  niri msg action move-window-to-workspace --window-id "${window_id}" --focus=false "Scratchpad"
  niri msg action focus-workspace "Scratchpad"
}

focus_existing() {
  local window_id

  if ! window_id="$(find_window_id)"; then
    return 1
  fi

  if [[ -n "${window_id}" ]]; then
    if is_workspace_scratchpad_target; then
      move_to_scratchpad "${window_id}"
    fi
    niri msg action focus-window --id "${window_id}"
    return 0
  fi

  return 1
}

spawn_target() {
  case "${target}" in
    special-term)
      exec ghostty --class="com.mitchellh.ghostty" --title="${target}"
      ;;
    special-btop)
      exec ghostty --class="btop" --title="${target}" -e zsh -ic "btop"
      ;;
    special-files)
      exec ghostty --class="yazi" --title="${target}" -e zsh -ic "yazi"
      ;;
    special-nvim)
      exec ghostty --class="nvim" --title="${target}" -e zsh -ic "nvim"
      ;;
    special-project)
      exec ghostty --class="com.mitchellh.ghostty" --title="${target}" -e zsh -ic 'cd ~/projects 2>/dev/null || cd ~; exec zsh -il'
      ;;
    Spotify)
      spotify >/dev/null 2>&1 &
      ;;
    ticktick)
      ticktick >/dev/null 2>&1 &
      ;;
    *)
      echo "unknown scratchpad target: ${target}" >&2
      exit 64
      ;;
  esac
}

wait_and_move_to_scratchpad() {
  local window_id=""
  local attempt

  for attempt in {1..40}; do
    if window_id="$(find_window_id)" && [[ -n "${window_id}" ]]; then
      move_to_scratchpad "${window_id}"
      niri msg action focus-window --id "${window_id}"
      return 0
    fi
    sleep 0.25
  done

  echo "timed out waiting for scratchpad target: ${target}" >&2
  return 1
}

if ! focus_existing; then
  spawn_target
  if is_workspace_scratchpad_target; then
    wait_and_move_to_scratchpad
  fi
fi
