# Ultimate Linux Development Setup - Zsh Environment

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export PAGER="less"

# Language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Path configuration
typeset -U path PATH
path=(
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/.pyenv/bin
    $HOME/.fnm
    $HOME/.yarn/bin
    $HOME/.config/composer/vendor/bin
    $HOME/go/bin
    /usr/local/go/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    $path
)

# Man pages
export MANPATH="/usr/local/man:$MANPATH"

# Less configuration
export LESS="-R -F -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]"
export LESSCHARSET="utf-8"
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

# Development environments
export GOPATH="$HOME/go"
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export RBENV_ROOT="$HOME/.rbenv"

# Application settings
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export POWERSHELL_TELEMETRY_OPTOUT=1
export AZURE_CORE_COLLECT_TELEMETRY=0
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1

# GPG
export GPG_TTY=$(tty)

# SSH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Compilation flags (detect architecture)
if [[ "$(uname -m)" == "x86_64" ]]; then
    export ARCHFLAGS="-arch x86_64"
elif [[ "$(uname -m)" == "arm64" ]] || [[ "$(uname -m)" == "aarch64" ]]; then
    export ARCHFLAGS="-arch arm64"
fi

# Debian/Ubuntu specific
export DEBIAN_FRONTEND=noninteractive

# Security
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Disable telemetry for various tools
export DO_NOT_TRACK=1
export ADBLOCK=1
export DISABLE_OPENCOLLECTIVE=1
export GATSBY_TELEMETRY_DISABLED=1
export HASURA_GRAPHQL_ENABLE_TELEMETRY=false
export NEXT_TELEMETRY_DISABLED=1
export NUXT_TELEMETRY_DISABLED=1

# WSL specific settings
if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
    if [[ -f /etc/resolv.conf ]]; then
        nameserver=$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null)
        if [[ -n "$nameserver" ]]; then
            export DISPLAY="${nameserver}:0"
        fi
    fi
    export LIBGL_ALWAYS_INDIRECT=1
fi