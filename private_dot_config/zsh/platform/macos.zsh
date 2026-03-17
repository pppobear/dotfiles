#!/usr/bin/env zsh
# macOS-specific configuration

# LLVM (from Homebrew)
if [ -d /opt/homebrew/opt/llvm/bin ]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# OrbStack CLI integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# macOS-specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Quick Look
alias ql='qlmanage -p "$@" >& /dev/null'

# rbw ssh-agent socket auto-detection
setup_rbw_ssh_auth_sock

# pipx
export PATH="$PATH:$HOME/.local/bin"

# pywal16 colors
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
