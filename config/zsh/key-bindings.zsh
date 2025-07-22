# Ultimate Linux Development Setup - Zsh Key Bindings

# Enable vi mode
bindkey -v
export KEYTIMEOUT=1

# Better vi mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey '^y' yank
bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^f' forward-char
bindkey '^b' backward-char
bindkey '^d' delete-char

# Edit command in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey '^x^e' edit-command-line

# History search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# Better history search with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# Substring search (if plugin is loaded)
if [[ -n "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi

# FZF key bindings
if command -v fzf &> /dev/null; then
    # File search
    fzf-file-widget() {
        LBUFFER="${LBUFFER}$(fzf --preview 'bat --color=always {} 2>/dev/null || cat {}')"
        local ret=$?
        zle reset-prompt
        return $ret
    }
    zle -N fzf-file-widget
    bindkey '^t' fzf-file-widget

    # History search
    fzf-history-widget() {
        local selected
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
        selected=$(fc -rl 1 | fzf --query="$LBUFFER" --no-sort --tiebreak=index | sed 's/ *[0-9]* *//')
        local ret=$?
        if [[ -n "$selected" ]]; then
            LBUFFER="$selected"
        fi
        zle reset-prompt
        return $ret
    }
    zle -N fzf-history-widget
    bindkey '^r' fzf-history-widget

    # Directory navigation
    fzf-cd-widget() {
        local dir
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf --preview 'ls -la {}') && cd "$dir"
        local ret=$?
        zle reset-prompt
        return $ret
    }
    zle -N fzf-cd-widget
    bindkey '\ec' fzf-cd-widget

    # Git branch widget
    fzf-git-branch-widget() {
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" | fzf --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed s/^..// | cut -d" " -f1)' | sed "s/.* //" | sed "s#remotes/[^/]*/##") &&
        LBUFFER="${LBUFFER}${branch}"
        local ret=$?
        zle reset-prompt
        return $ret
    }
    zle -N fzf-git-branch-widget
    bindkey '^g^b' fzf-git-branch-widget

    # Process kill widget
    fzf-kill-widget() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [[ -n "$pid" ]]; then
            echo "$pid" | xargs kill -9
        fi
        zle reset-prompt
    }
    zle -N fzf-kill-widget
    bindkey '^k^k' fzf-kill-widget
fi

# Quick command widgets
# Unalias run-help if it exists (Oh My Zsh may define it)
unalias run-help 2>/dev/null || true

run-help() {
    if [[ -n "$BUFFER" ]]; then
        BUFFER="man $BUFFER"
        zle accept-line
    fi
}
zle -N run-help
bindkey '\eh' run-help

# Sudo prefix
sudo-command-line() {
    if [[ -z "$BUFFER" ]]; then
        LBUFFER="sudo $(fc -ln -1)"
    elif [[ "$BUFFER" == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey '\es' sudo-command-line

# Quick directory jumps
bindkey -s '^o' 'lfcd\n'
bindkey -s '^]' 'zi\n'

# Accept autosuggestion
if [[ -n "$ZSH_AUTOSUGGEST_ACCEPT_WIDGETS" ]]; then
    bindkey '^ ' autosuggest-accept
    bindkey '^f' autosuggest-accept
fi

# Expand aliases
expand-alias() {
    zle _expand_alias
    zle expand-word
}
zle -N expand-alias
bindkey '^xa' expand-alias

# Quick git status
bindkey -s '^g^s' 'git status\n'

# Clear screen
bindkey '^l' clear-screen

# Undo/Redo
bindkey '^z' undo
bindkey '^y' redo

# Quote/Unquote
bindkey '^[q' quote-region
bindkey '^[Q' quote-line

# Transpose
bindkey '^t' transpose-chars
bindkey '\et' transpose-words

# Case manipulation
bindkey '\eu' up-case-word
bindkey '\el' down-case-word
bindkey '\ec' capitalize-word

# Directory stack
bindkey -s '\ed' 'dirs -v\n'

# Quick exit
exit-shell() {
    exit
}
zle -N exit-shell
bindkey '^d' exit-shell

# Custom widget for inserting last command output
insert-last-command-output() {
    LBUFFER="${LBUFFER}$(eval $(fc -ln -1))"
}
zle -N insert-last-command-output
bindkey '^x^l' insert-last-command-output

# tmux sessionizer
if command -v tmux &> /dev/null; then
    bindkey -s '^f' 'tmux-sessionizer\n'
fi