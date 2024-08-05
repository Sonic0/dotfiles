# Easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# General
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='eza'
alias eza='eza -abghHliS --group-directories-first'
alias cat='batcat'
alias bathelp='batcat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}