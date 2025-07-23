#!/usr/bin/env bash
#
# Test script for Claude Neovim integration
#

set -euo pipefail

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# shellcheck source=./utils.sh
source "$SCRIPT_DIR/utils.sh"

test_claude_integration() {
    local failed=0
    
    log INFO "Testing Claude Neovim integration..."
    
    # Check if Claude Code CLI is installed
    if command -v claude &> /dev/null; then
        log SUCCESS "Claude Code CLI is installed"
        log INFO "Claude Code version: $(claude --version 2>/dev/null || echo 'version not available')"
    else
        log ERROR "Claude Code CLI is not installed"
        log INFO "Install with: npm install -g @anthropic-ai/claude-code"
        ((failed++))
    fi
    
    # Check if Node.js is available (required for Claude Code)
    if command -v node &> /dev/null; then
        local node_version=$(node --version | sed 's/v//')
        local major_version=$(echo "$node_version" | cut -d. -f1)
        if [[ $major_version -ge 18 ]]; then
            log SUCCESS "Node.js $node_version is installed (meets requirement of 18+)"
        else
            log WARNING "Node.js $node_version is installed but Claude Code requires 18+"
            ((failed++))
        fi
    else
        log ERROR "Node.js is not installed (required for Claude Code)"
        ((failed++))
    fi
    
    # Check if Neovim is installed
    if command -v nvim &> /dev/null; then
        log SUCCESS "Neovim is installed"
        
        # Check if the Claude plugin is installed
        if nvim --headless -c 'lua if pcall(require, "claude-code") then vim.fn.writefile({"yes"}, "/tmp/claude_check") else vim.fn.writefile({"no"}, "/tmp/claude_check") end' -c 'quit' 2>/dev/null; then
            if [[ -f /tmp/claude_check ]] && [[ "$(cat /tmp/claude_check)" == "yes" ]]; then
                log SUCCESS "claude-code.nvim plugin is installed"
            else
                log WARNING "claude-code.nvim plugin is not installed or not loaded"
                log INFO "Run :Lazy sync in Neovim to install plugins"
                ((failed++))
            fi
            rm -f /tmp/claude_check
        else
            log WARNING "Could not check claude-code.nvim plugin status"
        fi
        
        # List key mappings
        log INFO "Claude key mappings configured:"
        log INFO "  <Ctrl+,> or <Space>cc - Toggle Claude Code"
        log INFO "  <Space>cr - Continue Claude conversation"
        
    else
        log ERROR "Neovim is not installed"
        ((failed++))
    fi
    
    echo
    if [[ $failed -eq 0 ]]; then
        log SUCCESS "All Claude integration tests passed!"
        log INFO "You can now use Claude in Neovim with the configured key mappings"
    else
        log ERROR "$failed test(s) failed"
        log INFO "Please run ./install.sh to set up missing components"
    fi
    
    return $failed
}

# Run the test
test_claude_integration