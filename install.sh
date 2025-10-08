#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${DOTFILES_DIR}/install.log"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
INSTALL_MODE="full"
FORCE_INSTALL=false
DRY_RUN=false
NON_INTERACTIVE=false
NO_BACKUP=false
SKIP_GIT_CONFIG=false
ACTION="install"
VERSION_FILE="${HOME}/.config/ultimate-linux/version.json"
INSTALL_AGENTS=true

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
    --version           Show installed version and commit info
    --full              Complete setup (default)
    --minimal           Basic setup (shell + git only)
    --server            Server-optimized (no GUI dependencies)
    --dev-only          Just development tools
    --dry-run           Show what would be installed without executing
    --force             Overwrite existing configs without prompting
    --backup-dir=PATH   Specify custom backup location
    --no-backup         Skip creating backup of existing configurations
    --non-interactive   Run without user prompts
    --skip-git-config   Skip Git configuration (keeps existing .gitconfig)

Claude Code Agent Options:
    --agents            Install Claude Code agents (default)
    --no-agents         Skip installing Claude Code agents
    --list-agents       List available agents without installing

Examples:
    ./install.sh                    # Full interactive installation
    ./install.sh --minimal --force  # Minimal setup, overwrite existing
    ./install.sh --dry-run          # Preview installation
    ./install.sh --no-backup       # Skip creating backup of existing configs
    ./install.sh --list-agents     # Show available Claude Code agents
    ./install.sh --no-agents       # Install without agents

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                print_usage
                exit 0
                ;;
            --version)
                ACTION="version"
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
            --no-backup)
                NO_BACKUP=true
                ;;
            --skip-git-config)
                SKIP_GIT_CONFIG=true
                ;;
            --agents)
                INSTALL_AGENTS=true
                ;;
            --no-agents)
                INSTALL_AGENTS=false
                ;;
            --list-agents)
                ACTION="list-agents"
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
        # Check for sudo access (not required on macOS for Homebrew)
        if [[ "$(uname)" != "Darwin" ]]; then
            if ! sudo -n true 2>/dev/null; then
                if [[ "$NON_INTERACTIVE" == "true" ]]; then
                    log ERROR "Sudo access required. Please run with sudo or authenticate first."
                    exit 1
                fi
                log INFO "Sudo access required. Please enter your password."
                sudo true
            fi
        fi
    fi

    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null && ! ping -c 1 8.8.8.8 &> /dev/null; then
        log ERROR "No internet connection detected. Please check your connection."
        exit 1
    fi

    # Check disk space (need at least 1GB)
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS df doesn't support -B flag, use -h and convert
        available_space=$(df -h "$HOME" | awk 'NR==2 {print $4}' | sed 's/[A-Za-z]//g' | cut -d'.' -f1)
        # Simple conversion - if it shows in MB, treat as < 1GB
        if [[ "$available_space" =~ ^[0-9]+$ ]] && [[ $available_space -lt 1 ]]; then
            available_space=0
        else
            available_space=1  # Assume sufficient space if parsing fails
        fi
    else
        available_space=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    fi
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

install_homebrew_if_needed() {
    if [[ "$(uname)" == "Darwin" ]] && ! command -v brew &> /dev/null; then
        log INFO "Installing Homebrew..."
        if [[ "$DRY_RUN" == "true" ]]; then
            log INFO "[DRY RUN] Would install Homebrew"
            return
        fi
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            log ERROR "Failed to install Homebrew"
            exit 1
        }
        # Add Homebrew to PATH for the current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

fix_homebrew_cache() {
    if [[ "$DISTRO_FAMILY" == "macos" ]] && command -v brew &> /dev/null; then
        log INFO "Cleaning Homebrew cache to prevent download issues..."
        brew cleanup --prune-prefix >/dev/null 2>&1 || true
        brew cleanup -s >/dev/null 2>&1 || true
    fi
}

source_utils() {
    source "${DOTFILES_DIR}/scripts/utils.sh"
    source "${DOTFILES_DIR}/scripts/distro-detect.sh"
    source "${DOTFILES_DIR}/scripts/package-managers.sh"
}

