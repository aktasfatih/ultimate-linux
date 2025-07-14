#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0
WARNINGS=0

source "${DOTFILES_DIR}/scripts/utils.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

check_mark="✓"
cross_mark="✗"
warning_mark="⚠"

success() {
    echo -e "${GREEN}${check_mark}${NC} $1"
}

error() {
    echo -e "${RED}${cross_mark}${NC} $1"
    ((ERRORS++))
}

warning() {
    echo -e "${YELLOW}${warning_mark}${NC} $1"
    ((WARNINGS++))
}

check_command() {
    local cmd=$1
    local name=${2:-$1}
    
    if command -v "$cmd" &> /dev/null; then
        local version=$(eval "$cmd --version 2>/dev/null | head -1" || echo "unknown")
        success "$name is installed: $version"
        return 0
    else
        error "$name is not installed"
        return 1
    fi
}

check_shell_startup() {
    local shell=$1
    echo -e "\n${GREEN}Testing $shell startup:${NC}"
    
    if command -v "$shell" &> /dev/null; then
        local test_output=$($shell -l -c 'echo "OK"' 2>&1)
        if [[ "$test_output" == *"OK"* ]] && [[ "$test_output" != *"command not found"* ]] && [[ "$test_output" != *"setopt"* ]] && [[ "$test_output" != *"shopt"* ]]; then
            success "$shell starts without errors"
        else
            error "$shell has startup errors"
        fi
    else
        warning "$shell is not installed"
    fi
}

check_file() {
    local file=$1
    local type=${2:-"exists"}
    
    case $type in
        exists)
            if [[ -e "$file" ]]; then
                success "$file exists"
                return 0
            else
                error "$file does not exist"
                return 1
            fi
            ;;
        symlink)
            if [[ -L "$file" ]]; then
                local target=$(readlink "$file")
                success "$file is a symlink → $target"
                return 0
            elif [[ -e "$file" ]]; then
                warning "$file exists but is not a symlink"
                return 1
            else
                error "$file does not exist"
                return 1
            fi
            ;;
    esac
}

check_directory() {
    local dir=$1
    
    if [[ -d "$dir" ]]; then
        success "$dir directory exists"
        return 0
    else
        error "$dir directory does not exist"
        return 1
    fi
}

verify_shell() {
    echo -e "\n${GREEN}Shell Environment:${NC}"
    
    check_command "zsh" "Zsh"
    check_directory "$HOME/.oh-my-zsh" "Oh My Zsh"
    check_file "$HOME/.zshrc"
    check_file "$HOME/.zshenv"
    
    # Check Zsh plugins
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        local plugins=(
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
        )
        
        for plugin in "${plugins[@]}"; do
            local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin"
            if [[ -d "$plugin_dir" ]]; then
                success "Zsh plugin $plugin is installed"
            else
                error "Zsh plugin $plugin is not installed"
            fi
        done
    fi
    
    check_command "starship" "Starship prompt"
}

verify_terminal_tools() {
    echo -e "\n${GREEN}Terminal Tools:${NC}"
    
    check_command "tmux"
    check_file "$HOME/.tmux.conf"
    check_directory "$HOME/.tmux/plugins/tpm" "TPM (Tmux Plugin Manager)"
    
    # Modern CLI tools
    local tools=(
        "eza:eza/exa"
        "bat:bat"
        "rg:ripgrep"
        "fd:fd"
        "fzf:fzf"
        "zoxide:zoxide"
        "delta:delta"
        "dust:dust"
        "procs:procs"
        "btm:bottom"
    )
    
    for tool_info in "${tools[@]}"; do
        local cmd="${tool_info%%:*}"
        local name="${tool_info#*:}"
        check_command "$cmd" "$name" || true
    done
}

