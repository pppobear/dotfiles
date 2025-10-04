# Enable emacs mode for zsh line editing
bindkey -e

# Essential Emacs keybindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^Y' yank
export KEYTIMEOUT=1

# Edit line in editor with ctrl-x ctrl-e (emacs style):
autoload edit-command-line; zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Use arrow-like keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^n' expand-or-complete
bindkey -M menuselect '^p' reverse-menu-complete
bindkey '^?' backward-delete-char

# Close completion menu with esacpe
bindkey -M menuselect '^[' send-break

# Cursor shape configuration (disabled for emacs mode)
# function zle-keymap-select () {
#     case $KEYMAP in
#         vicmd) echo -ne '\e[2 q';;      # block
#         viins|main) echo -ne '\e[6 q';; # beam
#     esac
# }
# zle -N zle-keymap-select

# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[6 q"
# }
# zle -N zle-line-init

# echo -ne '\e[6 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.
