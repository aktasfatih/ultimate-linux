#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/update.log"
VERSION_FILE="${HOME}/.config/ultimate-linux/version.json"
ACTION="update"

source "${DOTFILES_DIR}/scripts/utils.sh"
source "${DOTFILES_DIR}/scripts/distro-detect.sh"
source "${DOTFILES_DIR}/scripts/package-managers.sh"

log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    case $level in
        ERROR) echo -e "\033[0;31m[ERROR]\033[0m $message" >&2 ;;
        WARN)  echo -e "\033[0;33m[WARN]\033[0m $message" ;;
        INFO)  echo -e "\033[0;34m[INFO]\033[0m $message" ;;
        SUCCESS) echo -e "\033[0;32m[SUCCESS]\033[0m $message" ;;
    esac
}

show_changelog() {
    if [[ ! -f "$VERSION_FILE" ]]; then
        echo -e "\033[0;33m[WARN]\033[0m No installation information found. Please run install.sh first."
        exit 1
    fi
    
    # Get installed commit from version file
    local installed_commit=$(grep '"commit"' "$VERSION_FILE" | head -1 | cut -d'"' -f4)
    
    if [[ "$installed_commit" == "unknown" ]]; then
        echo -e "\033[0;33m[WARN]\033[0m Cannot determine installed version."
        exit 1
    fi
    
    cd "$DOTFILES_DIR"
    
    # Get current commit
    local current_commit=$(git rev-parse HEAD 2>/dev/null)
    
    if [[ "$installed_commit" == "$current_commit" ]]; then
        echo -e "\033[0;32m✓ No updates available - installation is up to date\033[0m"
        exit 0
    fi
    
    echo -e "\033[1;34mChangelog - Updates since installation\033[0m"
    echo -e "\033[1;34m======================================\033[0m"
    echo
    echo -e "\033[0;36mInstalled version:\033[0m ${installed_commit:0:8}"
    echo -e "\033[0;36mCurrent version:\033[0m   ${current_commit:0:8}"
    echo
    echo -e "\033[1;33mChanges:\033[0m"
    echo "----------------------------------------"
    
    # Show commit log between installed and current
    git log --oneline --decorate --color=always "${installed_commit}..HEAD" | while IFS= read -r line; do
        echo "  $line"
    done
    
    echo
    echo -e "\033[1;33mDetailed changes:\033[0m"
    echo "----------------------------------------"
    
    # Show file changes summary
    git diff --stat --color=always "${installed_commit}..HEAD" | head -20
    
    local total_changes=$(git diff --shortstat "${installed_commit}..HEAD")
    echo
    echo -e "\033[0;36mSummary:\033[0m $total_changes"
    
    echo
    echo -e "\033[0;32mTo apply these updates, run:\033[0m ./update.sh"
}

update_version_info() {
    log INFO "Updating version information..."
    
    local version_dir="$(dirname "$VERSION_FILE")"
    mkdir -p "$version_dir"
    
    cd "$DOTFILES_DIR"
    local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    local commit_date=$(git log -1 --format="%ai" 2>/dev/null || echo "unknown")
    local commit_message=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "unknown")
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    local remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")
    
    # Read existing version file to preserve install info
    local install_date="$(date -Iseconds)"
    local install_mode="update"
    
    if [[ -f "$VERSION_FILE" ]]; then
        # Try to preserve original install date and mode
        local orig_install_date=$(grep '"install_date"' "$VERSION_FILE" | cut -d'"' -f4)
        local orig_install_mode=$(grep '"install_mode"' "$VERSION_FILE" | cut -d'"' -f4)
        
        if [[ -n "$orig_install_date" ]]; then
            install_date="$orig_install_date"
        fi
        if [[ -n "$orig_install_mode" ]]; then
            install_mode="$orig_install_mode"
        fi
    fi
    
    cat > "$VERSION_FILE" << EOF
{
    "install_date": "$install_date",
    "install_mode": "$install_mode",
    "last_update": "$(date -Iseconds)",
    "git": {
        "commit": "$commit_hash",
        "commit_date": "$commit_date",
        "commit_message": "$commit_message",
        "branch": "$branch",
        "remote": "$remote_url"
    },
    "dotfiles_dir": "$DOTFILES_DIR",
    "hostname": "$(hostname)",
    "os": "$(uname -s)",
    "os_version": "$(uname -r)"
}
EOF
    
    log SUCCESS "Version information updated"
}

update_dotfiles() {
    log INFO "Updating dotfiles repository..."
    
    cd "$DOTFILES_DIR"
    
    # Check for uncommitted changes
    if [[ -n $(git status -s) ]]; then
        log WARN "Uncommitted changes detected in dotfiles repository"
        read -p "Stash changes and continue? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git stash push -m "Auto-stash before update $(date +%Y%m%d_%H%M%S)"
            STASHED=true
        else
            log ERROR "Update cancelled due to uncommitted changes"
            return 1
        fi
    fi
    
    # Pull latest changes
    git pull origin main || git pull origin master
    
    # Restore stashed changes if any
    if [[ "${STASHED:-false}" == "true" ]]; then
        log INFO "Restoring stashed changes..."
        git stash pop
    fi
    
    log SUCCESS "Dotfiles repository updated"
}

update_packages() {
    log INFO "Updating system packages..."
    
    detect_distro
    upgrade_system
    
    log SUCCESS "System packages updated"
}

update_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log INFO "Updating Oh My Zsh..."
        (cd "$HOME/.oh-my-zsh" && git pull)
        
        # Update custom plugins
        local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
        
        if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
            log INFO "Updating zsh-autosuggestions..."
            (cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull)
        fi
        
        if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
            log INFO "Updating zsh-syntax-highlighting..."
            (cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull)
        fi
        
        log SUCCESS "Oh My Zsh updated"
    fi
}

