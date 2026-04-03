#!/usr/bin/env zsh
# sesh integration

if ! command -v sesh >/dev/null 2>&1; then
  return 0
fi

_sesh_completion="${ZDOTDIR:-$HOME/.config/zsh}/.sesh_completion"

if [[ ! -f "$_sesh_completion" ]] || [[ $(find "$_sesh_completion" -mtime +7 2>/dev/null) ]]; then
  sesh completion zsh > "$_sesh_completion" 2>/dev/null
fi

[[ -f "$_sesh_completion" ]] && source "$_sesh_completion"

sesh-sessions() {
  {
    exec </dev/tty
    exec <&1

    local session
    session="$(
      sesh list -t -c -z -i 2>/dev/null | fzf \
        --height 40% \
        --reverse \
        --border \
        --border-label ' sesh ' \
        --prompt 'sesh> '
    )"

    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return

    sesh connect "$session"
  }
}

if command -v fzf >/dev/null 2>&1; then
  zle -N sesh-sessions
  bindkey -M emacs '\es' sesh-sessions
  bindkey -M vicmd '\es' sesh-sessions
  bindkey -M viins '\es' sesh-sessions
fi

unset _sesh_completion