create_backup() {
    if [[ "$NO_BACKUP" == "true" ]]; then
        log INFO "Skipping backup (--no-backup flag specified)"
        return
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would create backup at $BACKUP_DIR"
        return
    fi

    log INFO "Creating backup of existing configurations..."
    mkdir -p "$BACKUP_DIR"

    # List of files/dirs to backup
    local items_to_backup=(
        ".zshrc" ".zshenv" ".zshrc.local"
        ".bashrc" ".bash_profile" ".bashrc.local"
        ".tmux.conf" ".tmux.clipboard.conf" ".tmux"
        ".config/nvim" ".config/zsh" ".config/shell" ".config/tmux"
        ".vimrc" ".vim"
        ".gitconfig" ".gitignore_global"
        ".ssh/config" ".config/starship.toml"
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
    if [[ "$DISTRO_FAMILY" == "macos" ]]; then
        local common_packages=(
            "git" "curl" "wget" "cmake"
            "unzip" "tar" "gzip" "ca-certificates" "gnupg"
        )
    else
        local common_packages=(
            "git" "curl" "wget" "build-essential" "cmake"
            "unzip" "tar" "gzip" "ca-certificates" "gnupg"
            "xclip" "xsel" "sshfs"
        )
    fi

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

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would configure shell environments"
        return
    fi

    # Install both shells if not present
    if ! command -v bash &> /dev/null; then
        install_packages "bash"
    fi
    if ! command -v zsh &> /dev/null; then
        install_packages "zsh"
    fi

    # Configure both shells to ensure compatibility
    log INFO "Configuring both Bash and Zsh for maximum compatibility..."

    # Install Zsh components
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

    # Install additional productivity tools (if not minimal mode)
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        log INFO "Installing additional productivity tools..."
        source "$DOTFILES_DIR/scripts/install-productivity-tools.sh" || true
    fi

    # Deploy configurations for BOTH shells
    log INFO "Deploying Bash configuration..."
    deploy_config "config/bash/.bashrc" "$HOME/.bashrc"
    
    log INFO "Deploying Zsh configuration..."
    deploy_config "config/zsh/.zshrc" "$HOME/.zshrc"
    deploy_config "config/zsh/.zshenv" "$HOME/.zshenv"
    
    # Deploy Zsh-specific configurations
    mkdir -p "$HOME/.config/zsh"
    mkdir -p "$HOME/.config/zsh/completions"  # Create completions directory
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

    # Deploy universal shell configuration
    mkdir -p "$HOME/.config/shell"
    deploy_config "config/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"

    log SUCCESS "Shell environment installed for both Bash and Zsh"
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
        "gh:GitHub CLI"
        "lazydocker:Docker TUI"
        "k9s:Kubernetes TUI"
        "ranger:terminal file manager"
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
            gh)
                if ! command -v gh &> /dev/null; then
                    # Try package manager first
                    if [[ "$DISTRO_FAMILY" == "debian" ]]; then
                        # Add GitHub CLI official repository for Debian/Ubuntu
                        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
                        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
                        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
                        && sudo apt update \
                        && sudo apt install gh -y || {
                            log WARN "Failed to install gh via package manager"
                            install_from_github "cli/cli" "gh"
                        }
                    elif [[ "$DISTRO_FAMILY" == "fedora" ]]; then
                        sudo dnf install gh -y || install_from_github "cli/cli" "gh"
                    elif [[ "$DISTRO_FAMILY" == "arch" ]]; then
                        sudo pacman -S --noconfirm github-cli || install_from_github "cli/cli" "gh"
                    elif [[ "$DISTRO_FAMILY" == "alpine" ]]; then
                        sudo apk add github-cli || install_from_github "cli/cli" "gh"
                    elif [[ "$DISTRO_FAMILY" == "macos" ]]; then
                        brew install gh || install_from_github "cli/cli" "gh"
                    else
                        # Fallback to GitHub releases
                        install_from_github "cli/cli" "gh"
                    fi
                fi
                ;;
            lazydocker)
                if ! command -v lazydocker &> /dev/null; then
                    install_from_github "jesseduffield/lazydocker"
                fi
                ;;
            k9s)
                if ! command -v k9s &> /dev/null; then
                    install_from_github "derailed/k9s"
                fi
                ;;
            ranger)
                if ! command -v ranger &> /dev/null; then
                    # ranger is typically available in most package managers
                    install_packages "ranger" || {
                        # Fallback to pip installation if package manager fails
                        log INFO "Installing ranger via pip..."
                        if command -v pip3 &> /dev/null; then
                            pip3 install --user ranger-fm || log WARN "Could not install ranger"
                        else
                            log WARN "pip3 not found, installing python3-pip first..."
                            install_packages "python3-pip" && pip3 install --user ranger-fm || log WARN "Could not install ranger"
                        fi
                    }
                fi
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
    if [[ -f "config/tmux/ultimate-cheatsheet.md" ]]; then
        deploy_config "config/tmux/ultimate-cheatsheet.md" "$HOME/.config/tmux/ultimate-cheatsheet.md"
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

    # Install Neovim - platform-specific installation
    local current_version=$(nvim --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 || echo "0.0")
    
    # Check if we need to update (require at least 0.10)
    if ! command -v nvim &> /dev/null || [[ "$(echo -e "$current_version\n0.10" | sort -V | head -1)" != "0.10" ]]; then
        if [[ "$DISTRO_FAMILY" == "macos" ]]; then
            log INFO "Installing latest Neovim via Homebrew..."
            brew install neovim
        else
            log INFO "Installing latest Neovim (0.10+) via AppImage for all features..."
            install_neovim_appimage
        fi
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
    # TypeScript/JavaScript development tools
    if [[ "$DISTRO_FAMILY" == "macos" ]]; then
        # On macOS, avoid sudo with npm to prevent permission issues
        npm install -g typescript typescript-language-server prettier eslint || true
        npm install -g @fsouza/prettierd eslint_d || true  # Faster formatters
        npm install -g tsx || true  # TypeScript execute
        npm install -g npm-check-updates || true  # Update dependencies
    else
        sudo npm install -g typescript typescript-language-server prettier eslint || true
        sudo npm install -g @fsouza/prettierd eslint_d || true  # Faster formatters
        sudo npm install -g tsx || true  # TypeScript execute
        sudo npm install -g npm-check-updates || true  # Update dependencies
    fi

    # Rust
    if command -v rustup &> /dev/null; then
        rustup component add rust-analyzer || true
    fi

    # Go
    if command -v go &> /dev/null; then
        go install golang.org/x/tools/gopls@latest || true
    fi

    # Bash
    if [[ "$DISTRO_FAMILY" == "macos" ]]; then
        npm install -g bash-language-server || true
    else
        sudo npm install -g bash-language-server || true
    fi

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
    # Skip if flag is set or in non-interactive mode
    if [[ "$SKIP_GIT_CONFIG" == "true" ]] || [[ "$NON_INTERACTIVE" == "true" ]]; then
        log INFO "Skipping Git configuration (--skip-git-config flag set or non-interactive mode)"
        return
    fi
    
    # Check if Git user name is set
    local current_git_name
    current_git_name=$(git config --global user.name 2>/dev/null || true)
    if [[ -z "$current_git_name" ]]; then
        echo
        echo -e "${BLUE}Git user configuration${NC}"
        echo "Please enter your Git user information:"
        read -p "Your name: " git_name
        if [[ -n "$git_name" ]]; then
            git config --global user.name "$git_name"
            log SUCCESS "Git user name set to: $git_name"
        fi
    else
        log INFO "Git user name already configured: $current_git_name"
    fi

    # Check if Git user email is set
    local current_git_email
    current_git_email=$(git config --global user.email 2>/dev/null || true)
    if [[ -z "$current_git_email" ]]; then
        read -p "Your email: " git_email
        if [[ -n "$git_email" ]]; then
            git config --global user.email "$git_email"
            log SUCCESS "Git user email set to: $git_email"
        fi
    else
        log INFO "Git user email already configured: $current_git_email"
    fi

    # Check if GPG signing is already configured
    local existing_gpg_key
    existing_gpg_key=$(git config --global user.signingkey 2>/dev/null || true)
    local existing_gpg_sign
    existing_gpg_sign=$(git config --global commit.gpgsign 2>/dev/null || true)
    
    if [[ -n "$existing_gpg_key" ]] || [[ "$existing_gpg_sign" == "true" ]]; then
        log INFO "GPG signing already configured"
        if [[ -n "$existing_gpg_key" ]]; then
            log INFO "GPG key: $existing_gpg_key"
        fi
        if [[ "$existing_gpg_sign" == "true" ]]; then
            log INFO "Commit signing: enabled"
        fi
    elif [[ "$NON_INTERACTIVE" == "false" ]]; then
        # Ask about GPG signing (only in interactive mode and if not already configured)
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
    if [[ "$SKIP_GIT_CONFIG" == "true" ]]; then
        log INFO "Skipping Git configuration deployment (--skip-git-config flag set)"
    else
        deploy_config "config/git/.gitconfig" "$HOME/.gitconfig"
        deploy_config "config/git/.gitignore_global" "$HOME/.gitignore_global"
        
        # Configure Git user details if not set
        if [[ "$NON_INTERACTIVE" == "false" ]]; then
            configure_git_user
        fi
    fi

    # Install lazygit
    if ! command -v lazygit &> /dev/null; then
        install_from_github "jesseduffield/lazygit"
    fi

    # Install Claude Code CLI (for Neovim integration)
    if ! command -v claude &> /dev/null; then
        log INFO "Installing Claude Code CLI..."
        if command -v npm &> /dev/null; then
            # Try regular npm install first
            if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
                log SUCCESS "Claude Code CLI installed successfully"
            else
                # If that fails due to permissions, configure user directory
                log INFO "Permission denied, configuring npm user directory..."
                mkdir -p ~/.npm-global
                npm config set prefix ~/.npm-global
                
                # Update PATH for current session
                export PATH=~/.npm-global/bin:$PATH
                
                # Add to local shell config files (not the main dotfiles)
                if ! grep -q "npm-global/bin" ~/.bashrc.local 2>/dev/null; then
                    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc.local
                fi
                if ! grep -q "npm-global/bin" ~/.zshrc.local 2>/dev/null; then
                    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc.local
                fi
                
                # Try installing again
                npm install -g @anthropic-ai/claude-code || {
                    log WARNING "Failed to install Claude Code CLI via npm"
                    log INFO "You can install it manually with: npm install -g @anthropic-ai/claude-code"
                }
            fi
        else
            log WARNING "npm not found. Claude Code CLI requires Node.js 18+"
            log INFO "Install Node.js first, then run: npm install -g @anthropic-ai/claude-code"
        fi
    else
        log SUCCESS "Claude Code CLI is already installed"
    fi

    # Install happy-coder (Claude Code wrapper)
    if ! command -v happy &> /dev/null; then
        log INFO "Installing happy-coder..."
        if command -v npm &> /dev/null; then
            npm install -g happy-coder || {
                log WARNING "Failed to install happy-coder via npm"
                log INFO "You can install it manually with: npm install -g happy-coder"
            }
        else
            log WARNING "npm not found. happy-coder requires Node.js"
            log INFO "Install Node.js first, then run: npm install -g happy-coder"
        fi
    else
        log SUCCESS "happy-coder is already installed"
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

