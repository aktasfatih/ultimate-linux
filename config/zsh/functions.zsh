# Ultimate Linux Development Setup - Zsh Functions

# Enhanced directory navigation
function cd() {
    builtin cd "$@" && ls -la
}

# Create and enter directory
function take() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup with timestamp
function backup() {
    if [[ -z "$1" ]]; then
        echo "Usage: backup <file/directory>"
        return 1
    fi
    cp -r "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backup created: $1.backup.$(date +%Y%m%d-%H%M%S)"
}

# Extract any archive
function extract() {
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
            *.xz) unxz $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create archive
function compress() {
    if [[ -z "$1" ]]; then
        echo "Usage: compress <directory/file> [format]"
        echo "Formats: tar.gz (default), tar.bz2, zip, 7z"
        return 1
    fi
    
    local target="$1"
    local format="${2:-tar.gz}"
    local output="${target%/}.${format}"
    
    case "$format" in
        tar.gz) tar czf "$output" "$target" ;;
        tar.bz2) tar cjf "$output" "$target" ;;
        zip) zip -r "$output" "$target" ;;
        7z) 7z a "$output" "$target" ;;
        *) echo "Unknown format: $format" && return 1 ;;
    esac
    
    echo "Created: $output"
}

# Git functions
function gac() {
    git add -A && git commit -m "$*"
}

function gacp() {
    git add -A && git commit -m "$*" && git push
}

function gnb() {
    # Create new branch
    if [[ -z "$1" ]]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

function gclean() {
    # Clean merged branches
    git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
}

# Docker functions
function dexec() {
    docker exec -it "$1" /bin/bash 2>/dev/null || docker exec -it "$1" /bin/sh
}

function dlog() {
    docker logs -f "$1"
}

function dclean() {
    # Clean Docker system
    docker system prune -af --volumes
}

function dstop() {
    # Stop all containers
    docker stop $(docker ps -q)
}

# Python virtual environment
function venv() {
    if [[ -d "venv" ]]; then
        source venv/bin/activate
    elif [[ -d ".venv" ]]; then
        source .venv/bin/activate
    else
        python3 -m venv venv && source venv/bin/activate
    fi
}

# Node.js project init
function node-init() {
    local name="${1:-my-app}"
    mkdir -p "$name" && cd "$name"
    npm init -y
    git init
    echo "node_modules/\n.env\n.DS_Store" > .gitignore
    echo "# $name\n\nDescription here" > README.md
}

# System info
function sysinfo() {
    echo "=== System Information ==="
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $2}')"
    echo "Uptime: $(uptime -p)"
    echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
}

# Network info
function netinfo() {
    echo "=== Network Information ==="
    echo "Hostname: $(hostname)"
    echo "Local IP: $(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)"
    echo "Public IP: $(curl -s https://api.ipify.org 2>/dev/null || echo 'N/A')"
    echo "Gateway: $(ip route | grep default | awk '{print $3}')"
    echo "DNS: $(grep nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd ' ')"
}

# Port usage
function port() {
    if [[ -z "$1" ]]; then
        echo "Usage: port <port-number>"
        return 1
    fi
    sudo lsof -i :$1
}

# Kill process on port
function killport() {
    if [[ -z "$1" ]]; then
        echo "Usage: killport <port-number>"
        return 1
    fi
    local pid=$(lsof -t -i:$1)
    if [[ -n "$pid" ]]; then
        kill -9 $pid
        echo "Killed process $pid on port $1"
    else
        echo "No process found on port $1"
    fi
}

# Weather
function weather() {
    curl -s "wttr.in/${1:-}"
}

# Cheatsheet
function cheat() {
    curl -s "cheat.sh/$1"
}

# Quick calculator
function calc() {
    echo "$*" | bc -l
}

# URL encode/decode
function urlencode() {
    python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))" "$1"
}

function urldecode() {
    python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))" "$1"
}

# JSON pretty print
function json() {
    if [[ -t 0 ]]; then
        python3 -m json.tool "$1"
    else
        python3 -m json.tool
    fi
}

# Quick HTTP server
function serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Find and replace in files
function replace() {
    if [[ $# -lt 3 ]]; then
        echo "Usage: replace <find> <replace> <file-pattern>"
        echo "Example: replace 'old' 'new' '*.txt'"
        return 1
    fi
    find . -type f -name "$3" -exec sed -i "s/$1/$2/g" {} +
}

# Fuzzy find and edit
function vf() {
    local file
    file=$(fzf --preview 'bat --color=always {}' --preview-window=right:60%:wrap)
    [[ -n "$file" ]] && nvim "$file"
}

# Fuzzy find and cd
function cf() {
    local dir
    dir=$(find ${1:-.} -type d -name .git -prune -o -type d -print 2> /dev/null | fzf --preview 'ls -la {}')
    [[ -n "$dir" ]] && cd "$dir"
}

# Git fuzzy branch checkout
function gcof() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Docker fuzzy exec
function dexecf() {
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | tail -n +2 | fzf | awk '{print $1}')
    [[ -n "$container" ]] && dexec "$container"
}

# Quick note taking
function note() {
    local file="$HOME/notes/$(date +%Y-%m-%d).md"
    mkdir -p "$HOME/notes"
    
    if [[ -z "$1" ]]; then
        nvim "$file"
    else
        echo -e "\n## $(date +%H:%M:%S)\n$*" >> "$file"
        echo "Note added to $file"
    fi
}

# Quick todo
function todo() {
    local file="$HOME/notes/todo.md"
    mkdir -p "$HOME/notes"
    
    if [[ -z "$1" ]]; then
        nvim "$file"
    else
        echo "- [ ] $*" >> "$file"
        echo "Todo added to $file"
    fi
}

# Timer
function timer() {
    local duration="${1:-5m}"
    echo "Timer started for $duration"
    sleep "$duration"
    notify-send "Timer finished!" "Your $duration timer is done." 2>/dev/null || echo -e "\a\nTimer finished!"
}

# Benchmark command
function bench() {
    if [[ -z "$1" ]]; then
        echo "Usage: bench <command>"
        return 1
    fi
    time (for i in {1..10}; do eval "$*" > /dev/null; done)
}

# Create QR code
function qr() {
    if [[ -z "$1" ]]; then
        echo "Usage: qr <text/url>"
        return 1
    fi
    echo "$1" | curl -F-=\<- qrenco.de
}