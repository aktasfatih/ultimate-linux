# Ultimate Linux Development Setup - Bash Configuration

# Shell guard - ensure this is only executed in Bash
if [ -z "${BASH_VERSION:-}" ]; then
    return 0 2>/dev/null || exit 0
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

# Update window size after each command
shopt -s checkwinsize

# Enable "**" pattern in pathname expansion
shopt -s globstar 2>/dev/null || true

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set colored prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Source universal aliases and functions
if [ -f "$HOME/.config/shell/aliases.sh" ]; then
    source "$HOME/.config/shell/aliases.sh"
fi

# Source bash-specific aliases
if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Modern CLI tools integration (if installed)
# These work in both Bash and Zsh

# fzf - Fuzzy finder
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
elif command -v fzf &>/dev/null; then
    # Basic fzf key bindings if fzf.bash not found
    bind -x '"\C-r": "history | fzf"'
fi

# zoxide - Better cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# Set default editor
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"

# Add local bin directories to PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Go
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$GOPATH/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Python
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    command -v pyenv &>/dev/null && eval "$(pyenv init -)"
fi

# Source local customizations
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# Source machine-specific config
[ -f "$HOME/.bashrc.$(hostname)" ] && source "$HOME/.bashrc.$(hostname)"