list_claude_agents() {
    local agents_source="${DOTFILES_DIR}/config/claude/agents"

    echo -e "${BOLD}${BLUE}Available Claude Code Agents${NC}"
    echo -e "${BLUE}============================${NC}"
    echo

    if [[ ! -d "$agents_source" ]]; then
        echo -e "${YELLOW}No agents directory found.${NC}"
        echo -e "Create agents in: ${CYAN}config/claude/agents/${NC}"
        return
    fi

    local agent_count=0
    while IFS= read -r -d '' agent_file; do
        local agent_name=$(basename "$agent_file")

        # Skip README
        if [[ "$agent_name" == "README.md" ]]; then
            continue
        fi

        # Extract agent name from frontmatter
        local yaml_name=$(grep -m 1 "^name:" "$agent_file" 2>/dev/null | cut -d':' -f2- | sed 's/^[[:space:]]*//')
        local yaml_desc=$(grep -m 1 "^description:" "$agent_file" 2>/dev/null | cut -d':' -f2- | sed 's/^[[:space:]]*//' | head -c 100)

        echo -e "${GREEN}●${NC} ${BOLD}${agent_name}${NC}"
        if [[ -n "$yaml_name" ]]; then
            echo -e "  Name: ${CYAN}$yaml_name${NC}"
        fi
        if [[ -n "$yaml_desc" ]]; then
            echo -e "  ${yaml_desc}..."
        fi
        echo

        ((agent_count++))
    done < <(find "$agents_source" -maxdepth 1 -type f -name "*.md" -print0 2>/dev/null)

    if [[ "$agent_count" -eq 0 ]]; then
        echo -e "${YELLOW}No agent files found.${NC}"
        echo
        echo -e "To create an agent, add a .md file to: ${CYAN}config/claude/agents/${NC}"
        echo -e "See ${CYAN}config/claude/agents/README.md${NC} for format details."
    else
        echo -e "${GREEN}Total: $agent_count agent(s)${NC}"
        echo
        echo -e "To install: ${CYAN}./install.sh --agents${NC}"
    fi
}

