#!/usr/bin/env zsh
# FZF configuration and integration

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  return 0
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
  --bind='ctrl-y:execute-silent(echo {+} | pbcopy)'
"

# FZF Ctrl-T options
export FZF_CTRL_T_OPTS="
  --border=rounded
  --preview-window=65%
"

# FZF Alt-C options
export FZF_ALT_C_OPTS="$FZF_CTRL_T_OPTS"

# Initialize fzf key bindings and fuzzy completion
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
else
  source <(fzf --zsh) 2>/dev/null
fi
