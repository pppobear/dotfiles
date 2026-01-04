# Start starship - Cache for faster startup
if command -v starship >/dev/null 2>&1; then
  _starship_cache="${ZDOTDIR:-$HOME/.config/zsh}/.starship_cache"
  if [[ ! -f "$_starship_cache" ]] || [[ $(find "$_starship_cache" -mtime +7 2>/dev/null) ]]; then
    starship init zsh > "$_starship_cache" 2>/dev/null
  fi
  [[ -f "$_starship_cache" ]] && source "$_starship_cache"
  unset _starship_cache
fi

# Set up fzf key bindings and fuzzy completion - Cache for faster startup
if command -v fzf >/dev/null 2>&1; then
  _fzf_cache="${ZDOTDIR:-$HOME/.config/zsh}/.fzf_cache"
  if [[ ! -f "$_fzf_cache" ]] || [[ $(find "$_fzf_cache" -mtime +7 2>/dev/null) ]]; then
    fzf --zsh > "$_fzf_cache" 2>/dev/null
  fi
  [[ -f "$_fzf_cache" ]] && source "$_fzf_cache"
  unset _fzf_cache
fi

# Homebrew 环境 - Cache for faster startup
if [ -x /opt/homebrew/bin/brew ]; then
  _brew_cache="${ZDOTDIR:-$HOME/.config/zsh}/.brew_cache"
  if [[ ! -f "$_brew_cache" ]] || [[ $(find "$_brew_cache" -mtime +7 2>/dev/null) ]]; then
    /opt/homebrew/bin/brew shellenv > "$_brew_cache" 2>/dev/null
  fi
  [[ -f "$_brew_cache" ]] && source "$_brew_cache"
  unset _brew_cache
fi

# pipx 可执行路径
export PATH="$PATH:$HOME/.local/bin"

# OrbStack CLI 集成（若安装）
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# fnm is loaded in tools/fnm.zsh

# Source pywal16 colors
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

# compinit is already handled in plugins/zsh-plugins.zsh - removed duplicate
# fpath for zsh-completions is also already set there
