#!/usr/bin/env bash
# Universal shell aliases and functions - works in both Bash and Zsh
#
# This file contains aliases that work identically in both Bash and Zsh.
# Shell-specific overrides should go in:
#   - ~/.config/zsh/aliases.zsh (for Zsh)
#   - ~/.bashrc.local (for Bash)
#
# Load order:
#   1. This file (universal aliases)
#   2. Shell-specific aliases (which can override these)

# Color support detection
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -lart'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Create parent directories
alias mkdir='mkdir -pv'

# Human-readable sizes
alias df='df -h'
alias du='du -h'
alias free='free -m'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Network
alias ports='netstat -tulanp'

# System info
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'

# Git aliases (basic set - extended in shell-specific configs)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias glog='git log --oneline --graph --decorate'
# Note: Some git aliases (gl, etc.) may be overridden in shell-specific configs

# Docker aliases
if command -v docker &>/dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dex='docker exec -it'
    alias dlogs='docker logs -f'
fi

# Modern CLI tool replacements (if installed)
command -v bat &>/dev/null && alias cat='bat'
command -v batcat &>/dev/null && alias cat='batcat'
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias tree='eza --tree'
    # Override common aliases to use eza-compatible flags
    alias ll='eza -alF'
    alias la='eza -a'
    alias l='eza -F'
    alias lt='eza -al --sort=modified'
elif command -v exa &>/dev/null; then
    alias ls='exa'
    alias tree='exa --tree'
    # Override common aliases to use exa-compatible flags
    alias ll='exa -alF'
    alias la='exa -a'
    alias l='exa -F'
    alias lt='exa -al --sort=modified'
fi
command -v rg &>/dev/null && alias grep='rg'
command -v fd &>/dev/null && alias find='fd'
command -v procs &>/dev/null && alias ps='procs'
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v btm &>/dev/null && alias top='btm'
command -v htop &>/dev/null && alias top='htop'

# Clipboard aliases
if command -v xclip &>/dev/null; then
    alias clip='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
elif command -v xsel &>/dev/null; then
    alias clip='xsel --clipboard --input'
    alias paste='xsel --clipboard --output'
elif command -v pbcopy &>/dev/null; then
    alias clip='pbcopy'
    alias paste='pbpaste'
fi

# Extract function - works with multiple archive formats
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar x "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Find in history
hgrep() {
    history | grep -i "$1"
}

# Get public IP
myip() {
    curl -s https://api.ipify.org
    echo
}

# Weather (requires curl)
weather() {
    curl -s "wttr.in/${1:-}"
}

# Quick calculator
calc() {
    echo "$@" | bc -l
}

# Vim/Neovim preference
if command -v nvim &>/dev/null; then
    alias vim='nvim'
    alias vi='nvim'
    export EDITOR='nvim'
elif command -v vim &>/dev/null; then
    alias vi='vim'
    export EDITOR='vim'
fi

# Reload shell configuration
reload() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        source ~/.zshrc
        echo "Zsh configuration reloaded"
    elif [ -n "${BASH_VERSION:-}" ]; then
        source ~/.bashrc
        echo "Bash configuration reloaded"
    fi
}