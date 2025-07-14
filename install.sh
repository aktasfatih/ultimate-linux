#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/install.log"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
INSTALL_MODE="full"
FORCE_INSTALL=false
DRY_RUN=false
NON_INTERACTIVE=false
PREFERRED_SHELL="auto"
ACTION="install"
MIGRATE_SHELL=""

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"

    case $level in
        ERROR) echo -e "${RED}[ERROR]${NC} $message" >&2 ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC} $message" ;;
        INFO)  echo -e "${BLUE}[INFO]${NC} $message" ;;
        SUCCESS) echo -e "${GREEN}[SUCCESS]${NC} $message" ;;
    esac
}

print_usage() {
    cat << EOF
${BOLD}Ultimate Linux Development Setup${NC}

Usage: ./install.sh [OPTIONS]

Options:
    --help              Show this help message
    --full              Complete setup (default)
    --minimal           Basic setup (shell + git only)
    --server            Server-optimized (no GUI dependencies)
    --dev-only          Just development tools
    --shell=SHELL       Preferred shell (bash|zsh|auto, default: auto)
    --migrate-shell=SHELL  Migrate to different shell (bash|zsh)
    --validate-shell    Check shell configuration for issues
    --fix-shell         Fix detected shell configuration issues
    --dry-run           Show what would be installed without executing
    --force             Overwrite existing configs without prompting
    --backup-dir=PATH   Specify custom backup location
    --non-interactive   Run without user prompts

Examples:
    ./install.sh                    # Full interactive installation
    ./install.sh --minimal --force  # Minimal setup, overwrite existing
    ./install.sh --dry-run          # Preview installation
    ./install.sh --migrate-shell=zsh  # Migrate to Zsh
    ./install.sh --validate-shell   # Check shell configuration
    ./install.sh --fix-shell        # Fix shell issues

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                print_usage
                exit 0
                ;;
            --full)
                INSTALL_MODE="full"
                ;;
            --minimal)
                INSTALL_MODE="minimal"
                ;;
            --server)
                INSTALL_MODE="server"
                ;;
            --dev-only)
                INSTALL_MODE="dev-only"
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --force)
                FORCE_INSTALL=true
                ;;
            --backup-dir=*)
                BACKUP_DIR="${1#*=}"
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                ;;
            --shell=*)
                PREFERRED_SHELL="${1#*=}"
                case $PREFERRED_SHELL in
                    bash|zsh|auto) ;;
                    *)
                        log ERROR "Invalid shell option: $PREFERRED_SHELL"
                        echo "Valid options: bash, zsh, auto"
                        exit 1
                        ;;
                esac
                ;;
            --migrate-shell=*)
                ACTION="migrate"
                MIGRATE_SHELL="${1#*=}"
                case $MIGRATE_SHELL in
                    bash|zsh) ;;
                    *)
                        log ERROR "Invalid shell option: $MIGRATE_SHELL"
                        echo "Valid options: bash, zsh"
                        exit 1
                        ;;
                esac
                ;;
            --validate-shell)
                ACTION="validate"
                ;;
            --fix-shell)
                ACTION="fix"
                ;;
            *)
                log ERROR "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
        shift
    done
}

check_prerequisites() {
    log INFO "Checking prerequisites..."

    # Skip sudo check for dry run
    if [[ "$DRY_RUN" == "false" ]]; then
        # Check for sudo access
        if ! sudo -n true 2>/dev/null; then
            if [[ "$NON_INTERACTIVE" == "true" ]]; then
                log ERROR "Sudo access required. Please run with sudo or authenticate first."
                exit 1
            fi
            log INFO "Sudo access required. Please enter your password."
            sudo true
        fi
    fi

    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null && ! ping -c 1 8.8.8.8 &> /dev/null; then
        log ERROR "No internet connection detected. Please check your connection."
        exit 1
    fi

    # Check disk space (need at least 1GB)
    available_space=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $available_space -lt 1 ]]; then
        log WARN "Less than 1GB of free space available. Installation may fail."
        if [[ "$NON_INTERACTIVE" == "false" ]] && [[ "$FORCE_INSTALL" == "false" ]]; then
            read -p "Continue anyway? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi

    log SUCCESS "Prerequisites check passed"
}

source_utils() {
    source "${DOTFILES_DIR}/scripts/utils.sh"
    source "${DOTFILES_DIR}/scripts/distro-detect.sh"
    source "${DOTFILES_DIR}/scripts/package-managers.sh"
}

# Shell detection and validation functions
detect_current_shell() {
    local current_shell=""
    if [[ -n "${BASH_VERSION:-}" ]]; then
        current_shell="bash"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        current_shell="zsh"
    else
        current_shell=$(ps -p $$ -o comm= | sed 's/^-//')
    fi
    echo "$current_shell"
}

detect_default_shell() {
    local default_shell=$(getent passwd "$USER" | cut -d: -f7)
    echo "$(basename "$default_shell")"
}

