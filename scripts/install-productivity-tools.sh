#!/usr/bin/env bash

# Install additional productivity tools

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Source distro detection if not already sourced
if [[ -z "${DISTRO_FAMILY:-}" ]]; then
    source "$SCRIPT_DIR/distro-detect.sh"
fi

install_forgit() {
    log INFO "Installing forgit (interactive git with fzf)..."
    
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/forgit"
    if [[ ! -d "$plugin_dir" ]]; then
        git clone https://github.com/wfxr/forgit.git "$plugin_dir"
        log SUCCESS "forgit installed"
    else
        log INFO "forgit already installed"
    fi
}

install_fzf_tab() {
    log INFO "Installing fzf-tab (fzf tab completion)..."
    
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
    if [[ ! -d "$plugin_dir" ]]; then
        git clone https://github.com/Aloxaf/fzf-tab "$plugin_dir"
        log SUCCESS "fzf-tab installed"
    else
        log INFO "fzf-tab already installed"
    fi
}

install_zsh_vi_mode() {
    log INFO "Installing zsh-vi-mode..."
    
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
    if [[ ! -d "$plugin_dir" ]]; then
        git clone https://github.com/jeffreytse/zsh-vi-mode "$plugin_dir"
        log SUCCESS "zsh-vi-mode installed"
    else
        log INFO "zsh-vi-mode already installed"
    fi
}

install_fast_syntax_highlighting() {
    log INFO "Installing fast-syntax-highlighting..."
    
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
    if [[ ! -d "$plugin_dir" ]]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$plugin_dir"
        log SUCCESS "fast-syntax-highlighting installed"
    else
        log INFO "fast-syntax-highlighting already installed"
    fi
}

install_atuin() {
    log INFO "Installing atuin (better shell history)..."
    
    if ! command -v atuin &> /dev/null; then
        bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh) || {
            log WARN "Failed to install atuin"
            return 1
        }
        log SUCCESS "atuin installed"
    else
        log INFO "atuin already installed"
    fi
}

install_direnv() {
    log INFO "Installing direnv (directory environments)..."
    
    if ! command -v direnv &> /dev/null; then
        case $DISTRO_FAMILY in
            debian|ubuntu)
                install_packages "direnv"
                ;;
            arch)
                install_packages "direnv"
                ;;
            fedora|rhel)
                install_packages "direnv"
                ;;
            *)
                curl -sfL https://direnv.net/install.sh | bash
                ;;
        esac
        log SUCCESS "direnv installed"
    else
        log INFO "direnv already installed"
    fi
}

install_navi() {
    log INFO "Installing navi (interactive cheatsheet)..."
    
    if ! command -v navi &> /dev/null; then
        install_from_github "denisidoro/navi" "navi" || {
            log WARN "Failed to install navi"
            return 1
        }
        log SUCCESS "navi installed"
    else
        log INFO "navi already installed"
    fi
}

install_glow() {
    log INFO "Installing glow (markdown renderer)..."
    
    if ! command -v glow &> /dev/null; then
        install_from_github "charmbracelet/glow" "glow" || {
            log WARN "Failed to install glow"
            return 1
        }
        log SUCCESS "glow installed"
    else
        log INFO "glow already installed"
    fi
}

install_slides() {
    log INFO "Installing slides (terminal presentation)..."
    
    if ! command -v slides &> /dev/null; then
        install_from_github "maaslalani/slides" "slides" || {
            log WARN "Failed to install slides"
            return 1
        }
        log SUCCESS "slides installed"
    else
        log INFO "slides already installed"
    fi
}

install_gdu() {
    log INFO "Installing gdu (disk usage analyzer)..."
    
    if ! command -v gdu &> /dev/null; then
        install_from_github "dundee/gdu" "gdu" || {
            log WARN "Failed to install gdu"
            return 1
        }
        log SUCCESS "gdu installed"
    else
        log INFO "gdu already installed"
    fi
}

install_duf() {
    log INFO "Installing duf (disk usage/free)..."
    
    if ! command -v duf &> /dev/null; then
        install_from_github "muesli/duf" "duf" || {
            log WARN "Failed to install duf"
            return 1
        }
        log SUCCESS "duf installed"
    else
        log INFO "duf already installed"
    fi
}

install_httpie() {
    log INFO "Installing httpie (better curl)..."
    
    if ! command -v http &> /dev/null; then
        if command -v pipx &> /dev/null; then
            pipx install httpie
        else
            python3 -m pip install --user httpie
        fi
        log SUCCESS "httpie installed"
    else
        log INFO "httpie already installed"
    fi
}

install_tldr() {
    log INFO "Installing tldr (simplified man pages)..."
    
    if ! command -v tldr &> /dev/null; then
        if command -v npm &> /dev/null; then
            npm install -g tldr
        else
            install_from_github "raylee/tldr-sh-client" "tldr"
        fi
        log SUCCESS "tldr installed"
    else
        log INFO "tldr already installed"
    fi
}

# Main installation
main() {
    log INFO "Installing productivity tools..."
    
    # Zsh plugins
    install_forgit
    install_fzf_tab
    install_zsh_vi_mode
    install_fast_syntax_highlighting
    
    # CLI tools
    install_atuin
    install_direnv
    install_navi
    install_glow
    install_slides
    install_gdu
    install_duf
    install_httpie
    install_tldr
    
    log SUCCESS "Productivity tools installation complete!"
    log INFO "Remember to update your .zshrc plugins list to include the new plugins"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi