#!/usr/bin/env zsh
# Core aliases - cross-platform

# Editor shortcuts
alias v='nvim'
alias e='$EDITOR'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# File operations with safety
alias cp='cp -i -v'
alias mv='mv -i -v'
alias rm='rm -i -v'
alias mkdir='mkdir -p'

# ls/eza aliases
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --all --icons=always --color=always --group-directories-first'
  alias ll='eza -al --no-time --no-user --no-permissions --no-filesize --icons=always --color=always --group-directories-first'
  alias la='eza -la --icons=always --color=always --group-directories-first'
  alias lt='eza --tree --icons=always --color=always --group-directories-first'
  alias ld='eza -lD --icons=always --color=always'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah'
  alias la='ls -A'
fi

# Clear screen
alias c='clear'
alias cls='clear'

# bat
alias cat='bat'