check_shell_config_errors() {
    local shell_type=$1
    local config_file=$2
    local errors=()

    if [[ ! -f "$config_file" ]]; then
        return 0
    fi

    case "$shell_type" in
        bash)
            # Check for Zsh-specific commands in Bash configs
            local zsh_commands=("setopt" "zstyle" "compdef" "autoload" "zmodload" "bindkey -v" "precmd_functions" "chpwd_functions")
            for cmd in "${zsh_commands[@]}"; do
                if grep -q "^[[:space:]]*$cmd\|[[:space:]]$cmd[[:space:]]" "$config_file" 2>/dev/null; then
                    errors+=("Found Zsh command '$cmd' in $config_file")
                fi
            done
            ;;
        zsh)
            # Check for Bash-specific syntax in Zsh configs
            local bash_only=("shopt" "complete -" "bind " "PROMPT_COMMAND")
            for cmd in "${bash_only[@]}"; do
                if grep -q "^[[:space:]]*$cmd\|[[:space:]]$cmd[[:space:]]" "$config_file" 2>/dev/null; then
                    errors+=("Found Bash command '$cmd' in $config_file")
                fi
            done
            ;;
    esac

    # Check for sourcing wrong shell configs
    if [[ "$shell_type" == "bash" ]]; then
        if grep -q "source.*\.zshrc\|\..*\.zshrc" "$config_file" 2>/dev/null; then
            errors+=("Bash config sources Zsh configuration")
        fi
    elif [[ "$shell_type" == "zsh" ]]; then
        if grep -q "source.*\.bashrc\|\..*\.bashrc" "$config_file" 2>/dev/null; then
            errors+=("Zsh config sources Bash configuration")
        fi
    fi

    printf '%s\n' "${errors[@]}"
}

