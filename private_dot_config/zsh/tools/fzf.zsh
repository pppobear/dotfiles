#!/usr/bin/env zsh
# FZF configuration and integration

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  return 0
fi

# Lightweight key bindings. Completion should come from Homebrew/site-functions
# via compinit, so avoid the heavier `eval "$(fzf --zsh)"` startup path.
if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
elif [[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi

# FZF default command (use fd if available, fallback to find)
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*'"
fi

# FZF default options
if command -v pbcopy &>/dev/null; then
  _fzf_copy_cmd="pbcopy"
elif command -v xclip &>/dev/null; then
  _fzf_copy_cmd="xclip -selection clipboard"
elif command -v xsel &>/dev/null; then
  _fzf_copy_cmd="xsel --clipboard --input"
else
  _fzf_copy_cmd="cat"
fi

export FZF_DEFAULT_OPTS="
  --ansi
  --sort
  --layout=default
  --border=rounded
  --info=inline
  --height=80%
  --multi
  --preview-window=:hidden
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | head -200))'
  --bind='ctrl-c:abort'
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-b:preview-page-up'
  --bind='ctrl-f:preview-page-down'
  --bind='ctrl-u:preview-half-page-up'
  --bind='ctrl-d:preview-half-page-down'
  --bind='ctrl-a:select-all'
  --bind='ctrl-y:execute-silent(echo {+} | $_fzf_copy_cmd)'
"

unset _fzf_copy_cmd

# FZF Ctrl-T options
export FZF_CTRL_T_OPTS="
  --border=rounded
  --preview-window=65%
"

# FZF Alt-C options
export FZF_ALT_C_OPTS="$FZF_CTRL_T_OPTS"
