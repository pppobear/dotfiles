#!/usr/bin/env zsh
# macOS-specific configuration

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Homebrew completions
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
fi

# LLVM (from Homebrew)
if [ -d /opt/homebrew/opt/llvm/bin ]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
fi

# pnpm (macOS)
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun (macOS)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# console-ninja
export PATH="$HOME/.console-ninja/.bin:$PATH"

# OrbStack CLI integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# autojump (Homebrew installation)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# macOS-specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Quick Look
alias ql='qlmanage -p "$@" >& /dev/null'