validate_shell_environment() {
    log INFO "Validating shell environment..."

    local current_shell=$(detect_current_shell)
    local default_shell=$(detect_default_shell)
    local issues_found=false

    # Check for mismatches
    if [[ "$current_shell" != "$default_shell" ]]; then
        log WARN "Current shell ($current_shell) differs from default shell ($default_shell)"
        issues_found=true
    fi

    # Check shell configurations
    if [[ -f "$HOME/.bashrc" ]]; then
        local bash_errors=($(check_shell_config_errors "bash" "$HOME/.bashrc"))
        if [[ ${#bash_errors[@]} -gt 0 ]]; then
            log ERROR "Issues in ~/.bashrc:"
            printf '  - %s\n' "${bash_errors[@]}"
            issues_found=true
        fi
    fi

    if [[ -f "$HOME/.zshrc" ]]; then
        local zsh_errors=($(check_shell_config_errors "zsh" "$HOME/.zshrc"))
        if [[ ${#zsh_errors[@]} -gt 0 ]]; then
            log ERROR "Issues in ~/.zshrc:"
            printf '  - %s\n' "${zsh_errors[@]}"
            issues_found=true
        fi
    fi

    # Test shell initialization
    if command -v bash &>/dev/null; then
        local bash_test=$(bash -l -c 'echo "test"' 2>&1)
        if [[ "$bash_test" == *"command not found"* ]] || [[ "$bash_test" == *"setopt"* ]]; then
            log ERROR "Bash initialization has errors"
            issues_found=true
        fi
    fi

    if command -v zsh &>/dev/null; then
        local zsh_test=$(zsh -l -c 'echo "test"' 2>&1)
        if [[ "$zsh_test" == *"command not found"* ]] || [[ "$zsh_test" == *"shopt"* ]]; then
            log ERROR "Zsh initialization has errors"
            issues_found=true
        fi
    fi

    return $([ "$issues_found" = true ] && echo 1 || echo 0)
}

fix_shell_config() {
    local config_file=$1
    local shell_type=$2
    local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"

    log INFO "Fixing $config_file for $shell_type..."

    # Create backup
    cp "$config_file" "$backup_file"
    log INFO "Backup created: $backup_file"

    # Add shell guard at the beginning
    local temp_file=$(mktemp)

    case "$shell_type" in
        bash)
            cat > "$temp_file" << 'EOF'
# Shell guard - ensure this is only executed in Bash
if [ -z "${BASH_VERSION:-}" ]; then
    return 0 2>/dev/null || exit 0
fi

EOF
            ;;
        zsh)
            cat > "$temp_file" << 'EOF'
# Shell guard - ensure this is only executed in Zsh
if [ -z "${ZSH_VERSION:-}" ]; then
    return 0 2>/dev/null || exit 0
fi

EOF
            ;;
    esac

    # Append original content
    cat "$config_file" >> "$temp_file"

    # Move back
    mv "$temp_file" "$config_file"

    log SUCCESS "Added shell guard to $config_file"
}

clean_mixed_configs() {
    log INFO "Cleaning mixed shell configurations..."

    local cleaned=false

    # Remove Zsh commands from Bash configs
    if [[ -f "$HOME/.bashrc" ]]; then
        local temp_file=$(mktemp)
        grep -v -E "^[[:space:]]*(setopt|zstyle|compdef|autoload|zmodload|precmd_functions|chpwd_functions)" "$HOME/.bashrc" > "$temp_file" || true
        if ! diff -q "$HOME/.bashrc" "$temp_file" >/dev/null; then
            cp "$HOME/.bashrc" "$HOME/.bashrc.mixed-backup.$(date +%Y%m%d_%H%M%S)"
            mv "$temp_file" "$HOME/.bashrc"
            log SUCCESS "Cleaned Zsh commands from ~/.bashrc"
            cleaned=true
        else
            rm "$temp_file"
        fi
    fi

    # Remove Bash commands from Zsh configs
    if [[ -f "$HOME/.zshrc" ]]; then
        local temp_file=$(mktemp)
        grep -v -E "^[[:space:]]*(shopt|complete -|bind |PROMPT_COMMAND)" "$HOME/.zshrc" > "$temp_file" || true
        if ! diff -q "$HOME/.zshrc" "$temp_file" >/dev/null; then
            cp "$HOME/.zshrc" "$HOME/.zshrc.mixed-backup.$(date +%Y%m%d_%H%M%S)"
            mv "$temp_file" "$HOME/.zshrc"
            log SUCCESS "Cleaned Bash commands from ~/.zshrc"
            cleaned=true
        else
            rm "$temp_file"
        fi
    fi

    [[ "$cleaned" = true ]] && log SUCCESS "Shell configurations cleaned" || log INFO "No mixed configurations found"
}

migrate_to_shell() {
    local target_shell=$1

    log INFO "Migrating to $target_shell..."

    # Create backup
    local backup_dir="$HOME/.shell_migration_backup_$(date +%Y%m%d_%H%M%S)"
    log INFO "Creating backup at $backup_dir..."

    mkdir -p "$backup_dir"

    # Backup shell configs
    for file in .bashrc .bash_profile .zshrc .zshenv .zprofile; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$backup_dir/"
            log INFO "Backed up $file"
        fi
    done

    # Backup shell-related configs
    [[ -d "$HOME/.config/shell" ]] && cp -r "$HOME/.config/shell" "$backup_dir/"
    [[ -f "$HOME/.config/starship.toml" ]] && cp "$HOME/.config/starship.toml" "$backup_dir/"

    # Install target shell if needed
    if ! command -v "$target_shell" &>/dev/null; then
        log INFO "Installing $target_shell..."
        install_packages "$target_shell"
    fi

    # Deploy appropriate configuration
    case $target_shell in
        bash)
            # Deploy Bash config
            deploy_config "$DOTFILES_DIR/config/bash/.bashrc" "$HOME/.bashrc"

            # Ensure starship is configured for bash
            if command -v starship &>/dev/null; then
                if ! grep -q "starship init bash" "$HOME/.bashrc"; then
                    echo "" >> "$HOME/.bashrc"
                    echo "# Starship prompt" >> "$HOME/.bashrc"
                    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
                fi
            fi
            ;;

        zsh)
            # Install Oh My Zsh if not present
            if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
                log INFO "Installing Oh My Zsh..."
                RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            fi

            # Deploy Zsh configs
            deploy_config "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
            deploy_config "$DOTFILES_DIR/config/zsh/.zshenv" "$HOME/.zshenv"

            # Install Zsh plugins
            local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

            if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
            fi

            if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
            fi
            ;;
    esac

    # Deploy universal configs
    mkdir -p "$HOME/.config/shell"
    deploy_config "$DOTFILES_DIR/config/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"

    # Update tmux default shell
    local shell_path=$(which "$target_shell")
    if [[ -f "$HOME/.tmux.conf" ]]; then
        if grep -q "set-option -g default-shell" "$HOME/.tmux.conf"; then
            sed -i "s|set-option -g default-shell.*|set-option -g default-shell $shell_path|" "$HOME/.tmux.conf"
        else
            echo "set-option -g default-shell $shell_path" >> "$HOME/.tmux.conf"
        fi
        log SUCCESS "Updated tmux configuration"
    fi

    # Test new shell
    local test_output=$("$target_shell" -l -c 'echo "Shell test successful"' 2>&1)
    if [[ "$test_output" == *"Shell test successful"* ]] && [[ "$test_output" != *"command not found"* ]]; then
        log SUCCESS "$target_shell starts without errors"
    else
        log WARN "$target_shell may have startup errors"
    fi

    # Change default shell
    local current_shell=$(basename "$SHELL")
    if [[ "$current_shell" != "$target_shell" ]]; then
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            read -p "$(echo -e "${BLUE}Change default login shell to $target_shell? [Y/n]${NC} ")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                # Ensure shell is in /etc/shells
                if ! grep -q "^$shell_path$" /etc/shells; then
                    log WARN "$shell_path not in /etc/shells, adding it..."
                    echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
                fi

                chsh -s "$shell_path"
                log SUCCESS "Default shell changed to $target_shell"
                log INFO "You'll need to log out and back in for this to take effect"
            fi
        fi
    fi

    log SUCCESS "Migration to $target_shell completed!"
    echo
    echo -e "${BLUE}What's next:${NC}"
    echo "  1. Restart your terminal or run: source ~/.$( [[ "$target_shell" == "bash" ]] && echo "bashrc" || echo "zshrc" )"
    echo "  2. If using tmux, restart tmux for changes to take effect"
    echo "  3. Your backup is at: $backup_dir"
}

create_backup() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would create backup at $BACKUP_DIR"
        return
    fi

    log INFO "Creating backup of existing configurations..."
    mkdir -p "$BACKUP_DIR"

    # List of files/dirs to backup
    local items_to_backup=(
        ".zshrc" ".zshenv" ".bashrc" ".bash_profile"
        ".tmux.conf" ".config/nvim" ".vimrc"
        ".gitconfig" ".gitignore_global"
    )

    for item in "${items_to_backup[@]}"; do
        if [[ -e "$HOME/$item" ]]; then
            log INFO "Backing up $item"
            cp -r "$HOME/$item" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done

    log SUCCESS "Backup created at $BACKUP_DIR"
}

install_base_packages() {
    log INFO "Installing base packages for $INSTALL_MODE mode..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install base packages"
        return
    fi

    # Common packages for all modes
    local common_packages=(
        "git" "curl" "wget" "build-essential" "cmake"
        "unzip" "tar" "gzip" "ca-certificates" "gnupg"
        "xclip" "xsel"
    )

    # Mode-specific packages
    case $INSTALL_MODE in
        minimal)
            install_packages "${common_packages[@]}" "zsh"
            ;;
        server)
            install_packages "${common_packages[@]}" "zsh" "tmux" "vim" "htop"
            ;;
        dev-only)
            install_packages "${common_packages[@]}" "python3" "python3-pip" "python3-full" "python3-venv" "pipx" "nodejs" "npm"
            ;;
        full|*)
            install_packages "${common_packages[@]}" "zsh" "tmux" "python3" "python3-pip" "python3-full" "python3-venv" "pipx" "nodejs" "npm" "fontconfig"
            ;;
    esac
}

