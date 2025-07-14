# Ultimate Linux Development Setup - Zsh Completions

# Enable completion features
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# Completion options
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt MENU_COMPLETE
setopt COMPLETE_ALIASES
unsetopt FLOW_CONTROL

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/completion"

# Group completions by type
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{red}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Better completion for kill/killall
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

# SSH/SCP/RSYNC
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Docker completions
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Git completions enhancement
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-diff:*' sort false

# Directory completions
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-dirs-first true

# History completion
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore completion for commands we don't have
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# Custom completions for our functions
compdef _gnu_generic extract
compdef _gnu_generic compress
compdef _git gac gacp gnb gclean
compdef _docker dexec dlog dclean dstop
compdef '_files -W $HOME/notes' note todo

# Load additional completions
if [[ -d "$HOME/.config/zsh/completions" ]]; then
    fpath=("$HOME/.config/zsh/completions" $fpath)
fi

# Docker compose completion
if command -v docker-compose &> /dev/null; then
    complete -F _docker_compose docker-compose
fi

# Kubernetes completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

# Helm completion
if command -v helm &> /dev/null; then
    source <(helm completion zsh)
fi

# AWS CLI completion
if command -v aws_completer &> /dev/null; then
    complete -C aws_completer aws
fi

# Terraform completion
if command -v terraform &> /dev/null; then
    complete -o nospace -C terraform terraform
fi

# npm completion
if command -v npm &> /dev/null; then
    eval "$(npm completion)"
fi

# Rust/Cargo completion
if command -v rustup &> /dev/null; then
    rustup completions zsh > "$HOME/.config/zsh/completions/_rustup" 2>/dev/null || true
    rustup completions zsh cargo > "$HOME/.config/zsh/completions/_cargo" 2>/dev/null || true
fi