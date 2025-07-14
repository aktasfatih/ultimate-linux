#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE_DIR="${HOME}/.dotfiles_backups"
BACKUP_DIR="${BACKUP_BASE_DIR}/backup_$(date +%Y%m%d_%H%M%S)"
AUTO_MODE=false

if [[ "${1:-}" == "--auto" ]]; then
    AUTO_MODE=true
fi

source "${DOTFILES_DIR}/scripts/utils.sh"

create_backup() {
    echo "Creating backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # List of items to backup
    local items=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.tmux.conf"
        "$HOME/.tmux"
        "$HOME/.config/nvim"
        "$HOME/.vimrc"
        "$HOME/.vim"
        "$HOME/.gitconfig"
        "$HOME/.gitignore_global"
        "$HOME/.ssh/config"
        "$HOME/.config/starship.toml"
    )
    
    # Additional items for full backup
    if [[ "$AUTO_MODE" == "false" ]]; then
        items+=(
            "$HOME/.oh-my-zsh/custom"
            "$HOME/.local/bin"
            "$HOME/.config/alacritty"
            "$HOME/.config/kitty"
            "$HOME/.config/htop"
            "$HOME/.config/btop"
        )
    fi
    
    # Create backup
    for item in "${items[@]}"; do
        if [[ -e "$item" ]]; then
            echo "Backing up: $item"
            
            # Create directory structure
            local rel_path="${item#$HOME/}"
            local backup_path="$BACKUP_DIR/$rel_path"
            mkdir -p "$(dirname "$backup_path")"
            
            # Copy item
            if [[ -d "$item" ]]; then
                cp -r "$item" "$(dirname "$backup_path")"
            else
                cp "$item" "$backup_path"
            fi
        fi
    done
    
    # Save system information
    echo "Saving system information..."
    {
        echo "Backup created: $(date)"
        echo "System: $(uname -a)"
        echo "Distribution: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo 'Unknown')"
        echo
        echo "Installed packages:"
        if command -v dpkg &> /dev/null; then
            dpkg --get-selections | grep -v deinstall
        elif command -v rpm &> /dev/null; then
            rpm -qa
        elif command -v pacman &> /dev/null; then
            pacman -Q
        fi
    } > "$BACKUP_DIR/system_info.txt"
    
    # Create restore script
    cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESTORE_LOG="$HOME/dotfiles_restore_$(date +%Y%m%d_%H%M%S).log"

echo "Restoring from backup: $BACKUP_DIR"
echo "Log file: $RESTORE_LOG"
echo

# Function to restore item
restore_item() {
    local backup_item="$1"
    local target_item="$2"
    
    if [[ -e "$backup_item" ]]; then
        echo "Restoring: $target_item" | tee -a "$RESTORE_LOG"
        
        # Backup current item if exists
        if [[ -e "$target_item" ]]; then
            mv "$target_item" "${target_item}.before_restore" 2>> "$RESTORE_LOG"
        fi
        
        # Create parent directory
        mkdir -p "$(dirname "$target_item")" 2>> "$RESTORE_LOG"
        
        # Restore item
        cp -r "$backup_item" "$target_item" 2>> "$RESTORE_LOG"
    fi
}

# Confirm restore
read -p "This will restore configurations from backup. Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

# Find all backed up items
find "$BACKUP_DIR" -type f -o -type d | while read -r item; do
    # Skip the backup directory itself and special files
    if [[ "$item" == "$BACKUP_DIR" ]] || \
       [[ "$item" == "$BACKUP_DIR/restore.sh" ]] || \
       [[ "$item" == "$BACKUP_DIR/system_info.txt" ]]; then
        continue
    fi
    
    # Calculate target path
    rel_path="${item#$BACKUP_DIR/}"
    target_path="$HOME/$rel_path"
    
    # Skip if this is a parent directory of a file we'll restore
    if [[ -d "$item" ]] && find "$item" -mindepth 1 -maxdepth 1 | grep -q .; then
        continue
    fi
    
    restore_item "$item" "$target_path"
done

echo
echo "Restore completed! Check log file for details: $RESTORE_LOG"
echo "Original files were renamed with .before_restore extension"
EOF
    
    chmod +x "$BACKUP_DIR/restore.sh"
    
    echo
    echo "Backup completed successfully!"
    echo "Location: $BACKUP_DIR"
    echo "To restore: $BACKUP_DIR/restore.sh"
}

cleanup_old_backups() {
    local keep_count=5
    
    if [[ "$AUTO_MODE" == "true" ]]; then
        keep_count=3
    fi
    
    echo "Cleaning up old backups (keeping last $keep_count)..."
    
    if [[ -d "$BACKUP_BASE_DIR" ]]; then
        # List all backups sorted by date
        local backups=($(ls -1d "$BACKUP_BASE_DIR"/backup_* 2>/dev/null | sort -r))
        local count=${#backups[@]}
        
        if [[ $count -gt $keep_count ]]; then
            # Remove old backups
            for ((i=$keep_count; i<$count; i++)); do
                echo "Removing old backup: ${backups[$i]}"
                rm -rf "${backups[$i]}"
            done
        fi
    fi
}

main() {
    if [[ "$AUTO_MODE" == "false" ]]; then
        echo -e "\033[1;34mUltimate Linux Development Setup - Backup\033[0m"
        echo -e "\033[1;34m========================================\033[0m"
        echo
    fi
    
    create_backup
    cleanup_old_backups
    
    if [[ "$AUTO_MODE" == "false" ]]; then
        # Offer to create a compressed archive
        read -p "Create compressed archive? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Creating compressed archive..."
            tar -czf "${BACKUP_DIR}.tar.gz" -C "$BACKUP_BASE_DIR" "$(basename "$BACKUP_DIR")"
            echo "Archive created: ${BACKUP_DIR}.tar.gz"
        fi
    fi
}

main