#!/usr/bin/env bash

set -euo pipefail

command_exists() {
    command -v "$1" &> /dev/null
}

is_wsl() {
    [[ -f /proc/version ]] && grep -qi microsoft /proc/version
}

is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

get_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        armv7l) echo "armv7" ;;
        i686) echo "386" ;;
        *) echo "$arch" ;;
    esac
}

get_os() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$os" in
        linux) echo "linux" ;;
        darwin) echo "darwin" ;;
        mingw*|msys*|cygwin*) echo "windows" ;;
        *) echo "$os" ;;
    esac
}

download_file() {
    local url="$1"
    local output="${2:-$(basename "$url")}"
    
    if command_exists curl; then
        curl -fsSL "$url" -o "$output"
    elif command_exists wget; then
        wget -q "$url" -O "$output"
    else
        log ERROR "Neither curl nor wget found. Cannot download files."
        return 1
    fi
}

extract_archive() {
    local file="$1"
    local dest="${2:-.}"
    
    case "$file" in
        *.tar.gz|*.tgz)
            tar -xzf "$file" -C "$dest"
            ;;
        *.tar.bz2)
            tar -xjf "$file" -C "$dest"
            ;;
        *.tar.xz)
            tar -xJf "$file" -C "$dest"
            ;;
        *.zip)
            unzip -q "$file" -d "$dest"
            ;;
        *.gz)
            gunzip "$file"
            ;;
        *)
            log ERROR "Unknown archive format: $file"
            return 1
            ;;
    esac
}

verify_checksum() {
    local file="$1"
    local expected_checksum="$2"
    local algorithm="${3:-sha256}"
    
    local actual_checksum
    case "$algorithm" in
        sha256)
            if command_exists sha256sum; then
                actual_checksum=$(sha256sum "$file" | awk '{print $1}')
            elif command_exists shasum; then
                actual_checksum=$(shasum -a 256 "$file" | awk '{print $1}')
            else
                log WARN "No SHA256 tool available, skipping checksum verification"
                return 0
            fi
            ;;
        sha512)
            if command_exists sha512sum; then
                actual_checksum=$(sha512sum "$file" | awk '{print $1}')
            elif command_exists shasum; then
                actual_checksum=$(shasum -a 512 "$file" | awk '{print $1}')
            else
                log WARN "No SHA512 tool available, skipping checksum verification"
                return 0
            fi
            ;;
        md5)
            if command_exists md5sum; then
                actual_checksum=$(md5sum "$file" | awk '{print $1}')
            elif command_exists md5; then
                actual_checksum=$(md5 -q "$file")
            else
                log WARN "No MD5 tool available, skipping checksum verification"
                return 0
            fi
            ;;
        *)
            log ERROR "Unknown checksum algorithm: $algorithm"
            return 1
            ;;
    esac
    
    if [[ "$actual_checksum" != "$expected_checksum" ]]; then
        log ERROR "Checksum verification failed for $file"
        log ERROR "Expected: $expected_checksum"
        log ERROR "Actual: $actual_checksum"
        return 1
    fi
    
    log INFO "Checksum verified for $file"
    return 0
}

install_from_github() {
    local repo="$1"
    local binary_name="${2:-$(basename "$repo")}"
    local install_path="${3:-/usr/local/bin}"
    
    local os=$(get_os)
    local arch=$(get_arch)
    
    log INFO "Installing $binary_name from GitHub..."
    
    # Get latest release URL
    local release_url="https://api.github.com/repos/$repo/releases/latest"
    local download_url
    
    # Try to find appropriate asset
    download_url=$(curl -s "$release_url" | grep -E "browser_download_url.*${os}.*${arch}" | cut -d '"' -f 4 | head -1)
    
    if [[ -z "$download_url" ]]; then
        # Try alternative patterns
        download_url=$(curl -s "$release_url" | grep -E "browser_download_url.*${os}" | grep -i "${arch}" | cut -d '"' -f 4 | head -1)
    fi
    
    if [[ -z "$download_url" ]]; then
        log ERROR "Could not find release for $os/$arch"
        return 1
    fi
    
    local temp_dir=$(mktemp -d)
    local filename=$(basename "$download_url")
    
    # Download the file
    download_file "$download_url" "$temp_dir/$filename"
    
    # Extract if needed
    if [[ "$filename" =~ \.(tar\.gz|tgz|zip|tar\.bz2|tar\.xz)$ ]]; then
        extract_archive "$temp_dir/$filename" "$temp_dir"
        
        # Find the binary
        local binary=$(find "$temp_dir" -name "$binary_name" -type f -executable | head -1)
        
        if [[ -z "$binary" ]]; then
            # Try without extension
            binary=$(find "$temp_dir" -name "${binary_name%.*}" -type f -executable | head -1)
        fi
        
        if [[ -n "$binary" ]]; then
            sudo install -m 755 "$binary" "$install_path/$binary_name"
        else
            log ERROR "Could not find binary $binary_name in archive"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        # Assume it's the binary itself
        sudo install -m 755 "$temp_dir/$filename" "$install_path/$binary_name"
    fi
    
    rm -rf "$temp_dir"
    log SUCCESS "Installed $binary_name to $install_path"
}

