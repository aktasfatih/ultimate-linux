#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/update.log"

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

main() {
    echo -e "\033[1;34mUltimate Linux Development Setup - Update\033[0m"
    echo -e "\033[1;34m========================================\033[0m"
    echo
    
    # Initialize log file
    mkdir -p "$(dirname "$LOG_FILE")"
    : > "$LOG_FILE"
    
    # Create backup before updating
    log INFO "Creating backup before update..."
    "${DOTFILES_DIR}/backup.sh" --auto
    
    # Run updates
    update_dotfiles
    update_packages
    update_oh_my_zsh
    update_tmux_plugins
    update_neovim_plugins
    update_language_tools
    update_cli_tools
    
    # Clean package cache
    clean_package_cache
    
    echo
    echo -e "\033[1;32mUpdate completed successfully!\033[0m"
    echo -e "\033[1;33mUpdate log:\033[0m $LOG_FILE"
    echo
    echo "Please restart your terminal to ensure all updates take effect."
}

# Handle command line arguments
case "${1:-}" in
    --dotfiles-only)
        update_dotfiles
        ;;
    --packages-only)
        update_packages
        ;;
    --tools-only)
        update_language_tools
        update_cli_tools
        ;;
    *)
        main
        ;;
esac