verify_editor() {
    echo -e "\n${GREEN}Editor:${NC}"
    
    check_command "nvim" "Neovim"
    check_directory "$HOME/.config/nvim" "Neovim config"
    
    if command -v nvim &> /dev/null; then
        # Check if Neovim version is >= 0.9
        local nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        local major_version="${nvim_version%%.*}"
        local minor_version="${nvim_version#*.}"
        
        if [[ "$major_version" -gt 0 ]] || [[ "$major_version" -eq 0 && "$minor_version" -ge 9 ]]; then
            success "Neovim version $nvim_version is >= 0.9"
        else
            warning "Neovim version $nvim_version is < 0.9 (some features may not work)"
        fi
        
        # Check for lazy.nvim
        if [[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
            success "lazy.nvim is installed"
        else
            error "lazy.nvim is not installed"
        fi
    fi
}

verify_development_tools() {
    echo -e "\n${GREEN}Development Tools:${NC}"
    
    check_command "git"
    check_file "$HOME/.gitconfig"
    check_file "$HOME/.gitignore_global"
    
    # Language tools
    check_command "python3" "Python 3"
    check_command "pip3" "pip3"
    check_command "node" "Node.js"
    check_command "npm" "npm"
    
    # Optional tools
    echo -e "\n${YELLOW}Optional Language Tools:${NC}"
    check_command "rustc" "Rust" || warning "Rust is not installed (optional)"
    check_command "go" "Go" || warning "Go is not installed (optional)"
    check_command "fnm" "fnm (Fast Node Manager)" || warning "fnm is not installed (optional)"
    check_command "pyenv" "pyenv" || warning "pyenv is not installed (optional)"
}

verify_fonts() {
    echo -e "\n${GREEN}Fonts:${NC}"
    
    local font_dir="$HOME/.local/share/fonts"
    if [[ -d "$font_dir" ]]; then
        local nerd_fonts=$(find "$font_dir" -name "*Nerd*" -type f 2>/dev/null | wc -l)
        if [[ $nerd_fonts -gt 0 ]]; then
            success "Found $nerd_fonts Nerd Font files"
        else
            warning "No Nerd Fonts found in $font_dir"
        fi
    else
        error "Font directory $font_dir does not exist"
    fi
}

verify_permissions() {
    echo -e "\n${GREEN}Permissions:${NC}"
    
    # Check if scripts are executable
    local scripts=(
        "install.sh"
        "update.sh"
        "backup.sh"
        "uninstall.sh"
        "verify.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [[ -x "$DOTFILES_DIR/$script" ]]; then
            success "$script is executable"
        else
            error "$script is not executable"
        fi
    done
}

run_health_checks() {
    echo -e "\n${GREEN}Health Checks:${NC}"
    
    # Check if running in tmux
    if [[ -n "${TMUX:-}" ]]; then
        success "Currently running in tmux"
    else
        warning "Not running in tmux"
    fi
    
    # Check current shell
    local default_shell=$(basename "$SHELL")
    local current_shell=""
    if [[ -n "${BASH_VERSION:-}" ]]; then
        current_shell="bash"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        current_shell="zsh"
    else
        current_shell=$(ps -p $$ -o comm= | sed 's/^-//')
    fi
    
    success "Default shell: $default_shell, Current shell: $current_shell"
    
    # Check for shell configuration issues
    if [[ -f "$DOTFILES_DIR/scripts/shell-validator.sh" ]]; then
        echo -e "\n${GREEN}Shell Configuration:${NC}"
        if "$DOTFILES_DIR/scripts/shell-validator.sh" validate > /dev/null 2>&1; then
            success "Shell configuration is valid"
        else
            error "Shell configuration has issues - run './scripts/shell-validator.sh fix'"
        fi
    fi
    
    # Check if in SSH session
    if [[ -n "${SSH_CONNECTION:-}" ]]; then
        warning "Running in SSH session"
    else
        success "Running in local session"
    fi
}

generate_report() {
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}Verification Summary:${NC}"
    echo -e "${GREEN}========================================${NC}"
    
    if [[ $ERRORS -eq 0 ]]; then
        echo -e "${GREEN}✓ All checks passed!${NC}"
    else
        echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
    fi
    
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠ Found $WARNINGS warning(s)${NC}"
    fi
    
    echo
    
    # Provide recommendations
    if [[ $ERRORS -gt 0 ]] || [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}Recommendations:${NC}"
        
        if ! command -v zsh &> /dev/null; then
            echo "  - Run: ./install.sh to install missing components"
        fi
        
        if [[ -f "$DOTFILES_DIR/scripts/shell-validator.sh" ]] && ! "$DOTFILES_DIR/scripts/shell-validator.sh" validate > /dev/null 2>&1; then
            echo "  - Fix shell configuration: ./scripts/shell-validator.sh fix"
        fi
        
        if [[ "$SHELL" != */zsh ]] && [[ "$SHELL" != */bash ]]; then
            echo "  - Change default shell: ./migrate-shell.sh [bash|zsh]"
        fi
        
        if ! command -v nvim &> /dev/null; then
            echo "  - Install Neovim for the best experience"
        fi
        
        echo
    fi
}

main() {
    echo -e "${GREEN}Ultimate Linux Development Setup - Verification${NC}"
    echo -e "${GREEN}==============================================${NC}"
    
    verify_shell
    verify_terminal_tools
    verify_editor
    verify_development_tools
    verify_fonts
    verify_permissions
    run_health_checks
    
    # Check shell startups
    echo -e "\n${GREEN}Shell Startup Tests:${NC}"
    check_shell_startup bash
    check_shell_startup zsh
    
    generate_report
    
    # Exit with error if any checks failed
    exit $ERRORS
}

main