install_shell_environment() {
    if [[ "$INSTALL_MODE" == "dev-only" ]]; then
        return
    fi

    log INFO "Installing shell environment..."

    # Determine which shell to use
    local target_shell="$PREFERRED_SHELL"
    if [[ "$target_shell" == "auto" ]]; then
        # Check current shell
        if [[ -n "${BASH_VERSION:-}" ]]; then
            target_shell="bash"
        elif [[ -n "${ZSH_VERSION:-}" ]]; then
            target_shell="zsh"
        else
            # Default to user's login shell
            target_shell=$(basename "$SHELL")
        fi
        log INFO "Auto-detected shell: $target_shell"
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would configure $target_shell shell environment"
        return
    fi

    # Install chosen shell if not present
    if [[ "$target_shell" == "zsh" ]] && ! command -v zsh &> /dev/null; then
        install_packages "zsh"
    elif [[ "$target_shell" == "bash" ]] && ! command -v bash &> /dev/null; then
        install_packages "bash"
    fi

    # Install shell-specific components
    if [[ "$target_shell" == "zsh" ]]; then
        # Install Oh My Zsh
        if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
            log INFO "Installing Oh My Zsh..."
            RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
                log ERROR "Failed to install Oh My Zsh"
                return 1
            }
        fi

        # Install Zsh plugins
        local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

        # zsh-autosuggestions
        if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || {
                log WARN "Failed to install zsh-autosuggestions plugin"
            }
        fi

        # zsh-syntax-highlighting
        if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || {
                log WARN "Failed to install zsh-syntax-highlighting plugin"
            }
        fi
    fi

    # Install Starship prompt
    if ! command -v starship &> /dev/null; then
        log INFO "Installing Starship prompt..."
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y || {
            log WARN "Failed to install Starship prompt"
        }
    fi

    # Install modern CLI tools
    install_modern_cli_tools

    # Install additional productivity tools (if not minimal mode)
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        log INFO "Installing additional productivity tools..."
        source "$DOTFILES_DIR/scripts/install-productivity-tools.sh" || true
    fi

    # Deploy shell-specific configuration
    if [[ "$target_shell" == "zsh" ]]; then
        deploy_config "config/zsh/.zshrc" "$HOME/.zshrc"
        deploy_config "config/zsh/.zshenv" "$HOME/.zshenv"
        # Deploy Zsh-specific configurations
        mkdir -p "$HOME/.config/zsh"
        deploy_config "config/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
        deploy_config "config/zsh/functions.zsh" "$HOME/.config/zsh/functions.zsh"
        deploy_config "config/zsh/completions.zsh" "$HOME/.config/zsh/completions.zsh"
        deploy_config "config/zsh/key-bindings.zsh" "$HOME/.config/zsh/key-bindings.zsh"

        # Create cache directories
        mkdir -p "$HOME/.cache/zsh/completion"
        
        # Create .zshrc.local with fixes for common issues
        if [[ ! -f "$HOME/.zshrc.local" ]]; then
            cat > "$HOME/.zshrc.local" << 'EOF'
# Local Zsh customizations

# Fix: Unalias cd to restore normal behavior (some Oh My Zsh plugins alias cd to z)
unalias cd 2>/dev/null || true

# If you find z's tab completion interfering with normal file completion, uncomment:
# ZSHZ_COMPLETION=none
EOF
            log INFO "Created .zshrc.local with common fixes"
        fi
    else
        # Deploy Bash configuration
        deploy_config "config/bash/.bashrc" "$HOME/.bashrc"
    fi

    # Deploy universal shell configuration
    mkdir -p "$HOME/.config/shell"
    deploy_config "config/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"

    log SUCCESS "Shell environment installed for $target_shell"
}