install_claude_agents() {
    if [[ "$INSTALL_AGENTS" == "false" ]]; then
        log INFO "Skipping Claude Code agents (--no-agents specified)"
        return
    fi

    log INFO "Setting up Claude Code agents..."

    local agents_source="${DOTFILES_DIR}/config/claude/agents"
    local agents_dest="${HOME}/.claude/agents"

    if [[ "$DRY_RUN" == "true" ]]; then
        log INFO "[DRY RUN] Would create symlink: $agents_dest -> $agents_source"
        if [[ -d "$agents_dest" ]] && [[ ! -L "$agents_dest" ]]; then
            local existing_count=$(find "$agents_dest" -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l)
            if [[ "$existing_count" -gt 0 ]]; then
                log INFO "[DRY RUN] Would migrate $existing_count existing agent(s) to repository"
            fi
        fi
        return
    fi

    # Check if source directory exists
    if [[ ! -d "$agents_source" ]]; then
        log WARN "No agents directory found at $agents_source"
        return
    fi

    # Ensure parent directory exists
    mkdir -p "${HOME}/.claude"

    # Handle existing agents directory/symlink
    if [[ -L "$agents_dest" ]]; then
        # It's already a symlink - check where it points
        local current_target=$(readlink "$agents_dest")
        if [[ "$current_target" == "$agents_source" ]]; then
            log INFO "Agent symlink already correctly configured"
            log INFO "Edit agents in either location: $agents_dest or $agents_source"
            return
        else
            log INFO "Updating existing symlink from $current_target to $agents_source"
            rm "$agents_dest"
        fi
    elif [[ -d "$agents_dest" ]]; then
        # It's a real directory - check for existing agent files to migrate
        local agent_files=$(find "$agents_dest" -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l)

        if [[ "$agent_files" -gt 0 ]]; then
            log INFO "Found $agent_files existing agent(s) in $agents_dest"
            log INFO "These will be migrated to the repository for version control"

            # Ask for confirmation in interactive mode
            if [[ "$FORCE_INSTALL" == "false" ]] && [[ "$NON_INTERACTIVE" == "false" ]]; then
                read -p "Migrate existing agents to repository at $agents_source? [Y/n] " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    log WARN "Skipping agent setup. Existing agents directory preserved."
                    return
                fi
            fi

            # Migrate files to repository
            while IFS= read -r -d '' agent_file; do
                local agent_name=$(basename "$agent_file")
                local dest_file="$agents_source/$agent_name"

                if [[ -f "$dest_file" ]]; then
                    # File exists in repo - create backup
                    cp "$dest_file" "$dest_file.backup.$(date +%Y%m%d_%H%M%S)"
                    log INFO "Backed up existing $agent_name in repository"
                fi

                cp "$agent_file" "$dest_file"
                log SUCCESS "Migrated: $agent_name → repository"
            done < <(find "$agents_dest" -maxdepth 1 -type f -name "*.md" -print0 2>/dev/null)

            log SUCCESS "Migrated $agent_files agent(s) to $agents_source"
        fi

        # Backup and remove existing directory
        local backup_path="$agents_dest.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$agents_dest" "$backup_path"
        log INFO "Backed up existing directory to $backup_path"
    elif [[ -e "$agents_dest" ]]; then
        # It's a file or something else (unusual case)
        log WARN "$agents_dest exists but is not a directory or symlink"
        local backup_path="$agents_dest.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$agents_dest" "$backup_path"
        log INFO "Backed up to $backup_path"
    fi

    # Create the symlink
    ln -s "$agents_source" "$agents_dest"
    log SUCCESS "Created symlink: $agents_dest -> $agents_source"
    log INFO "Agents are now synced! Edit in either location:"
    log INFO "  - Repository: $agents_source"
    log INFO "  - Home: $agents_dest"
    log INFO "Changes in either location are automatically reflected in both"
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

    # Ask about changing default shell to zsh if not already
    local current_shell=$(basename "$SHELL")

    if [[ "$current_shell" != "zsh" ]] && [[ "$INSTALL_MODE" != "dev-only" ]]; then
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

# Version tracking functions
get_git_info() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        cd "$DOTFILES_DIR"
        local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
        local commit_date=$(git log -1 --format="%ai" 2>/dev/null || echo "unknown")
        local commit_message=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "unknown")
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        local remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")
        echo "$commit_hash|$commit_date|$commit_message|$branch|$remote_url"
    else
        echo "unknown|unknown|unknown|unknown|unknown"
    fi
}

