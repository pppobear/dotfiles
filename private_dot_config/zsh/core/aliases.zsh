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
  alias ls='eza --icons=always --color=always --group-directories-first'
  alias la='eza -a --icons=always --color=always --group-directories-first'
  alias ll='eza -la --git --icons=always --color=always --group-directories-first'
  alias lt='eza --tree --icons=always --color=always --group-directories-first'
  alias ld='eza -lD --icons=always --color=always'
elif command -v gls >/dev/null 2>&1; then
  alias ls='gls --color=auto --group-directories-first'
  alias la='gls -A --color=auto --group-directories-first'
  alias ll='gls -lah --color=auto --group-directories-first'
else
  alias ls='ls -G'
  alias la='ls -A'
  alias ll='ls -lah'
fi

# Clear screen
alias c='clear'
alias cls='clear'
