#!/usr/bin/env bash

# Test installation script with automated responses

set -euo pipefail

echo "Running test installation..."

# Set up Git config for testing
git config --global user.name "Test User" 2>/dev/null || true
git config --global user.email "test@example.com" 2>/dev/null || true

# Run installation in non-interactive mode
echo "Starting non-interactive installation..."
./install.sh --non-interactive --force

echo "Installation complete!"

# Run verification
echo "Running verification..."
./verify.sh || true

echo "Test installation finished!"