update_tmux_plugins() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log INFO "Updating tmux plugins..."
        "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
        log SUCCESS "Tmux plugins updated"
    fi
}

update_neovim_plugins() {
    if command -v nvim &> /dev/null; then
        log INFO "Updating Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa
        log SUCCESS "Neovim plugins updated"
    fi
}

update_language_tools() {
    log INFO "Updating language tools..."
    
    # Update npm packages
    if command -v npm &> /dev/null; then
        log INFO "Updating global npm packages..."
        npm update -g
    fi
    
    # Update pip packages
    if command -v pip3 &> /dev/null; then
        log INFO "Updating Python packages..."
        pip3 list --user --outdated --format=json | python3 -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" | xargs -n1 pip3 install --user -U 2>/dev/null || true
    fi
    
    # Update Rust
    if command -v rustup &> /dev/null; then
        log INFO "Updating Rust toolchain..."
        rustup update
    fi
    
    # Update Go tools
    if command -v go &> /dev/null; then
        log INFO "Updating Go tools..."
        go install -v golang.org/x/tools/gopls@latest 2>/dev/null || true
    fi
    
    log SUCCESS "Language tools updated"
}

update_cli_tools() {
    log INFO "Updating CLI tools..."
    
    # Update tools installed via Cargo
    if command -v cargo &> /dev/null; then
        if command -v cargo-install-update &> /dev/null; then
            cargo install-update -a
        else
            cargo install cargo-update
            cargo install-update -a
        fi
    fi
    
    # Update starship
    if command -v starship &> /dev/null; then
        log INFO "Updating Starship prompt..."
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y
    fi
    
    # Update other tools
    local tools=(
        "fzf:~/.fzf/install --all --no-bash --no-fish"
        "zoxide:curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
    )
    
    for tool_cmd in "${tools[@]}"; do
        local tool="${tool_cmd%%:*}"
        local cmd="${tool_cmd#*:}"
        
        if command -v "$tool" &> /dev/null; then
            log INFO "Updating $tool..."
            eval "$cmd" || log WARN "Failed to update $tool"
        fi
    done
    
    log SUCCESS "CLI tools updated"
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                cat << EOF
Ultimate Linux Development Setup - Update

Usage: ./update.sh [OPTIONS]

Options:
    --help, -h          Show this help message
    --changelog         Show changes since installation
    --dotfiles-only     Update only dotfiles (skip packages)
    --packages-only     Update only system packages (skip dotfiles)
    --tools-only        Update only development tools
    --version           Show current installed version

Examples:
    ./update.sh                # Full update
    ./update.sh --changelog    # See what's changed
    ./update.sh --dotfiles-only # Update just configs
EOF
                exit 0
                ;;
            --changelog)
                ACTION="changelog"
                ;;
            --dotfiles-only)
                ACTION="dotfiles-only"
                ;;
            --packages-only)
                ACTION="packages-only"
                ;;
            --tools-only)
                ACTION="tools-only"
                ;;
            --version)
                ACTION="version"
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
        shift
    done
}

main() {
    parse_arguments "$@"
    
    case "$ACTION" in
        changelog)
            show_changelog
            ;;
        version)
            if [[ -f "$DOTFILES_DIR/install.sh" ]]; then
                "$DOTFILES_DIR/install.sh" --version
            else
                echo "Error: install.sh not found"
                exit 1
            fi
            ;;
        *)
            echo -e "\033[1;34mUltimate Linux Development Setup - Update\033[0m"
            echo -e "\033[1;34m========================================\033[0m"
            echo
            
            # Initialize log file
            mkdir -p "$(dirname "$LOG_FILE")"
            : > "$LOG_FILE"
            
            # Show changelog first if updates available
            if [[ -f "$VERSION_FILE" ]]; then
                cd "$DOTFILES_DIR"
                local installed_commit=$(grep '"commit"' "$VERSION_FILE" | head -1 | cut -d'"' -f4)
                local current_commit=$(git rev-parse HEAD 2>/dev/null)
                
                if [[ "$installed_commit" != "$current_commit" && "$installed_commit" != "unknown" ]]; then
                    echo -e "\033[0;33mShowing changes since last update:\033[0m"
                    show_changelog
                    echo
                    read -p "Do you want to continue with the update? [Y/n] " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ -n $REPLY ]]; then
                        echo "Update cancelled."
                        exit 0
                    fi
                fi
            fi
            
            # Create backup before updating
            log INFO "Creating backup before update..."
            "${DOTFILES_DIR}/backup.sh" --auto
            
            # Run updates based on action
            case "$ACTION" in
                dotfiles-only)
                    update_dotfiles
                    ;;
                packages-only)
                    update_packages
                    ;;
                tools-only)
                    update_language_tools
                    update_cli_tools
                    ;;
                *)
                    # Full update
                    update_dotfiles
                    update_packages
                    update_oh_my_zsh
                    update_tmux_plugins
                    update_neovim_plugins
                    update_language_tools
                    update_cli_tools
                    ;;
            esac
            
            # Update version info after successful update
            update_version_info
            
            # Clean package cache
            clean_package_cache
            
            echo
            echo -e "\033[1;32mUpdate completed successfully!\033[0m"
            echo -e "\033[1;33mUpdate log:\033[0m $LOG_FILE"
            echo
            echo "Please restart your terminal to ensure all updates take effect."
            ;;
    esac
}

# Run main function
main "$@"