install_modern_cli_tools() {
    log INFO "Installing modern CLI tools..."

    local tools=(
        "eza:exa replacement"
        "bat:cat replacement"
        "ripgrep:grep replacement"
        "fd-find:find replacement"
        "fzf:fuzzy finder"
        "zoxide:cd replacement"
        "delta:git diff tool"
        "dust:du replacement"
        "procs:ps replacement"
        "bottom:system monitor"
    )

    for tool_info in "${tools[@]}"; do
        local tool="${tool_info%%:*}"
        local desc="${tool_info#*:}"

        if [[ "$DRY_RUN" == "true" ]]; then
            log INFO "[DRY RUN] Would install $tool ($desc)"
            continue
        fi

        case $tool in
            eza)
                if ! command -v eza &> /dev/null; then
                    # Try package manager first for eza
                    if [[ "$DISTRO_FAMILY" == "debian" ]] && [[ "$DISTRO" == "ubuntu" ]]; then
                        # eza is in Ubuntu 22.10+
                        install_packages "eza" || {
                            log INFO "eza not in repos, trying exa as fallback"
                            install_packages "exa" || log WARN "Could not install eza/exa"
                        }
                    else
                        install_via_cargo "eza" || log WARN "Could not install eza"
                    fi
                fi
                ;;
            bat)
                install_packages "bat" || install_from_github "sharkdp/bat"
                ;;
            ripgrep)
                install_packages "ripgrep" || install_from_github "BurntSushi/ripgrep"
                ;;
            fd-find)
                install_packages "fd-find" || install_from_github "sharkdp/fd"
                ;;
            fzf)
                if ! command -v fzf &> /dev/null; then
                    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || {
                        log WARN "Failed to clone fzf repository"
                        continue
                    }
                    ~/.fzf/install --all --no-bash --no-fish || {
                        log WARN "Failed to install fzf"
                    }
                fi
                ;;
            zoxide)
                if ! command -v zoxide &> /dev/null; then
                    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                fi
                ;;
            delta)
                install_from_github "dandavison/delta"
                ;;
            dust)
                install_via_cargo "du-dust" || install_from_github "bootandy/dust"
                ;;
            procs)
                install_via_cargo "procs" || install_from_github "dalance/procs"
                ;;
            bottom)
                install_packages "bottom" || install_via_cargo "bottom"
                ;;
        esac
    done
}

