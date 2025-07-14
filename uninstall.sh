#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/uninstall.log"

source "${DOTFILES_DIR}/scripts/utils.sh"

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

confirm_uninstall() {
    echo -e "\033[1;31mWARNING: This will remove all dotfiles configurations!\033[0m"
    echo
    echo "This script will:"
    echo "  - Remove symlinks to dotfiles"
    echo "  - Optionally uninstall Oh My Zsh"
    echo "  - Optionally uninstall tmux plugins"
    echo "  - Optionally remove Neovim configuration"
    echo "  - Restore from backup if available"
    echo
    read -p "Are you sure you want to continue? [y/N] " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstall cancelled."
        exit 0
    fi
}

remove_symlinks() {
    log INFO "Removing configuration symlinks..."
    
    local configs=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.tmux.conf"
        "$HOME/.config/nvim"
        "$HOME/.gitconfig"
        "$HOME/.gitignore_global"
    )
    
    for config in "${configs[@]}"; do
        if [[ -L "$config" ]]; then
            log INFO "Removing symlink: $config"
            rm "$config"
        elif [[ -e "$config" ]]; then
            log WARN "$config exists but is not a symlink, skipping"
        fi
    done
    
    log SUCCESS "Symlinks removed"
}

uninstall_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        read -p "Uninstall Oh My Zsh? [y/N] " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Uninstalling Oh My Zsh..."
            
            # Run Oh My Zsh uninstaller if available
            if [[ -f "$HOME/.oh-my-zsh/tools/uninstall.sh" ]]; then
                env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/uninstall.sh"
            else
                rm -rf "$HOME/.oh-my-zsh"
            fi
            
            log SUCCESS "Oh My Zsh uninstalled"
        fi
    fi
}

uninstall_tmux_plugins() {
    if [[ -d "$HOME/.tmux/plugins" ]]; then
        read -p "Remove tmux plugins? [y/N] " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Removing tmux plugins..."
            rm -rf "$HOME/.tmux/plugins"
            log SUCCESS "Tmux plugins removed"
        fi
    fi
}

remove_neovim_config() {
    if [[ -d "$HOME/.config/nvim" ]] || [[ -d "$HOME/.local/share/nvim" ]]; then
        read -p "Remove Neovim configuration and plugins? [y/N] " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Removing Neovim configuration..."
            rm -rf "$HOME/.config/nvim"
            rm -rf "$HOME/.local/share/nvim"
            rm -rf "$HOME/.local/state/nvim"
            rm -rf "$HOME/.cache/nvim"
            log SUCCESS "Neovim configuration removed"
        fi
    fi
}

restore_from_backup() {
    local backup_dir="$HOME/.dotfiles_backups"
    
    if [[ -d "$backup_dir" ]]; then
        # Find most recent backup
        local latest_backup=$(ls -1d "$backup_dir"/backup_* 2>/dev/null | sort -r | head -1)
        
        if [[ -n "$latest_backup" ]]; then
            echo
            echo "Found backup: $latest_backup"
            read -p "Restore from this backup? [y/N] " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log INFO "Restoring from backup..."
                
                if [[ -x "$latest_backup/restore.sh" ]]; then
                    "$latest_backup/restore.sh"
                else
                    log ERROR "Restore script not found or not executable"
                fi
            fi
        else
            log WARN "No backups found"
        fi
    fi
}

clean_shell_configs() {
    log INFO "Cleaning shell configuration files..."
    
    # Remove our additions from shell files
    local shell_files=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.profile"
    )
    
    for file in "${shell_files[@]}"; do
        if [[ -f "$file" ]]; then
            # Remove lines between our markers
            sed -i '/# Ultimate Linux Development Setup - Start/,/# Ultimate Linux Development Setup - End/d' "$file" 2>/dev/null || true
        fi
    done
    
    log SUCCESS "Shell configurations cleaned"
}

remove_installed_tools() {
    read -p "Remove tools installed by this setup (e.g., starship, fzf)? [y/N] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log INFO "Removing installed tools..."
        
        # Remove starship
        if command -v starship &> /dev/null; then
            sudo rm -f /usr/local/bin/starship
        fi
        
        # Remove fzf
        if [[ -d "$HOME/.fzf" ]]; then
            "$HOME/.fzf/uninstall" 2>/dev/null || rm -rf "$HOME/.fzf"
        fi
        
        # Remove other tools from ~/.local/bin
        local tools=(
            "lazygit" "delta" "bottom" "dust" "procs"
            "zoxide" "eza" "bat" "fd" "rg"
        )
        
        for tool in "${tools[@]}"; do
            rm -f "$HOME/.local/bin/$tool"
        done
        
        log SUCCESS "Tools removed"
    fi
}

final_cleanup() {
    log INFO "Performing final cleanup..."
    
    # Remove empty directories
    rmdir "$HOME/.config" 2>/dev/null || true
    rmdir "$HOME/.local/bin" 2>/dev/null || true
    
    # Change shell back to bash if using zsh
    if [[ "$SHELL" == */zsh ]]; then
        read -p "Change default shell back to bash? [y/N] " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            chsh -s /bin/bash
            log SUCCESS "Default shell changed to bash"
        fi
    fi
    
    log SUCCESS "Cleanup completed"
}

main() {
    echo -e "\033[1;34mUltimate Linux Development Setup - Uninstall\033[0m"
    echo -e "\033[1;34m===========================================\033[0m"
    echo
    
    # Initialize log file
    mkdir -p "$(dirname "$LOG_FILE")"
    : > "$LOG_FILE"
    
    # Confirm before proceeding
    confirm_uninstall
    
    # Create backup before uninstalling
    read -p "Create backup before uninstalling? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        "${DOTFILES_DIR}/backup.sh"
    fi
    
    # Perform uninstallation
    remove_symlinks
    uninstall_oh_my_zsh
    uninstall_tmux_plugins
    remove_neovim_config
    clean_shell_configs
    remove_installed_tools
    
    # Offer to restore from backup
    restore_from_backup
    
    # Final cleanup
    final_cleanup
    
    echo
    echo -e "\033[1;32mUninstall completed!\033[0m"
    echo -e "\033[1;33mUninstall log:\033[0m $LOG_FILE"
    echo
    echo "Please restart your terminal to complete the process."
}

main