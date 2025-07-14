#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/install.log"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
INSTALL_MODE="full"
FORCE_INSTALL=false
DRY_RUN=false
NON_INTERACTIVE=false

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
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
    --dry-run           Show what would be installed without executing
    --force             Overwrite existing configs without prompting
    --backup-dir=PATH   Specify custom backup location
    --non-interactive   Run without user prompts

Examples:
    ./install.sh                    # Full interactive installation
    ./install.sh --minimal --force  # Minimal setup, overwrite existing
    ./install.sh --dry-run          # Preview installation

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
            install_packages "${common_packages[@]}" "python3" "python3-pip" "nodejs" "npm"
            ;;
        full|*)
            install_packages "${common_packages[@]}" "zsh" "tmux" "python3" "python3-pip" "nodejs" "npm" "fontconfig"
            ;;
    esac
}

install_shell_environment() {
    if [[ "$INSTALL_MODE" == "dev-only" ]]; then
        return
    fi
    
    log INFO "Installing shell environment..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would install Zsh and Oh My Zsh"
        return
    fi
    
    # Install Zsh if not present
    if ! command -v zsh &> /dev/null; then
        install_packages "zsh"
    fi
    
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
    
    # Install Starship prompt
    if ! command -v starship &> /dev/null; then
        log INFO "Installing Starship prompt..."
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y || {
            log WARN "Failed to install Starship prompt"
        }
    fi
    
    # Install modern CLI tools
    install_modern_cli_tools
    
    # Deploy Zsh configuration
    deploy_config "config/zsh/.zshrc" "$HOME/.zshrc"
    deploy_config "config/zsh/.zshenv" "$HOME/.zshenv"
    
    log SUCCESS "Shell environment installed"
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
    
    # Install tmux plugins
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
    
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
    
    # Try to install latest stable Neovim
    if ! command -v nvim &> /dev/null || [[ "$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)" < "0.9" ]]; then
        case $DISTRO_FAMILY in
            debian|ubuntu)
                # Try to add Neovim PPA for latest version
                if [[ "$DISTRO" == "ubuntu" ]]; then
                    sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null || true
                    sudo apt-get update
                    sudo apt-get install -y neovim
                else
                    # For Debian, use AppImage
                    install_neovim_appimage
                fi
                ;;
            arch)
                install_packages "neovim"
                ;;
            fedora|rhel)
                install_packages "neovim"
                ;;
            *)
                install_neovim_appimage
                ;;
        esac
    fi
    
    # Deploy Neovim configuration
    mkdir -p "$HOME/.config"
    deploy_config "config/nvim" "$HOME/.config/nvim"
    
    # Install language servers and tools
    install_language_servers
    
    log SUCCESS "Neovim installed and configured"
}

install_neovim_appimage() {
    log INFO "Installing Neovim via AppImage..."
    
    local nvim_version="stable"
    local download_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim.appimage"
    
    curl -LO "$download_url"
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
    
    # Extract AppImage for systems without FUSE
    if ! /usr/local/bin/nvim --version &> /dev/null; then
        cd /usr/local/bin
        sudo ./nvim --appimage-extract
        sudo mv squashfs-root nvim-squashfs
        sudo ln -sf /usr/local/bin/nvim-squashfs/AppRun /usr/local/bin/nvim
        cd - > /dev/null
    fi
}

install_language_servers() {
    log INFO "Installing language servers..."
    
    # Python
    pip3 install --user pyright black flake8 || true
    
    # JavaScript/TypeScript
    npm install -g typescript typescript-language-server prettier eslint || true
    
    # Rust
    if command -v rustup &> /dev/null; then
        rustup component add rust-analyzer || true
    fi
    
    # Go
    if command -v go &> /dev/null; then
        go install golang.org/x/tools/gopls@latest || true
    fi
    
    # Bash
    npm install -g bash-language-server || true
    
    # Lua
    if [[ ! -f "$HOME/.local/bin/lua-language-server" ]]; then
        install_lua_language_server
    fi
}

install_lua_language_server() {
    local platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    
    case "$arch" in
        x86_64) arch="x64" ;;
        aarch64|arm64) arch="arm64" ;;
    esac
    
    local download_url="https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-${platform}-${arch}.tar.gz"
    
    mkdir -p "$HOME/.local/bin/lua-language-server"
    curl -L "$download_url" | tar xz -C "$HOME/.local/bin/lua-language-server"
    ln -sf "$HOME/.local/bin/lua-language-server/bin/lua-language-server" "$HOME/.local/bin/lua-language-server"
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
    
    # Ask about GPG signing
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
    
    # pyenv
    if ! command -v pyenv &> /dev/null; then
        curl https://pyenv.run | bash
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
    
    # Change default shell to Zsh if not already
    if [[ "$SHELL" != "$(which zsh)" ]] && [[ "$INSTALL_MODE" != "dev-only" ]]; then
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            read -p "$(echo -e "${BLUE}Change default shell to Zsh? [Y/n]${NC} ")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                chsh -s "$(which zsh)"
                log SUCCESS "Default shell changed to Zsh"
            fi
        fi
    fi
    
    # Print summary
    echo
    echo -e "${GREEN}${BOLD}Installation completed successfully!${NC}"
    echo
    echo -e "${BLUE}What's next:${NC}"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Run tmux and press Ctrl+Space, I to install plugins"
    echo "  3. Open Neovim and let plugins install automatically"
    echo "  4. Check the docs/ directory for keybindings and customization"
    echo
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
    
    # Check prerequisites
    check_prerequisites
    
    # Source utility scripts
    source_utils
    
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
}

# Run main function
main "$@"