install_via_cargo() {
    local package="$1"
    
    if ! command_exists cargo; then
        log WARN "Cargo not found, skipping $package"
        return 1
    fi
    
    log INFO "Installing $package via Cargo..."
    cargo install "$package"
}

create_directory_structure() {
    local base_dir="$1"
    shift
    local dirs=("$@")
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$base_dir/$dir"
    done
}

backup_file() {
    local file="$1"
    local backup_suffix="${2:-.bak}"
    
    if [[ -f "$file" ]]; then
        local backup_name="${file}${backup_suffix}"
        local counter=1
        
        # Find unique backup name
        while [[ -f "$backup_name" ]]; do
            backup_name="${file}${backup_suffix}.${counter}"
            ((counter++))
        done
        
        cp "$file" "$backup_name"
        log INFO "Backed up $file to $backup_name"
    fi
}

ensure_line_in_file() {
    local file="$1"
    local line="$2"
    local pattern="${3:-$line}"
    
    if [[ ! -f "$file" ]]; then
        echo "$line" > "$file"
    elif ! grep -qF "$pattern" "$file"; then
        echo "$line" >> "$file"
    fi
}

remove_line_from_file() {
    local file="$1"
    local pattern="$2"
    
    if [[ -f "$file" ]]; then
        local temp_file=$(mktemp)
        grep -vF "$pattern" "$file" > "$temp_file" || true
        mv "$temp_file" "$file"
    fi
}

get_user_input() {
    local prompt="$1"
    local default="${2:-}"
    local var_name="$3"
    
    if [[ -n "$default" ]]; then
        read -p "$prompt [$default]: " input
        input="${input:-$default}"
    else
        read -p "$prompt: " input
    fi
    
    eval "$var_name='$input'"
}

confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-y}"
    
    local yn
    if [[ "$default" == "y" ]]; then
        read -p "$prompt [Y/n] " -n 1 -r yn
    else
        read -p "$prompt [y/N] " -n 1 -r yn
    fi
    echo
    
    case "$yn" in
        [Yy]) return 0 ;;
        [Nn]) return 1 ;;
        "") [[ "$default" == "y" ]] && return 0 || return 1 ;;
        *) return 1 ;;
    esac
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while ps -p "$pid" > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

run_with_spinner() {
    local command="$1"
    local message="${2:-Processing...}"
    
    echo -n "$message"
    eval "$command" &> /dev/null &
    local pid=$!
    spinner $pid
    wait $pid
    local result=$?
    
    if [[ $result -eq 0 ]]; then
        echo -e " ${GREEN}✓${NC}"
    else
        echo -e " ${RED}✗${NC}"
    fi
    
    return $result
}

get_latest_version() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

cleanup_temp_files() {
    if [[ -n "${TEMP_DIR:-}" ]] && [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup_temp_files EXIT

export -f command_exists is_wsl is_macos is_linux get_arch get_os
export -f download_file extract_archive verify_checksum
export -f install_from_github install_via_cargo
export -f create_directory_structure backup_file
export -f ensure_line_in_file remove_line_from_file
export -f get_user_input confirm spinner run_with_spinner
export -f get_latest_version version_gt