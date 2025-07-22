# Ultimate Linux Development Setup - Zsh Configuration

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Shell guard - ensure this is only executed in Zsh
if [ -z "${ZSH_VERSION:-}" ]; then
    return 0 2>/dev/null || exit 0
fi

# Performance profiling (uncomment to debug slow startup)
# zmodload zsh/zprof

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme - Using Starship prompt instead of Oh My Zsh theme
ZSH_THEME=""

# Plugin configuration before loading
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' autoload yes

# Plugins - Optimized for performance
plugins=(
    # Core functionality
    git
    z
    fzf
    extract
    sudo
    command-not-found
    colored-man-pages
    
    # Enhanced functionality (lazy loaded)
    docker
    docker-compose
    kubectl
    npm
    pip
    
    # Must be last
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Oh My Zsh settings
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
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
export LESS='-R -F -X'
export BROWSER='firefox'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
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
setopt GLOB_DOTS

# Load custom configurations
for config in functions completions key-bindings; do
    [[ -f "$HOME/.config/zsh/${config}.zsh" ]] && source "$HOME/.config/zsh/${config}.zsh"
done

# Load universal shell aliases (shared between bash and zsh)
[[ -f "$HOME/.config/shell/aliases.sh" ]] && source "$HOME/.config/shell/aliases.sh"

# Load zsh-specific aliases (these may override universal ones)
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

# Note: Modern CLI tool aliases are loaded from config files above
# Any zsh-specific overrides can be added here if needed

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
        --bind="ctrl-/:toggle-preview"
        --bind="ctrl-y:execute-silent(echo {} | xclip -selection clipboard)"
    '
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    
    # Load FZF key bindings and completion
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    
    # Enhanced FZF functions
    # Git commit browser
    fshow() {
        git log --graph --color=always \
            --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
    FZF-EOF"
    }
fi

# Zoxide (better cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
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
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# atuin (better history)
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# mcfly (smart history search)
if command -v mcfly &> /dev/null; then
    eval "$(mcfly init zsh)"
fi

# Auto-suggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'

# Performance optimizations
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-compctl false

# Auto-notify for long running commands
# Check for notification command (Linux: notify-send, macOS: osascript)
if command -v notify-send &> /dev/null || [[ "$(uname)" == "Darwin" ]]; then
    bgnotify_threshold=10
    
    function bgnotify_begin {
        bgnotify_timestamp=$EPOCHSECONDS
        bgnotify_lastcmd="$1"
        bgnotify_appid="$TERM_SESSION_ID"
    }
    
    function bgnotify_end {
        elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))
        past_threshold=$(( elapsed >= bgnotify_threshold ))
        if [[ $bgnotify_appid == "$TERM_SESSION_ID" ]] && [[ $past_threshold -eq 1 ]]; then
            if [[ "$(uname)" == "Darwin" ]]; then
                # macOS notification
                osascript -e "display notification \"$bgnotify_lastcmd\" with title \"Command completed in ${elapsed}s\""
            else
                # Linux notification
                notify-send "Command completed in ${elapsed}s" "$bgnotify_lastcmd"
            fi
        fi
    }
    
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec bgnotify_begin
    add-zsh-hook precmd bgnotify_end
fi

# Note: Most aliases are loaded from config files above
# Any additional zsh-specific aliases can be added here

# Welcome message
if command -v fastfetch &> /dev/null; then
    fastfetch
elif command -v neofetch &> /dev/null; then
    neofetch
fi

# Load local configuration if exists
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Load machine-specific configuration if exists
[[ -f "$HOME/.zshrc.$(hostname)" ]] && source "$HOME/.zshrc.$(hostname)"

# Performance profiling (uncomment to see results)
# zprof