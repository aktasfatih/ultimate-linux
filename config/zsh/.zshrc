# Ultimate Linux Development Setup - Zsh Configuration (zinit + Powerlevel10k)

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

### zinit installation and setup ###
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install zinit if not already installed
if [[ ! -d $ZINIT_HOME ]]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

### Powerlevel10k Theme (loaded first for instant prompt) ###
zinit ice depth=1
zinit light romkatv/powerlevel10k

### Essential Zsh Configuration ###

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

# Completion configuration
autoload -Uz compinit
# Only check cache once per day for speed
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

### Core Plugins (loaded immediately) ###

# Oh My Zsh library (essential utilities)
zinit snippet OMZL::git.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::key-bindings.zsh

# Oh My Zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::extract

### Turbo-loaded Plugins (lazy loaded for speed) ###
# These load asynchronously after the prompt appears

# Docker completions and aliases (turbo mode - load after 1 second)
zinit ice wait'1' lucid as'completion'
zinit snippet OMZP::docker

# Completions
zinit ice wait'0a' lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax highlighting (must load before history-substring-search)
zinit ice wait'0b' lucid atinit'zpcompinit; zpcdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# History substring search (must load AFTER syntax highlighting)
zinit ice wait'0c' lucid atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

# Autosuggestions (load last)
zinit ice wait'0d' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Colored man pages
zinit ice wait'0' lucid
zinit snippet OMZP::colored-man-pages

# z (directory jumper)
zinit ice wait'0' lucid
zinit snippet OMZP::z

### Auto-suggestions configuration ###
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true

### Load custom configurations ###
for config in functions completions key-bindings; do
    [[ -f "$HOME/.config/zsh/${config}.zsh" ]] && source "$HOME/.config/zsh/${config}.zsh"
done

# Load universal shell aliases (shared between bash and zsh)
[[ -f "$HOME/.config/shell/aliases.sh" ]] && source "$HOME/.config/shell/aliases.sh"

# Load zsh-specific aliases (but delay pyenv-conflicting ones)
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

### FZF configuration ###
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

### Tool Initializations (lazy loaded) ###

# Zoxide (better cd) - lazy load
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Pyenv (lazy load) - only initialize when python/pip/pyenv is called
# MUST come after aliases are loaded to override pip='pip3' alias
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    # Remove any existing aliases that would conflict with our functions
    unalias python 2>/dev/null || true
    unalias pip 2>/dev/null || true
    unalias pip3 2>/dev/null || true

    # Function to initialize pyenv once
    _lazy_load_pyenv() {
        eval "$(command pyenv init -)"
        if command -v pyenv virtualenv-init &> /dev/null; then
            eval "$(command pyenv virtualenv-init -)"
        fi
    }

    # Lazy load pyenv - removes all three functions and initializes
    pyenv() {
        unfunction pyenv python pip 2>/dev/null || true
        _lazy_load_pyenv
        pyenv "$@"
    }

    # Also lazy load for python
    python() {
        unfunction pyenv python pip 2>/dev/null || true
        _lazy_load_pyenv
        python "$@"
    }

    # Also lazy load for pip
    pip() {
        unfunction pyenv python pip 2>/dev/null || true
        _lazy_load_pyenv
        pip "$@"
    }
fi

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

### Auto-notify for long running commands ###
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
                osascript -e "display notification \"$bgnotify_lastcmd\" with title \"Command completed in ${elapsed}s\""
            else
                notify-send "Command completed in ${elapsed}s" "$bgnotify_lastcmd"
            fi
        fi
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec bgnotify_begin
    add-zsh-hook precmd bgnotify_end
fi

### Powerlevel10k Configuration ###
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

### Local Configurations ###
# Load local configuration if exists
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Load machine-specific configuration if exists
[[ -f "$HOME/.zshrc.$(hostname)" ]] && source "$HOME/.zshrc.$(hostname)"

# Performance profiling (uncomment to see results)
# zprof