install_tmux() {
    if [[ "$INSTALL_MODE" == "minimal" ]] || [[ "$INSTALL_MODE" == "dev-only" ]]; then
        return
    fi

    log INFO "Installing tmux..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install tmux and TPM"
        return
    fi

    # Install tmux
    install_packages "tmux"

    # Install TPM (Tmux Plugin Manager)
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    # Deploy tmux configuration
    deploy_config "config/tmux/.tmux.conf" "$HOME/.tmux.conf"
    deploy_config "config/tmux/.tmux.clipboard.conf" "$HOME/.tmux.clipboard.conf"

    # Deploy tmux scripts and resources
    mkdir -p "$HOME/.config/tmux/scripts"
    if [[ -d "config/tmux/scripts" ]]; then
        for script in config/tmux/scripts/*; do
            if [[ -f "$script" ]]; then
                deploy_config "$script" "$HOME/.config/tmux/scripts/$(basename "$script")"
                chmod +x "$HOME/.config/tmux/scripts/$(basename "$script")"
            fi
        done
    fi

    # Deploy tmux cheatsheet
    if [[ -f "config/tmux/tmux-cheatsheet.md" ]]; then
        deploy_config "config/tmux/tmux-cheatsheet.md" "$HOME/.config/tmux/tmux-cheatsheet.md"
    fi

    # Note about tmux plugins
    log INFO "tmux plugins will be installed on first tmux launch"
    log INFO "Press Ctrl+Space, then I (capital i) inside tmux to install plugins"

    log SUCCESS "tmux installed and configured"
}

install_neovim() {
    if [[ "$INSTALL_MODE" == "minimal" ]] || [[ "$INSTALL_MODE" == "dev-only" ]]; then
        return
    fi

    log INFO "Installing Neovim..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install Neovim"
        return
    fi

    # Install Neovim - always use AppImage for latest version (0.10+)
    local current_version=$(nvim --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0.0")
    
    # Check if we need to update (require at least 0.10)
    if ! command -v nvim &> /dev/null || [[ "$(echo -e "$current_version\n0.10" | sort -V | head -1)" != "0.10" ]]; then
        log INFO "Installing latest Neovim (0.10+) via AppImage for all features..."
        install_neovim_appimage
    else
        log SUCCESS "Neovim $current_version is already installed and up to date"
    fi

    # Deploy Neovim configuration
    mkdir -p "$HOME/.config"
    deploy_config "config/nvim" "$HOME/.config/nvim"

    # Check final installed version for compatibility info
    local installed_version=$(nvim --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0.0")
    if [[ "$installed_version" =~ ^0\.9 ]]; then
        log WARN "Neovim 0.9.x detected. Some advanced UI features will be disabled for compatibility."
        log INFO "Core IDE features work perfectly. See docs/neovim-compatibility.md for details."
        log INFO "To enable all features, run './scripts/update-neovim.sh' to upgrade to 0.10+"
    elif [[ "$installed_version" =~ ^0\.1[0-9] ]]; then
        log SUCCESS "Neovim $installed_version installed - all features enabled!"
    fi

    # Install language servers and tools
    install_language_servers

    log SUCCESS "Neovim installed and configured"
}

install_neovim_appimage() {
    log INFO "Installing Neovim via AppImage..."

    # Detect architecture
    local arch=$(uname -m)
    local appimage_name
    if [[ "$arch" == "x86_64" ]]; then
        appimage_name="nvim-linux-x86_64.appimage"
    elif [[ "$arch" == "aarch64" ]]; then
        appimage_name="nvim-linux-arm64.appimage"
    else
        log ERROR "Unsupported architecture: $arch"
        return 1
    fi

    # Get latest version from GitHub
    local latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    local download_url="https://github.com/neovim/neovim/releases/download/${latest_version}/${appimage_name}"

    log INFO "Downloading Neovim ${latest_version} for $arch..."

    curl -LO "$download_url" || {
        log ERROR "Failed to download Neovim"
        return 1
    }
    
    chmod u+x "$appimage_name"
    sudo mv "$appimage_name" /usr/local/bin/nvim

    # Extract AppImage for systems without FUSE
    if ! /usr/local/bin/nvim --version &> /dev/null; then
        cd /usr/local/bin
        sudo ./nvim --appimage-extract
        sudo rm -f ./nvim
        sudo mv squashfs-root nvim-squashfs
        sudo ln -sf /usr/local/bin/nvim-squashfs/AppRun /usr/local/bin/nvim
        cd - > /dev/null
    fi
}

install_language_servers() {
    log INFO "Installing language servers..."

    # Python
    # Use pipx for Python tools to avoid externally managed environment issues
    if command -v pipx &> /dev/null; then
        pipx install pyright || true
        pipx install black || true
        pipx install flake8 || true
    else
        # Fallback to pip with --break-system-packages for older systems
        pip3 install --user --break-system-packages pyright black flake8 2>/dev/null || \
        pip3 install --user pyright black flake8 || true
    fi

    # JavaScript/TypeScript
    sudo npm install -g typescript typescript-language-server prettier eslint || true

    # Rust
    if command -v rustup &> /dev/null; then
        rustup component add rust-analyzer || true
    fi

    # Go
    if command -v go &> /dev/null; then
        go install golang.org/x/tools/gopls@latest || true
    fi

    # Bash
    sudo npm install -g bash-language-server || true

    # Lua
    if [[ ! -f "$HOME/.local/bin/lua-language-server" ]]; then
        install_lua_language_server
    fi
}

install_lua_language_server() {
    log INFO "Installing Lua Language Server..."

    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)

    case "$arch" in
        x86_64) arch="x64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)
            log WARN "Unsupported architecture for Lua Language Server: $arch"
            return 1
            ;;
    esac

    # Get the latest version
    local latest_version=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

    if [[ -z "$latest_version" ]]; then
        log WARN "Could not determine latest Lua Language Server version"
        return 1
    fi

    local download_url="https://github.com/LuaLS/lua-language-server/releases/download/${latest_version}/lua-language-server-${latest_version}-${platform}-${arch}.tar.gz"

    # Create temporary directory for download
    local temp_dir=$(mktemp -d)
    local archive_file="$temp_dir/lua-language-server.tar.gz"

    # Download with error checking
    if ! curl -fsSL "$download_url" -o "$archive_file"; then
        log WARN "Failed to download Lua Language Server from $download_url"
        rm -rf "$temp_dir"
        return 1
    fi

    # Check if it's actually a tar.gz file
    if ! file "$archive_file" | grep -q "gzip compressed data"; then
        log WARN "Downloaded file is not a valid tar.gz archive"
        rm -rf "$temp_dir"
        return 1
    fi

    # Extract
    mkdir -p "$HOME/.local/bin/lua-language-server"
    if ! tar -xzf "$archive_file" -C "$HOME/.local/bin/lua-language-server"; then
        log WARN "Failed to extract Lua Language Server"
        rm -rf "$temp_dir"
        return 1
    fi

    # Create symlink
    if [[ -f "$HOME/.local/bin/lua-language-server/bin/lua-language-server" ]]; then
        ln -sf "$HOME/.local/bin/lua-language-server/bin/lua-language-server" "$HOME/.local/bin/lua-language-server"
        log SUCCESS "Lua Language Server installed"
    else
        log WARN "Lua Language Server binary not found after extraction"
    fi

    rm -rf "$temp_dir"
}

configure_git_user() {
    # Check if Git user name is set
    if [[ -z "$(git config --global user.name)" ]]; then
        echo
        echo -e "${BLUE}Git user configuration${NC}"
        echo "Please enter your Git user information:"
        read -p "Your name: " git_name
        if [[ -n "$git_name" ]]; then
            git config --global user.name "$git_name"
            log SUCCESS "Git user name set to: $git_name"
        fi
    else
        log INFO "Git user name already configured: $(git config --global user.name)"
    fi

    # Check if Git user email is set
    if [[ -z "$(git config --global user.email)" ]]; then
        read -p "Your email: " git_email
        if [[ -n "$git_email" ]]; then
            git config --global user.email "$git_email"
            log SUCCESS "Git user email set to: $git_email"
        fi
    else
        log INFO "Git user email already configured: $(git config --global user.email)"
    fi

    # Ask about GPG signing (only in interactive mode)
    if [[ "$NON_INTERACTIVE" == "false" ]]; then
        read -p "Do you want to configure GPG signing for commits? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Your GPG key ID (or press Enter to skip): " gpg_key
            if [[ -n "$gpg_key" ]]; then
                git config --global user.signingkey "$gpg_key"
                git config --global commit.gpgsign true
                log SUCCESS "GPG signing configured"
            fi
        fi
    else
        log INFO "Skipping GPG configuration in non-interactive mode"
    fi
}

install_development_tools() {
    log INFO "Installing development tools..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install development tools"
        return
    fi

    # Git configuration
    deploy_config "config/git/.gitconfig" "$HOME/.gitconfig"
    deploy_config "config/git/.gitignore_global" "$HOME/.gitignore_global"

    # Configure Git user details if not set
    if [[ "$NON_INTERACTIVE" == "false" ]]; then
        configure_git_user
    fi

    # Install lazygit
    if ! command -v lazygit &> /dev/null; then
        install_from_github "jesseduffield/lazygit"
    fi

    # Install language version managers
    # fnm (Fast Node Manager)
    if ! command -v fnm &> /dev/null; then
        curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    fi

    # pyenv - with conflict detection and handling
    if ! command -v pyenv &> /dev/null; then
        if [[ -d "$HOME/.pyenv" ]]; then
            log WARN "Existing pyenv installation found at $HOME/.pyenv"
            if [[ "$NON_INTERACTIVE" == "true" ]] || [[ "$FORCE_INSTALL" == "true" ]]; then
                log INFO "Removing existing pyenv installation (non-interactive/force mode)..."
                rm -rf "$HOME/.pyenv"
            else
                read -p "Remove existing pyenv installation and reinstall? [y/N] " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    log INFO "Removing existing pyenv installation..."
                    rm -rf "$HOME/.pyenv"
                else
                    log INFO "Skipping pyenv installation"
                    return 0
                fi
            fi
        fi

        log INFO "Installing pyenv..."
        if curl -fsSL https://pyenv.run | bash; then
            log SUCCESS "pyenv installed successfully"
        else
            log WARN "Failed to install pyenv"
        fi
    fi

    # rustup
    if ! command -v rustup &> /dev/null && [[ "$INSTALL_MODE" == "full" ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    fi

    log SUCCESS "Development tools installed"
}

deploy_config() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would deploy $source to $target"
        return
    fi

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        log WARN "Source file/directory not found: $source"
        return 1
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Check if target exists and handle accordingly
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ "$FORCE_INSTALL" == "true" ]]; then
            rm -rf "$target"
        else
            if [[ "$NON_INTERACTIVE" == "true" ]]; then
                log WARN "Target exists, skipping: $target"
                return 0
            else
                read -p "$(echo -e "${YELLOW}$target exists. Overwrite? [y/N]${NC} ")" -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    rm -rf "$target"
                else
                    return 0
                fi
            fi
        fi
    fi

    # Copy the configuration files
    if [[ -d "$source" ]]; then
        # For directories, copy contents
        cp -r "$source"/* "$target/" 2>/dev/null || cp -r "$source"/. "$target/"
    else
        # For files, copy directly
        cp "$source" "$target"
    fi

    log INFO "Deployed $source to $target"
}

install_fonts() {
    if [[ "$INSTALL_MODE" == "minimal" ]] || [[ "$INSTALL_MODE" == "server" ]] || [[ "$INSTALL_MODE" == "dev-only" ]]; then
        return
    fi

    log INFO "Installing fonts..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install Nerd Fonts"
        return
    fi

    # Create fonts directory
    mkdir -p "$HOME/.local/share/fonts"

    # Install popular Nerd Fonts
    local fonts=("FiraCode" "JetBrainsMono" "Hack" "SourceCodePro")

    for font in "${fonts[@]}"; do
        log INFO "Installing $font Nerd Font..."

        # Download and install font
        local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
        local temp_dir=$(mktemp -d)

        if curl -L "$font_url" -o "$temp_dir/${font}.zip"; then
            unzip -q "$temp_dir/${font}.zip" -d "$temp_dir"
            cp "$temp_dir"/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true
            rm -rf "$temp_dir"
        else
            log WARN "Failed to download $font Nerd Font"
        fi
    done

    # Update font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -f "$HOME/.local/share/fonts"
    fi

    log SUCCESS "Fonts installed"
}

run_verification() {
    log INFO "Running verification..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would run verification script"
        return
    fi

    if [[ -f "$DOTFILES_DIR/verify.sh" ]]; then
        bash "$DOTFILES_DIR/verify.sh"
    else
        log WARN "Verification script not found"
    fi
}

finalize_installation() {
    log INFO "Finalizing installation..."

    # Clean up package manager
    if [[ "$DISTRO_FAMILY" == "debian" ]] || [[ "$DISTRO_FAMILY" == "ubuntu" ]]; then
        log INFO "Cleaning up package manager..."
        sudo apt autoremove -y 2>/dev/null || true
    fi

    # Validate shell configuration
    if ! validate_shell_environment; then
        log WARN "Shell configuration issues detected"
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            read -p "$(echo -e "${YELLOW}Would you like to fix shell configuration issues? [Y/n]${NC} ")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                # Clean mixed configs first
                clean_mixed_configs

                # Add shell guards
                [[ -f "$HOME/.bashrc" ]] && fix_shell_config "$HOME/.bashrc" "bash"
                [[ -f "$HOME/.zshrc" ]] && fix_shell_config "$HOME/.zshrc" "zsh"

                log SUCCESS "Shell configuration fixes applied"
            fi
        fi
    fi

    # Ask about changing default shell
    local target_shell="${PREFERRED_SHELL}"
    if [[ "$target_shell" == "auto" ]]; then
        # Default to zsh if it's installed, otherwise keep current shell
        if command -v zsh >/dev/null 2>&1; then
            target_shell="zsh"
        else
            target_shell=$(basename "$SHELL")
        fi
    fi

    if [[ "$target_shell" == "zsh" ]] && [[ "$SHELL" != "$(which zsh)" ]] && [[ "$INSTALL_MODE" != "dev-only" ]]; then
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            read -p "$(echo -e "${BLUE}Change default shell to Zsh? [Y/n]${NC} ")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                if command -v chsh >/dev/null 2>&1; then
                    if chsh -s "$(which zsh)"; then
                        log SUCCESS "Default shell changed to Zsh"
                        log INFO "Please log out and back in for the change to take effect"
                    else
                        log WARN "Failed to change shell. You may need to run: sudo chsh -s $(which zsh) $USER"
                    fi
                else
                    log WARN "chsh command not found. To change your default shell manually, run: sudo usermod -s $(which zsh) $USER"
                fi
            fi
        fi
    elif [[ "$target_shell" == "bash" ]] && [[ "$SHELL" != "$(which bash)" ]] && [[ "$INSTALL_MODE" != "dev-only" ]]; then
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            read -p "$(echo -e "${BLUE}Change default shell to Bash? [Y/n]${NC} ")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                if command -v chsh >/dev/null 2>&1; then
                    if chsh -s "$(which bash)"; then
                        log SUCCESS "Default shell changed to Bash"
                        log INFO "Please log out and back in for the change to take effect"
                    else
                        log WARN "Failed to change shell. You may need to run: sudo chsh -s $(which bash) $USER"
                    fi
                else
                    log WARN "chsh command not found. To change your default shell manually, run: sudo usermod -s $(which bash) $USER"
                fi
            fi
        fi
    fi

    # Create notes directory
    mkdir -p "$HOME/notes" 2>/dev/null || true

    # Print summary
    echo
    echo -e "${GREEN}${BOLD}Installation completed successfully!${NC}"
    echo
    echo "==================== Installation Summary ===================="
    echo "Mode: $INSTALL_MODE"
    echo "Shell: $(basename "$SHELL")"
    echo ""
    echo -e "${BLUE}✨ NEW FEATURES:${NC}"
    echo ""
    echo -e "${CYAN}📺 TMUX Enhancements:${NC}"
    echo "  • Popup windows: prefix + g (lazygit), prefix + P (btm)"
    echo "  • Project sessionizer: prefix + Ctrl-p"
    echo "  • Scratch terminal: prefix + \`"
    echo "  • URL picker: prefix + u"
    echo "  • Cheatsheet: prefix + ?"
    echo ""
    echo -e "${CYAN}🚀 ZSH Productivity:${NC}"
    echo "  • Enhanced functions: vf (fuzzy file), cf (fuzzy cd)"
    echo "  • Git helpers: gac, gacp, gcof (fuzzy checkout)"
    echo "  • Smart cd with auto-ls"
    echo "  • FZF integration everywhere"
    echo "  • Vi mode with visual feedback"
    echo ""
    echo -e "${BLUE}📝 Next steps:${NC}"
    local shell_rc=".bashrc"
    [[ "$(basename "$SHELL")" == "zsh" ]] && shell_rc=".zshrc"
    echo "  1. Restart your terminal or run: source ~/$shell_rc"
    echo "  2. Start tmux and press Ctrl+Space, then I (capital i) to install plugins"
    echo "  3. Open Neovim and run :Lazy install, then :Mason"
    echo "  4. Check Neovim health: ./scripts/check-neovim.sh"
    echo "  5. Run './scripts/shell-validator.sh' to check shell configuration"
    echo ""
    echo -e "${BLUE}🛠️ Customization:${NC}"
    echo "  • Shell: ~/.${shell_rc}.local"
    echo "  • Tmux: ~/.tmux.conf.local"
    echo "  • Neovim: ~/.config/nvim/lua/user/"
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "  • Features showcase: docs/features-showcase.md"
    echo "  • Neovim compatibility: docs/neovim-compatibility.md"
    echo "  • Installation guide: README.md"
    echo "  • Testing: scripts/test-setup.sh"
    echo "  • Troubleshooting: scripts/troubleshoot.sh"
    echo "============================================================="
    echo -e "${YELLOW}Backup location:${NC} $BACKUP_DIR"
    echo -e "${YELLOW}Installation log:${NC} $LOG_FILE"
    echo

    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}This was a dry run. No changes were made.${NC}"
    fi
}

main() {
    echo -e "${BOLD}${BLUE}Ultimate Linux Development Setup${NC}"
    echo -e "${BLUE}================================${NC}"
    echo

    # Initialize log file
    mkdir -p "$(dirname "$LOG_FILE")"
    : > "$LOG_FILE"

    # Parse command line arguments
    parse_arguments "$@"

    # Source utility scripts
    source_utils

    # Handle different actions
    case "$ACTION" in
        validate)
            log INFO "Running shell validation..."
            if validate_shell_environment; then
                log SUCCESS "No shell configuration issues found"
            else
                log ERROR "Shell configuration issues detected"
                echo
                echo "To fix these issues, run: $0 --fix-shell"
                exit 1
            fi
            ;;

        fix)
            log INFO "Fixing shell configuration issues..."
            if ! validate_shell_environment; then
                # Clean mixed configs first
                clean_mixed_configs

                # Add shell guards
                [[ -f "$HOME/.bashrc" ]] && fix_shell_config "$HOME/.bashrc" "bash"
                [[ -f "$HOME/.zshrc" ]] && fix_shell_config "$HOME/.zshrc" "zsh"

                log SUCCESS "Shell configuration fixes applied"
                echo
                echo "Please restart your terminal or run: source ~/.$(basename $SHELL)rc"
            else
                log SUCCESS "No issues to fix"
            fi
            ;;

        migrate)
            log INFO "Shell migration mode"
            # Detect distribution for package installation
            detect_distro
            migrate_to_shell "$MIGRATE_SHELL"
            ;;

        install)
            # Normal installation flow
            # Check prerequisites
            check_prerequisites

            # Detect distribution
            detect_distro
            log INFO "Detected distribution: $DISTRO ($DISTRO_FAMILY)"

            # Create backup
            create_backup

            # Run installation based on mode
            log INFO "Starting installation in $INSTALL_MODE mode..."

            install_base_packages
            install_shell_environment
            install_tmux
            install_neovim
            install_development_tools
            install_fonts

            # Run verification
            run_verification

            # Finalize
            finalize_installation
            ;;
    esac
}

# Run main function
main "$@"