store_version_info() {
    if [[ "$DRY_RUN" == "true" ]]; then
        return
    fi
    
    log INFO "Storing version information..."
    
    local version_dir="$(dirname "$VERSION_FILE")"
    mkdir -p "$version_dir"
    
    local git_info=$(get_git_info)
    IFS='|' read -r commit_hash commit_date commit_message branch remote_url <<< "$git_info"
    
    cat > "$VERSION_FILE" << EOF
{
    "install_date": "$(date -Iseconds)",
    "install_mode": "$INSTALL_MODE",
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
    
    log SUCCESS "Version information stored in $VERSION_FILE"
}

show_installed_version() {
    if [[ ! -f "$VERSION_FILE" ]]; then
        echo -e "${YELLOW}No installation information found.${NC}"
        echo -e "${CYAN}Run './install.sh' to install Ultimate Linux setup.${NC}"
        exit 0
    fi
    
    echo -e "${BOLD}${BLUE}Ultimate Linux Development Setup - Installation Info${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo
    
    # Parse JSON manually for compatibility
    local install_date=$(grep '"install_date"' "$VERSION_FILE" | cut -d'"' -f4)
    local install_mode=$(grep '"install_mode"' "$VERSION_FILE" | cut -d'"' -f4)
    local commit=$(grep '"commit"' "$VERSION_FILE" | head -1 | cut -d'"' -f4)
    local commit_date=$(grep '"commit_date"' "$VERSION_FILE" | cut -d'"' -f4)
    local commit_message=$(grep '"commit_message"' "$VERSION_FILE" | cut -d'"' -f4)
    local branch=$(grep '"branch"' "$VERSION_FILE" | cut -d'"' -f4)
    
    echo -e "${GREEN}Installed:${NC} $install_date"
    echo -e "${GREEN}Mode:${NC} $install_mode"
    echo
    echo -e "${CYAN}Git Information:${NC}"
    echo -e "  ${BOLD}Branch:${NC} $branch"
    echo -e "  ${BOLD}Commit:${NC} ${commit:0:8}"
    echo -e "  ${BOLD}Date:${NC} $commit_date"
    echo -e "  ${BOLD}Message:${NC} $commit_message"
    echo
    
    # Check if current repo is different from installed version
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        cd "$DOTFILES_DIR"
        local current_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
        
        if [[ "$current_commit" != "$commit" && "$current_commit" != "unknown" ]]; then
            echo -e "${YELLOW}Repository has updates available!${NC}"
            echo -e "${CYAN}Current commit:${NC} ${current_commit:0:8}"
            echo
            echo -e "${CYAN}To see what's changed, run:${NC}"
            echo "  ./update.sh --changelog"
            echo
            echo -e "${CYAN}To update, run:${NC}"
            echo "  ./update.sh"
        else
            echo -e "${GREEN}✓ Installation is up to date with repository${NC}"
        fi
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
        install)
            # Normal installation flow
            # Check prerequisites
            check_prerequisites

            # Detect distribution
            detect_distro
            log INFO "Detected distribution: $DISTRO ($DISTRO_FAMILY)"

            # Install Homebrew on macOS if needed
            if [[ "$DISTRO_FAMILY" == "macos" ]]; then
                install_homebrew_if_needed
                # Clean Homebrew cache to prevent download issues
                fix_homebrew_cache
                # Install Xcode Command Line Tools if needed
                if ! xcode-select -p &> /dev/null; then
                    log INFO "Installing Xcode Command Line Tools..."
                    if [[ "$DRY_RUN" == "false" ]]; then
                        xcode-select --install
                    fi
                fi
            fi

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
            install_claude_agents

            # Run verification
            run_verification

            # Store version information
            store_version_info

            # Finalize
            finalize_installation
            ;;
        version)
            show_installed_version
            ;;
        list-agents)
            list_claude_agents
            ;;
    esac
}

# Run main function
main "$@"
