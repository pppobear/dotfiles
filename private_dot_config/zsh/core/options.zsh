#!/usr/bin/env zsh
# Core Zsh options and basic settings

# History configuration
HISTFILE="${ZDOTDIR:-$HOME/.config/zsh}/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000

# History options
setopt INC_APPEND_HISTORY      # Write to history file immediately
setopt SHARE_HISTORY           # Share history between sessions
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_FIND_NO_DUPS       # Don't show duplicates in search
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks

# Directory options
setopt AUTO_CD                 # cd by typing directory name
setopt AUTO_PUSHD              # Push directories onto stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
setopt PUSHD_SILENT            # Don't print directory stack

# Completion options
setopt MENU_COMPLETE           # Auto-select first completion
setopt AUTO_LIST               # List choices on ambiguous completion
setopt COMPLETE_IN_WORD        # Complete from both ends of word
setopt LIST_PACKED             # Compact completion lists
setopt LIST_ROWS_FIRST         # List completions in rows

# Other useful options
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shell
setopt NOMATCH                 # Print error on no match
setopt CORRECT                 # Try to correct spelling
setopt CDABLE_VARS             # Change to var value as dir
setopt EXTENDED_GLOB           # Extended globbing

# Key bindings (Emacs mode)
bindkey -e

# Configure word boundaries for Ctrl+W
# Remove '/' so that Ctrl+W stops at path separators (/a/b/c → /a/b/)
WORDCHARS=${WORDCHARS//\/}
