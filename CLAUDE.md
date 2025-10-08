# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## IMPORTANT: Script Integration Policy

**All functionality should be integrated into the main scripts (install.sh, update.sh, verify.sh, etc.) rather than creating separate standalone scripts.** This ensures:
- Single entry point for users
- Consistent user experience
- Easier maintenance and testing
- No confusion about which script to run

When adding new features:
1. Add command-line options to existing scripts (e.g., `--validate-shell`, `--fix-shell`)
2. Integrate functions directly into the appropriate main script
3. Avoid creating new executable scripts unless absolutely necessary
4. Document new options in the script's help text

## CRITICAL: Fix Issues in Source Scripts, Not Deployed Files

**NEVER modify deployed configuration files directly (e.g., ~/.zshrc, ~/.bashrc).** All fixes must be made in:
1. The source configuration files in the `config/` directory
2. The installation scripts that deploy these configurations
3. The utility scripts in `scripts/` that are sourced by the installers

This ensures:
- The fix will work on fresh installations
- The repository remains the single source of truth
- Updates can be deployed cleanly without manual intervention
- Other users benefit from the fixes

Example:
- ❌ BAD: Editing `~/.zshrc` directly
- ✅ GOOD: Editing `config/zsh/.zshrc` and/or fixing the deployment logic in `install.sh`

## Repository Overview

This is the Ultimate Development Setup - a comprehensive dotfiles repository that provides automated installation and management of a complete development environment across multiple Linux distributions and macOS. It includes shell configuration (Bash/Zsh with Oh My Zsh), tmux, Neovim IDE configuration, and modern CLI tools.

### Platform Support
- **Linux**: Ubuntu, Debian, Fedora, Arch, openSUSE, Alpine, and many more distributions
- **macOS**: Full support via Homebrew package manager
- Cross-platform configurations that work seamlessly on both Linux and macOS

## Core Commands

### Installation
```bash
# Full installation
./install.sh

# Installation modes
./install.sh --minimal           # Basic shell + git only
./install.sh --server            # No GUI dependencies
./install.sh --dev-only          # Just development tools
./install.sh --dry-run           # Preview without installing
./install.sh --force             # Overwrite existing configs
./install.sh --non-interactive   # Automated installation

# Shell management
./install.sh --shell=bash        # Install with Bash as preferred shell
./install.sh --shell=zsh         # Install with Zsh as preferred shell (default)
./install.sh --validate-shell    # Check for shell configuration issues
./install.sh --fix-shell         # Fix detected shell issues
./install.sh --migrate-shell=bash  # Migrate to Bash
./install.sh --migrate-shell=zsh   # Migrate to Zsh

# Claude Code agent management
./install.sh --agents            # Install Claude Code agents (default)
./install.sh --no-agents         # Skip installing agents
./install.sh --list-agents       # List available agents
```

### Maintenance
```bash
# Update components
./update.sh                      # Update all components
./update.sh --dotfiles-only      # Update just dotfiles
./update.sh --packages-only      # Update system packages only
./update.sh --tools-only         # Update development tools only

# Backup and restore
./backup.sh                      # Interactive backup to ~/.dotfiles_backups/
./backup.sh --auto               # Automatic backup (used by update.sh)
~/.dotfiles_backups/backup_*/restore.sh  # Restore from backup

# Verification and troubleshooting
./verify.sh                      # Test installation and check for issues
./scripts/troubleshoot.sh        # Diagnose common issues

# Uninstall
./uninstall.sh                   # Interactive uninstallation
```

### Testing and Debugging
```bash
# Debug installation
bash -x install.sh               # Debug mode
tail -f install.log              # Monitor installation progress

# Test specific functionality
./scripts/test-clipboard.sh      # Test clipboard integration
./scripts/test-setup.sh          # Comprehensive test suite
./scripts/test-neovim.sh         # Test Neovim setup
./scripts/check-neovim.sh        # Neovim health check

# Neovim plugin management
nvim --headless "+Lazy! sync" +qa  # Update plugins from command line
```

## Architecture and Key Components

### Script Organization
The repository uses a modular architecture with sourced utility scripts:

1. **Main Scripts** (root directory):
   - `install.sh` - Main installer that orchestrates the setup process
   - Sources `scripts/distro-detect.sh`, `scripts/package-managers.sh`, and `scripts/utils.sh`
   - Uses `set -euo pipefail` for error handling
   - Implements installation modes and logging to `install.log`

2. **Utility Scripts** (`scripts/`):
   - `distro-detect.sh` - Detects Linux distribution and sets `$DISTRO_FAMILY`, `$PACKAGE_MANAGER`
   - `package-managers.sh` - Abstracts package installation across different distros
   - `utils.sh` - Common functions including `install_from_github()`, `download_file()`, `deploy_config()`
   - All scripts export their functions for use by other scripts

