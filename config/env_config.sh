# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"  # Set default editor
export HISTSIZE=1000  # Command history size
export HISTFILESIZE=2000  # Bigger history file
export HISTCONTROL=ignoredups:erasedups  # No duplicate entries in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:clear"  # Ignore common commands
shopt -s histappend  # Append to history, don't overwrite

