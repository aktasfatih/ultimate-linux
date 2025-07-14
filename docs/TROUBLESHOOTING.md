# Troubleshooting Guide

This guide covers common issues and their solutions for the Ultimate Linux Development Setup.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Shell Problems](#shell-problems)
- [tmux Issues](#tmux-issues)
- [Neovim Problems](#neovim-problems)
- [Font and Display Issues](#font-and-display-issues)
- [Performance Issues](#performance-issues)
- [Tool-Specific Problems](#tool-specific-problems)

## Installation Issues

### Script Fails with Permission Denied

**Problem**: Installation script fails with permission errors.

**Solution**:
```bash
# Make scripts executable
chmod +x install.sh update.sh backup.sh uninstall.sh verify.sh

# If sudo issues persist
sudo -v  # Refresh sudo timeout
```

### Package Installation Fails

**Problem**: Package manager fails to install dependencies.

**Solution**:
```bash
# Update package lists
sudo apt update  # Debian/Ubuntu
sudo dnf check-update  # Fedora
sudo pacman -Sy  # Arch

# Fix broken packages
sudo apt --fix-broken install  # Debian/Ubuntu
sudo dnf distro-sync  # Fedora
```

### Oh My Zsh Installation Hangs

**Problem**: Oh My Zsh installation doesn't complete.

**Solution**:
```bash
# Remove partial installation
rm -rf ~/.oh-my-zsh

# Reinstall manually
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

## Shell Problems

### Zsh Not Found After Installation

**Problem**: `zsh: command not found` after installation.

**Solution**:
```bash
# Check if zsh is installed
which zsh

# Add zsh to valid shells
echo $(which zsh) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which zsh)
```

### Plugins Not Loading

**Problem**: Zsh plugins show errors or don't work.

**Solution**:
```bash
# Reinstall plugins
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Reload shell
source ~/.zshrc
```

### Slow Shell Startup

**Problem**: Shell takes too long to start.

**Solution**:
```bash
# Profile startup time
zsh -xvfd

# Disable unused plugins in ~/.zshrc
# Comment out heavy plugins temporarily

# Clear completion cache
rm -f ~/.zcompdump*
rm -rf ~/.cache/zsh
```

### Command Not Found for Modern Tools

**Problem**: Commands like `eza`, `bat`, `fd` not found.

**Solution**:
```bash
# Check PATH
echo $PATH

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Reinstall tools
./install.sh --tools-only
```

## tmux Issues

### Plugins Not Installing

**Problem**: TPM plugins don't install with `Prefix + I`.

**Solution**:
```bash
# Install TPM manually
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Inside tmux, reload config
# Prefix + r

# Install plugins manually
~/.tmux/plugins/tpm/scripts/install_plugins.sh
```

### Mouse Support Not Working

**Problem**: Can't select text or scroll with mouse.

**Solution**:
```bash
# Check tmux version
tmux -V

# For tmux < 2.1, add to ~/.tmux.conf:
set -g mode-mouse on
set -g mouse-resize-pane on
set -g mouse-select-pane on
set -g mouse-select-window on

# For text selection, hold Shift while selecting
```

### Status Bar Not Displaying Correctly

**Problem**: Status bar shows weird characters or incorrect colors.

**Solution**:
```bash
# Ensure terminal supports 256 colors
echo $TERM

# Set in ~/.tmux.conf
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Restart tmux server
tmux kill-server
```

### Sessions Not Persisting

**Problem**: tmux-resurrect not saving/restoring sessions.

**Solution**:
```bash
# Check if continuum is running
tmux show-option -g @continuum-save-interval

# Manually save session
# Prefix + Ctrl+s

# Check saved sessions
ls ~/.tmux/resurrect/
```

## Neovim Problems

### Plugins Not Installing

**Problem**: Lazy.nvim not installing plugins.

**Solution**:
```bash
# Clear plugin cache
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Reinstall plugins
nvim --headless "+Lazy! sync" +qa

# Or open Neovim and run
:Lazy sync
```

### LSP Not Working

**Problem**: Language servers not starting or working incorrectly.

**Solution**:
```bash
# Check installed servers
nvim
:Mason

# Reinstall servers
:MasonUninstallAll
:Mason

# Check LSP log
:LspLog
```

### Treesitter Errors

**Problem**: Syntax highlighting not working, treesitter errors.

**Solution**:
```bash
# In Neovim
:TSInstall all
:TSUpdate

# If C compiler errors
sudo apt install build-essential  # Debian/Ubuntu
sudo dnf install gcc gcc-c++       # Fedora
```

### Telescope Not Finding Files

**Problem**: Telescope file finder not showing all files.

**Solution**:
```bash
# Check if ripgrep is installed
which rg

# Install if missing
sudo apt install ripgrep  # Debian/Ubuntu

# Check gitignore settings in Neovim
:lua print(vim.inspect(require('telescope.config').values.vimgrep_arguments))
```

## Font and Display Issues

### Icons Not Displaying

**Problem**: Seeing boxes or question marks instead of icons.

**Solution**:
```bash
# Install Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# Download a Nerd Font (e.g., FiraCode)
curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip

# Update font cache
fc-cache -fv

# Set terminal font to installed Nerd Font
```

### Terminal Colors Look Wrong

**Problem**: Colors don't match screenshots or look washed out.

**Solution**:
```bash
# Check terminal color support
echo $COLORTERM
tput colors

# For true color support, add to shell config:
export COLORTERM=truecolor

# Test true color
curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
```

## Performance Issues

### High CPU Usage

**Problem**: System slow, high CPU usage from shell or Neovim.

**Solution**:
```bash
# Identify culprit
htop
# or
top

# For Neovim, disable expensive plugins
# Comment out in plugin config:
# - Treesitter highlighting for large files
# - Real-time linting
# - Git integration for large repos

# For shell, profile startup
zsh -xvfd 2>&1 | ts -i "%.s" > zsh_profile.log
```

### Slow File Operations

**Problem**: File browsing or searching is slow.

**Solution**:
```bash
# Use faster alternatives
alias find='fd'
alias grep='rg'

# Exclude large directories
# Add to ~/.config/fd/ignore:
node_modules
.git
target
dist

# For Neovim Telescope, limit search depth
:Telescope find_files find_command=fd,--type,f,--max-depth,3
```

## Tool-Specific Problems

### Docker Commands Need Sudo

**Problem**: Docker requires sudo for every command.

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Activate changes
newgrp docker

# Verify
docker run hello-world
```

### Git Credentials Not Saving

**Problem**: Git asks for password every time.

**Solution**:
```bash
# Use credential helper
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

# For permanent storage
git config --global credential.helper store  # Less secure

# For SSH
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### FZF Not Working

**Problem**: Ctrl+R or Ctrl+T not working in shell.

**Solution**:
```bash
# Reinstall FZF
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# Source in current shell
source ~/.fzf.zsh
```

## Debug Commands

### General System Info
```bash
# Check versions
./verify.sh

# System details
uname -a
cat /etc/os-release
echo $SHELL
echo $TERM
```

### Check Logs
```bash
# Installation log
cat install.log

# Update log
cat update.log

# Neovim log
cat ~/.local/state/nvim/lsp.log
```

### Reset to Defaults
```bash
# Backup current setup
./backup.sh

# Reinstall
./install.sh --force
```

## Getting Help

If none of these solutions work:

1. Check the [GitHub Issues](https://github.com/yourusername/ultimate-linux/issues)
2. Run diagnostic command: `./verify.sh > diagnostic.log 2>&1`
3. Include the following in your issue:
   - Output of `./verify.sh`
   - Your Linux distribution and version
   - Terminal emulator being used
   - Relevant error messages

Remember to always backup before making major changes:
```bash
./backup.sh
```