### Key Installation Flow
1. **Prerequisites Check** → **Distro Detection** → **Backup Existing Configs**
2. **Install Base Packages** (includes `xclip`, `xsel` for clipboard support)
3. **Install Components**: Shell Environment → tmux → Neovim → Dev Tools → Fonts
4. **Deploy Configurations** using `deploy_config()` function

### Configuration Structure
- **Bash**: `config/bash/.bashrc`, `.bash_profile`, `.bash_aliases`
- **Zsh**: `config/zsh/.zshrc`, `.zshenv`, `.zprofile` with plugin management
- **Shell-agnostic**: `config/shell/aliases.sh` - Universal aliases
- **tmux**: `config/tmux/.tmux.conf`, `.tmux.clipboard.conf` with TPM plugins
- **Neovim**: `config/nvim/` with Lua-based configuration and lazy.nvim
- **Git**: `config/git/.gitconfig`, `.gitignore_global`
- **Claude Code Agents**: `config/claude/agents/` - Custom agent definitions

### Distribution Support
The system detects and supports multiple distribution families:
- **Debian-based**: Ubuntu, Debian, Linux Mint, Pop!_OS
- **Fedora-based**: Fedora, RHEL, CentOS, Rocky Linux
- **Arch-based**: Arch, Manjaro, EndeavourOS
- **Others**: openSUSE, Alpine, Gentoo, NixOS

### Package Installation Pattern
```bash
# Package name mapping handled by map_package_name() in package-managers.sh
# Example: "bat" → "batcat" on older Ubuntu
install_packages "package1" "package2"
```

### GitHub Release Downloads
The `install_from_github()` function handles downloading binaries from GitHub releases:
- Detects OS and architecture (handles both "amd64" and "x86_64" naming)
- Handles rate limiting gracefully
- Falls back to cargo installation when available
- Supports various archive formats (.tar.gz, .zip, .deb, .rpm)

### Neovim Configuration Architecture
- **Plugin Manager**: lazy.nvim with lazy loading for performance
- **Core Configuration**: Split into `core/` directory (keymaps, options, autocmds)
- **Plugin Configurations**: Separate config files in `plugins/configs/`
- **LSP Setup**: Mason for automatic LSP server installation
- **Debugging**: Full DAP (Debug Adapter Protocol) support for Go, Node.js, Python
- **GitHub Integration**: Octo.nvim for issues, PRs, and code reviews

### Clipboard Integration
- System clipboard tools (`xclip`, `xsel`) installed by default
- tmux configured with dynamic clipboard detection (`.tmux.clipboard.conf`)
- Neovim uses `clipboard=unnamedplus` with custom clipboard provider
- Test with `./scripts/test-clipboard.sh`

### Shell Configuration Management
The installer includes comprehensive shell management features:
- **Auto-detection**: Automatically detects current shell and respects user preference
- **Validation**: Checks for mixed shell configurations (e.g., Zsh commands in .bashrc)
- **Auto-fix**: Can automatically fix common shell configuration issues
- **Migration**: Safely migrate between Bash and Zsh with full backup
- **Guards**: All shell configs include guards to prevent cross-shell execution

### Local Customization Support
- `~/.bashrc.local` - Bash customizations
- `~/.zshrc.local` - Zsh customizations
- `~/.tmux.conf.local` - tmux customizations
- `~/.config/nvim/lua/user/` - Neovim customizations
- `~/.bashrc.$(hostname)` / `~/.zshrc.$(hostname)` - Machine-specific configs

### Claude Code Agent Management
The setup includes support for custom Claude Code agents that provide specialized assistance for development tasks. Agents are **symlinked** between the repository and your home directory for automatic synchronization.

**How It Works:**
- **Repository**: `config/claude/agents/` - Agent definitions tracked in Git
- **Home Directory**: `~/.claude/agents/` - **Symlinked** to repository
- **Automatic Sync**: Changes in either location are instantly reflected in both
- **No Redeployment**: Edit agents and save - they're immediately available!

**Agent File Format:**
```markdown
---
name: agent-slug-name
description: Use this agent when... (with examples)
model: sonnet
color: red
---

[Agent instructions and system prompt]
```

**CLI Commands:**
```bash
./install.sh --list-agents    # List available agents
./install.sh --agents          # Set up agent symlink (first time)
./install.sh --no-agents       # Skip agent setup
```

