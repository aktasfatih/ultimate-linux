# Detailed Installation Guide

This guide provides detailed instructions for installing the Ultimate Linux Development Setup.

## Prerequisites Check

Before installing, ensure you have:

1. **Operating System**: Any modern Linux distribution
   - Ubuntu 20.04+ (recommended)
   - Fedora 34+
   - Arch Linux
   - Debian 11+
   - openSUSE Leap 15.3+
   - Other distributions should work with minor adjustments

2. **System Requirements**:
   - Minimum 2GB RAM (4GB+ recommended)
   - At least 1GB free disk space
   - Active internet connection
   - Terminal emulator with 256-color support

3. **User Permissions**:
   - User account with sudo privileges
   - Ability to change default shell

## Installation Methods

### Method 1: One-Line Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/aktasfatih/ultimate-linux/main/install.sh | bash
```

Or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/aktasfatih/ultimate-linux/main/install.sh | bash
```

### Method 2: Clone and Install

```bash
# Clone the repository
git clone https://github.com/aktasfatih/ultimate-linux.git ~/.dotfiles

# Navigate to the directory
cd ~/.dotfiles

# Make install script executable
chmod +x install.sh

# Run installation
./install.sh
```

### Method 3: Manual Installation

For users who prefer more control:

```bash
# Clone repository
git clone https://github.com/aktasfatih/ultimate-linux.git ~/.dotfiles
cd ~/.dotfiles

# Review install script
less install.sh

# Run with specific options
./install.sh --dry-run  # Preview changes
./install.sh --minimal  # Basic installation only
```

## Installation Options

### Full Installation (Default)

Installs everything:
- Zsh with Oh My Zsh
- tmux with plugins
- Neovim with full IDE setup
- All modern CLI tools
- Development tools
- Fonts

```bash
./install.sh
```

### Minimal Installation

Only essential components:
- Zsh with Oh My Zsh
- Basic Git configuration
- Core aliases

```bash
./install.sh --minimal
```

### Server Installation

Optimized for servers (no GUI dependencies):
- Shell environment
- tmux
- Vim/Neovim
- Server management tools

```bash
./install.sh --server
```

### Development Tools Only

Just development tools without shell customization:
- Language version managers
- Git configuration
- Development utilities

```bash
./install.sh --dev-only
```

### Non-Interactive Installation

For automated deployments:

```bash
./install.sh --non-interactive --force
```

### Custom Backup Directory

Specify where to store configuration backups:

```bash
./install.sh --backup-dir=/path/to/backups
```

## Post-Installation Steps

### 1. Change Default Shell

If not changed automatically:

```bash
# Check current shell
echo $SHELL

# Change to Zsh
chsh -s $(which zsh)

# Log out and back in, or:
exec zsh
```

### 2. Configure Git

Update your personal information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Install tmux Plugins

Open tmux and install plugins:

```bash
tmux
# Press Ctrl+Space, then I (capital i)
```

### 4. Configure Neovim

First time opening Neovim:

```bash
nvim
# Plugins will install automatically
# Wait for installation to complete
# Restart Neovim
```

### 5. Set Terminal Font

Set your terminal emulator font to a Nerd Font:
- Recommended: FiraCode Nerd Font
- Alternative: JetBrainsMono Nerd Font

### 6. Optional: Install Additional Language Support

```bash
# Python development
pip3 install --user neovim pylint black

# Node.js development
npm install -g neovim typescript prettier eslint

# Rust development
rustup component add rust-analyzer

# Go development
go install golang.org/x/tools/gopls@latest
```

## Verification

Run the verification script to ensure everything is installed correctly:

```bash
./verify.sh
```

Expected output should show all green checkmarks.

## Customization

Create local configuration files:

```bash
# Shell customizations
touch ~/.zshrc.local

# tmux customizations
touch ~/.tmux.conf.local

# Neovim customizations
mkdir -p ~/.config/nvim/lua/user
```

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for detailed customization options.

## Troubleshooting Installation

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x install.sh
   sudo -v  # Refresh sudo
   ```

2. **Package Manager Errors**
   ```bash
   # Update package lists
   sudo apt update  # Debian/Ubuntu
   sudo dnf check-update  # Fedora
   ```

3. **Oh My Zsh Installation Fails**
   ```bash
   # Manual installation
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

4. **Neovim Version Too Old**
   - The setup requires Neovim 0.9+
   - Script will attempt to install via AppImage if needed

### Distribution-Specific Notes

#### Ubuntu/Debian
- Ensure `universe` repository is enabled
- May need to add Neovim PPA for latest version

#### Fedora
- SELinux may require additional permissions
- Use `dnf` instead of `yum` on newer versions

#### Arch Linux
- Most packages available in official repositories
- AUR helper recommended for some tools

#### WSL (Windows Subsystem for Linux)
- Ensure WSL2 for better performance
- May need to configure display for GUI applications

## Uninstallation

To remove the setup:

```bash
./uninstall.sh
```

This will:
- Remove symlinks
- Optionally uninstall Oh My Zsh
- Optionally remove configurations
- Restore from backup if available

## Getting Help

If you encounter issues:

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Run diagnostic: `./verify.sh > diagnostic.log`
3. Open an issue with diagnostic information

## Next Steps

After successful installation:

1. Read [KEYBINDINGS.md](KEYBINDINGS.md) to learn shortcuts
2. Explore [CUSTOMIZATION.md](CUSTOMIZATION.md) for personalization
3. Run `./update.sh` periodically to keep everything current