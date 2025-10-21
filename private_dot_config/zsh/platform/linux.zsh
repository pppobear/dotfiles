#!/usr/bin/env zsh
# Linux-specific configuration

# Package manager shortcuts
if command -v paru >/dev/null 2>&1; then
  alias up='paru -Syu'
  alias yeet='sudo pacman -Rns'
  alias install='paru -S'
elif command -v yay >/dev/null 2>&1; then
  alias up='yay -Syu'
  alias yeet='sudo pacman -Rns'
  alias install='yay -S'
elif command -v apt >/dev/null 2>&1; then
  alias up='sudo apt update && sudo apt upgrade'
  alias install='sudo apt install'
  alias yeet='sudo apt remove'
elif command -v dnf >/dev/null 2>&1; then
  alias up='sudo dnf upgrade'
  alias install='sudo dnf install'
  alias yeet='sudo dnf remove'
fi

# pnpm (Linux)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun (Linux)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Pywal colors
if [ -f ~/.cache/wal/sequences ]; then
  (cat ~/.cache/wal/sequences &)
fi
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

# rbw ssh agent
if [ -n "$XDG_RUNTIME_DIR" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
fi

# Linux-specific aliases
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias open='xdg-open'
