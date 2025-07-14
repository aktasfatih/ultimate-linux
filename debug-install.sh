#!/usr/bin/env bash

# Debug script to test the eza installation

set -euxo pipefail  # Enable debug mode

# Source required files
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DOTFILES_DIR}/scripts/utils.sh"

# Set up logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Test the install_from_github function directly
echo "Testing eza installation..."

# First check if eza is already installed
if command -v eza &> /dev/null; then
    echo "eza is already installed"
    eza --version
else
    echo "eza not found, attempting to install..."
    
    # Try to install eza
    install_from_github "eza-community/eza" "eza" || {
        echo "Failed to install eza from GitHub"
        
        # Try alternative installation method
        echo "Trying alternative installation via apt..."
        sudo apt update
        sudo apt install -y eza || echo "apt install failed"
    }
fi

echo "Done!"