**Creating Custom Agents:**
1. Create a `.md` file in **either** location:
   - `config/claude/agents/my-agent.md` (repository - recommended)
   - `~/.claude/agents/my-agent.md` (home directory)
2. Follow the format with YAML frontmatter (see `config/claude/agents/README.md`)
3. Agents are **instantly available** - no deployment needed!

**Key Features:**
- **Symlinked**: `~/.claude/agents` → `config/claude/agents` (bidirectional sync)
- **Version controlled**: All agents tracked in Git
- **Migration support**: Existing agents automatically migrated to repository on first install
- **Automatic backup**: Existing agent directories backed up before symlinking
- **Global availability**: Agents available across all projects

## Key Bindings and Cheatsheet

**IMPORTANT**: All keybindings and command references are maintained in `config/tmux/ultimate-cheatsheet.md`. This is the single source of truth for all keybindings, commands, and shortcuts across the entire setup.

To access the cheatsheet:
- In tmux: Press `Prefix + ?` (Ctrl+Space then ?)
- From terminal: `bat ~/.config/tmux/ultimate-cheatsheet.md`
- The cheatsheet includes:
  - tmux keybindings (Prefix: `Ctrl+Space`)
  - Neovim commands (Leader: `Space`)
  - Debugging controls (DAP)
  - GitHub integration (Octo.nvim)
  - Shell shortcuts and aliases
  - Git commands and workflows
  - Modern CLI tools usage
  - System management commands

Every time a change is made, new features are added, the cheatsheet should be updated with the new information.

## Known Issues and Solutions

### Installation Hanging
- Usually caused by GitHub API downloads
- Check `install.log` for "Installing X from GitHub..."
- Fixed by adding proper error handling and timeouts to `install_from_github()`

### Missing Clipboard Support
- Ensure `xclip` or `xsel` is installed
- Run `./scripts/test-clipboard.sh` to verify
- Check tmux with `tmux show-options -g | grep clipboard`

### Package Name Differences
- Handled by `map_package_name()` function
- Example: `fd-find` vs `fd`, `batcat` vs `bat`

### Neovim Plugin Issues
- Debugging plugins require proper DAP adapter installation
- Mason automatically installs required debug adapters (delve, js-debug-adapter, debugpy)
- Octo.nvim requires GitHub CLI authentication: `gh auth login`

## Development Guidelines

### Adding New Tools
1. Add to appropriate section in `install.sh` (e.g., `install_modern_cli_tools()`)
2. Use `install_from_github "owner/repo" "binary_name"` for GitHub releases
3. Fall back to `install_via_cargo` or `install_packages`
4. Update help text in `show_help()` function

### Modifying Configurations
1. Edit files in `config/` directory
2. Test with `--dry-run` first
3. Use `deploy_config()` for safe deployment with backups
4. Consider adding guards for shell-specific configs

### Documentation Updates
1. **Cheatsheet/Keybindings**: Update ONLY `config/tmux/ultimate-cheatsheet.md`
   - This is the single source of truth for all keybindings and commands
   - Do NOT update the deprecated `docs/cheatsheet.md`
   - The cheatsheet is accessible via `Prefix + ?` in tmux
2. **Other documentation**: Update files in `docs/` directory as needed
3. **Script documentation**: Update help text in the scripts themselves

### Script Best Practices
- Always use `set -euo pipefail` in bash scripts
- Source required scripts at the beginning
- Use the provided `log` function for consistent output
- Handle errors gracefully with `|| true` where appropriate
- Add `|| true` to grep commands to prevent exit on no matches
- Test with both Bash and Zsh users in mind

### Testing Changes
```bash
# Test installation in dry-run mode
./install.sh --dry-run

# Run the test suite
./scripts/test-setup.sh

# Verify specific component
./verify.sh | grep -i "component_name"

# Test with different shells
./install.sh --shell=bash --dry-run
./install.sh --shell=zsh --dry-run
```

### Neovim Plugin Development
- Plugin configurations go in `config/nvim/lua/plugins/configs/`
- Use lazy.nvim's lazy loading for performance
- For debugging: Add to Mason DAP setup in `config/nvim/lua/plugins/configs/lsp.lua`
- Always test buffer-local keymaps with FileType autocmds
- Verify Lua syntax: `lua -e "loadfile('path/to/file')"`

### Common Pitfalls
1. **Invalid keymap parameters**: `vim.keymap.set()` doesn't accept `ft` parameter - use FileType autocmds
2. **Manual user config edits**: Always fix source files in `config/` directory
3. **Missing dependency handling**: Check if tools exist before using them
4. **Cross-platform issues**: Test on both Linux and macOS
5. **Plugin version compatibility**: Pin versions for Neovim 0.9.x compatibility
