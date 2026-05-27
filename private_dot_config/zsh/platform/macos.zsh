#!/usr/bin/env zsh
# macOS-specific configuration

# LLVM (from Homebrew)
if [ -d /opt/homebrew/opt/llvm/bin ]; then
  case ":$PATH:" in
    *":/opt/homebrew/opt/llvm/bin:"*) ;;
    *) export PATH="/opt/homebrew/opt/llvm/bin:$PATH" ;;
  esac
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# OrbStack CLI integration
if [[ "${__ZSH_ORBSTACK_LOADED:-}" != "$$" && -f "$HOME/.orbstack/shell/init.zsh" ]]; then
  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
  typeset -gU path fpath
  typeset -g __ZSH_ORBSTACK_LOADED="$$"
fi

# macOS-specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Quick Look
alias ql='qlmanage -p "$@" >& /dev/null'

# pipx
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$PATH:$HOME/.local/bin" ;;
esac

# pywal16 colors
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

case ":$PATH:" in
  *":/Applications/Obsidian.app/Contents/MacOS:"*) ;;
  *) export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS" ;;
esac
