#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
    # This is a good place to load graphic/ascii art, display system information, etc.
    if command -v pokego >/dev/null; then
        pokego --no-title -r 1,3,6
    elif command -v pokemon-colorscripts >/dev/null; then
        pokemon-colorscripts --no-title -r 1,3,6
    elif command -v fastfetch >/dev/null; then
        if do_render "image"; then
            fastfetch --logo-type kitty
        fi
    fi
fi

#   Overrides 
# HYDE_ZSH_NO_PLUGINS=1 # Set to 1 to disable loading of oh-my-zsh plugins, useful if you want to use your zsh plugins system 
# unset HYDE_ZSH_PROMPT # Uncomment to unset/disable loading of prompts from HyDE and let you load your own prompts
# HYDE_ZSH_COMPINIT_CHECK=1 # Set 24 (hours) per compinit security check // lessens startup time
# HYDE_ZSH_OMZ_DEFER=1 # Set to 1 to defer loading of oh-my-zsh plugins ONLY if prompt is already loaded

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    #  OMZ Plugins 
    # manually add your oh-my-zsh plugins here
    plugins=(
        "sudo"
    )
fi

# 基础环境配置
export LANG=zh_CN.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export SUDO_EDITOR=nvim
export GITHUB_USERNAME=pppobear

# 路径配置
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$HOME/scripts:$PATH:$HOME/go/bin:$HOME/.cargo/bin"
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# 历史配置
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

# Zsh 选项
setopt INC_APPEND_HISTORY SHARE_HISTORY INTERACTIVE_COMMENTS NOMATCH AUTO_CD AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS PUSHD_SILENT CORRECT CDABLE_VARS EXTENDED_GLOB
setopt LIST_PACKED LIST_ROWS_FIRST MENU_COMPLETE AUTO_LIST COMPLETE_IN_WORD

# 自动补全
autoload -Uz compinit; compinit -C
zmodload zsh/complist
zstyle ':completion:*' menu select use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 按键绑定
bindkey -e

# Aliases
alias v=nvim
alias ..='cd ..' ...='cd ../..'
alias ls='eza --all --icons=always --color=always --group-directories-first'
alias ll='eza -al --no-time --no-user --no-permissions --no-filesize --icons=always --color=always --group-directories-first'
alias cp="cp -i -v" mv='mv -i -v' rm='rm -i -v'
alias gs='git status' ga='git add' gc='git commit' gp='git push' gP='git pull'
alias up='paru -Syu' yeet="sudo pacman -Rns"

# 有用的函数
lfcd() { cd "$(command lf -print-last-dir "$@")" || exit; }
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd" || exit
  fi
  rm -f -- "$tmp"
}

# FZF 配置
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Pywal colors (如果存在)
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

# NVM (如果存在)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# rbw ssh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"

# 加载插件和外部工具
source <(fzf --zsh 2>/dev/null)
eval "$(starship init zsh 2>/dev/null)"

# YesCode API key for Codex
export YESCODE_API_KEY="team-6b1d609889f79233cba7002429263437b69c688cee36c0c5"
