# Ultimate Linux Development Setup - Zsh Configuration

export ZSH="$HOME/.oh-my-zsh"

# Theme - Using Starship prompt instead of Oh My Zsh theme
ZSH_THEME=""

# Plugins
plugins=(
    git
    docker
    docker-compose
    kubectl
    terraform
    aws
    gcloud
    npm
    yarn
    python
    pip
    rust
    golang
    ruby
    rails
    django
    laravel
    symfony
    composer
    vagrant
    ansible
    helm
    minikube
    tmux
    fzf
    z
    extract
    sudo
    command-not-found
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Oh My Zsh settings
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="false"
export UPDATE_ZSH_DAYS=7
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="false"
HIST_STAMPS="yyyy-mm-dd"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# Environment variables
export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export BROWSER='firefox'

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt CDABLE_VARS
setopt EXTENDED_GLOB

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt MENU_COMPLETE
unsetopt FLOW_CONTROL

# Correction
setopt CORRECT
setopt CORRECT_ALL

# Job control
setopt LONG_LIST_JOBS
setopt NOTIFY
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_CHECK_JOBS

# Aliases
if [ -f "$HOME/.config/zsh/aliases.zsh" ]; then
    source "$HOME/.config/zsh/aliases.zsh"
fi

# Modern CLI tools setup
# eza (better ls)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias lt='eza -T --icons'
    alias l='eza -la --icons --group-directories-first'
elif command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first'
    alias lt='exa -T --icons'
    alias l='exa -la --icons --group-directories-first'
fi

# bat (better cat)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias catp='bat'
elif command -v batcat &> /dev/null; then
    alias cat='batcat --style=plain --paging=never'
    alias catp='batcat'
    alias bat='batcat'
fi

# ripgrep
if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# fd (better find)
if command -v fd &> /dev/null; then
    alias find='fd'
fi

# dust (better du)
if command -v dust &> /dev/null; then
    alias du='dust'
fi

# procs (better ps)
if command -v procs &> /dev/null; then
    alias ps='procs'
fi

# bottom (better top)
if command -v btm &> /dev/null; then
    alias top='btm'
    alias htop='btm'
elif command -v bottom &> /dev/null; then
    alias top='bottom'
    alias htop='bottom'
fi

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gr='git remote'
alias gst='git status'
alias gss='git status -s'

# Utility aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'
alias md='mkdir -p'
alias rd='rmdir'
alias df='df -h'
alias free='free -h'
alias vi='nvim'
alias vim='nvim'
alias svi='sudo nvim'
alias edit='nvim'
alias ping='ping -c 5'
alias clr='clear'
alias cls='clear'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'
alias week='date +%V'
alias ports='netstat -tulanp'

# Safety nets
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Reload configuration
alias reload='source ~/.zshrc'
alias zshrc='${EDITOR} ~/.zshrc'

# FZF configuration
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --preview "bat --color=always --style=numbers --line-range=:500 {}"
        --preview-window=right:60%:wrap
    '
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
    # Load FZF key bindings and completion
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# Zoxide (better cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# pyenv
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" 2>/dev/null || true
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick backup
backup() {
    cp "$1"{,.bak-$(date +%Y%m%d-%H%M%S)}
}

# Find and replace in files
findreplace() {
    find . -type f -name "$1" -exec sed -i "s/$2/$3/g" {} +
}

# Create a directory and cd into it
take() {
    mkdir -p "$1" && cd "$1"
}

# Git commit with message
gcam() {
    git add -A && git commit -m "$1"
}

# Docker helpers
dexec() {
    docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

dlog() {
    docker logs -f "$1"
}

# System info
sysinfo() {
    echo "CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $2}')"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
}

# Weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Cheat sheet
cheat() {
    curl -s "cheat.sh/$1"
}

# Load local configuration if exists
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

# Load machine-specific configuration if exists
if [ -f "$HOME/.zshrc.$(hostname)" ]; then
    source "$HOME/.zshrc.$(hostname)"
fi

# Auto-suggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'

# Performance optimizations
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%U%B%F{yellow}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Welcome message
if command -v fastfetch &> /dev/null; then
    fastfetch
elif command -v neofetch &> /dev/null; then
    neofetch
fi