#!/usr/bin/env bash

set -euo pipefail

# Source required files
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DOTFILES_DIR}/scripts/utils.sh"
source "${DOTFILES_DIR}/scripts/distro-detect.sh"
source "${DOTFILES_DIR}/scripts/package-managers.sh"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Installing Neovim and configuration...${NC}"

# Detect distribution
detect_distro
echo -e "${BLUE}Detected distribution: $DISTRO ($DISTRO_FAMILY)${NC}"

# Install Neovim
echo -e "${BLUE}Installing Neovim...${NC}"

case $DISTRO_FAMILY in
    debian|ubuntu)
        # For Ubuntu, try to add the PPA for latest version
        if [[ "$DISTRO" == "ubuntu" ]]; then
            echo "Adding Neovim PPA..."
            sudo add-apt-repository -y ppa:neovim-ppa/stable || true
            sudo apt-get update
        fi
        sudo apt-get install -y neovim
        ;;
    arch)
        sudo pacman -S --noconfirm neovim
        ;;
    fedora|rhel)
        sudo dnf install -y neovim
        ;;
    *)
        echo -e "${YELLOW}Package manager not fully supported, trying generic install...${NC}"
        # Try AppImage as fallback
        echo "Installing Neovim via AppImage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
        
        # Extract if needed
        if ! /usr/local/bin/nvim --version &> /dev/null; then
            cd /usr/local/bin
            sudo ./nvim --appimage-extract
            sudo mv squashfs-root nvim-squashfs
            sudo ln -sf /usr/local/bin/nvim-squashfs/AppRun /usr/local/bin/nvim
            cd - > /dev/null
        fi
        ;;
esac

# Verify Neovim installation
if command -v nvim &> /dev/null; then
    echo -e "${GREEN}✓ Neovim installed successfully${NC}"
    nvim --version | head -1
else
    echo -e "${RED}✗ Failed to install Neovim${NC}"
    exit 1
fi

# Deploy Neovim configuration
echo -e "${BLUE}Deploying Neovim configuration...${NC}"

# Create config directory
mkdir -p "$HOME/.config/nvim"

# Copy configuration files
cp -r "${DOTFILES_DIR}/config/nvim/"* "$HOME/.config/nvim/"

echo -e "${GREEN}✓ Configuration deployed${NC}"

# Install essential tools for Neovim
echo -e "${BLUE}Installing essential tools...${NC}"

# Install ripgrep (required for Telescope)
if ! command -v rg &> /dev/null; then
    case $DISTRO_FAMILY in
        debian|ubuntu)
            sudo apt-get install -y ripgrep
            ;;
        arch)
            sudo pacman -S --noconfirm ripgrep
            ;;
        fedora|rhel)
            sudo dnf install -y ripgrep
            ;;
    esac
fi

# Install fd (optional but recommended)
if ! command -v fd &> /dev/null; then
    case $DISTRO_FAMILY in
        debian|ubuntu)
            sudo apt-get install -y fd-find
            # Create symlink for fd
            mkdir -p ~/.local/bin
            ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true
            ;;
        arch)
            sudo pacman -S --noconfirm fd
            ;;
        fedora|rhel)
            sudo dnf install -y fd-find
            ;;
    esac
fi

# Install language servers support
echo -e "${BLUE}Installing language server dependencies...${NC}"

# Node.js (for many language servers)
if ! command -v node &> /dev/null; then
    case $DISTRO_FAMILY in
        debian|ubuntu)
            sudo apt-get install -y nodejs npm
            ;;
        arch)
            sudo pacman -S --noconfirm nodejs npm
            ;;
        fedora|rhel)
            sudo dnf install -y nodejs npm
            ;;
    esac
fi

# Python support
if command -v pip3 &> /dev/null; then
    pip3 install --user pynvim
else
    echo -e "${YELLOW}pip3 not found, skipping Python support${NC}"
fi

# Node support
if command -v npm &> /dev/null; then
    npm install -g neovim
else
    echo -e "${YELLOW}npm not found, skipping Node.js support${NC}"
fi

echo -e "${GREEN}✓ Dependencies installed${NC}"

echo
echo -e "${GREEN}Neovim installation complete!${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Open Neovim: ${YELLOW}nvim${NC}"
echo "2. Wait for plugins to install automatically"
echo "3. Run ${YELLOW}:checkhealth${NC} to verify setup"
echo "4. Install additional language servers with ${YELLOW}:Mason${NC}"
echo
echo -e "${BLUE}Note:${NC} First startup may take a minute while plugins install."