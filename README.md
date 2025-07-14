# Ultimate Linux Development Setup

A comprehensive, production-ready dotfiles repository that provides a complete development environment for Linux systems. This setup includes a modern shell environment, terminal multiplexer, Neovim IDE configuration, and essential development tools.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-zsh-green.svg)
![Editor](https://img.shields.io/badge/editor-neovim-blue.svg)

## 🚀 Quick Start

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/yourusername/ultimate-linux/main/install.sh | bash

# Or clone and install
git clone https://github.com/yourusername/ultimate-linux.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

## 📋 Prerequisites

- Linux-based operating system (Ubuntu, Fedora, Arch, etc.)
- `sudo` access for package installation
- Internet connection for downloading components
- Git (will be installed if not present)
- At least 1GB of free disk space

## ✨ Features

### 🐚 Shell Environment
- **Zsh** with **Oh My Zsh** framework
- **Starship** cross-shell prompt with git integration
- Powerful plugins: autosuggestions, syntax highlighting, completions
- Modern CLI tools: `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`
- Extensive aliases and custom functions

### 🖥️ Terminal Multiplexer
- **tmux** with sensible defaults
- Custom keybindings (prefix: `Ctrl+Space`)
- Session persistence with tmux-resurrect and continuum
- Mouse support and clipboard integration
- Beautiful status bar with system information

### 📝 Neovim IDE
- Latest Neovim with **lazy.nvim** plugin manager
- LSP support for multiple languages
- Auto-completion, snippets, and formatting
- File explorer, fuzzy finder, git integration
- Treesitter-based syntax highlighting
- Beautiful Catppuccin theme

### 🛠️ Development Tools
- Git with extensive aliases and delta diff viewer
- Language version managers: `fnm` (Node.js), `pyenv` (Python), `rustup` (Rust)
- Docker and docker-compose support
- Comprehensive `.gitignore` templates

## 📦 Installation

### Full Installation (Recommended)
```bash
./install.sh
```

### Installation Options
```bash
./install.sh --help              # Show all options
./install.sh --minimal           # Basic setup (shell + git only)
./install.sh --server            # Server setup (no GUI dependencies)
./install.sh --dev-only          # Development tools only
./install.sh --dry-run           # Preview without installing
./install.sh --force             # Overwrite existing configs
./install.sh --non-interactive   # Automated installation
```

## 🔧 Configuration

### Personal Settings
After installation, update your personal information:

```bash
# Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Local overrides (optional)
touch ~/.zshrc.local      # Shell customizations
touch ~/.tmux.conf.local  # tmux customizations
```

### Machine-Specific Configuration
Create machine-specific configs:
```bash
touch ~/.zshrc.$(hostname)  # Loaded automatically
```

## ⌨️ Key Bindings

### tmux
- **Prefix**: `Ctrl+Space`
- **Split horizontal**: `Prefix + |`
- **Split vertical**: `Prefix + -`
- **Navigate panes**: `Prefix + h/j/k/l`
- **Resize panes**: `Prefix + H/J/K/L`
- **New window**: `Prefix + c`
- **Navigate windows**: `Prefix + number` or `Ctrl+h/l`

### Neovim
- **Leader**: `Space`
- **File explorer**: `<leader>e`
- **Find files**: `<leader>ff`
- **Live grep**: `<leader>fg`
- **Buffer list**: `<leader>fb`
- **Save file**: `<leader>w`
- **Close buffer**: `<leader>bd`

See [docs/KEYBINDINGS.md](docs/KEYBINDINGS.md) for complete reference.

## 🔄 Maintenance

### Update Everything
```bash
./update.sh
```

### Backup Current Setup
```bash
./backup.sh
```

### Verify Installation
```bash
./verify.sh
```

### Uninstall
```bash
./uninstall.sh
```

## 📁 Repository Structure

```
ultimate-linux/
├── install.sh              # Main installation script
├── update.sh               # Update existing setup
├── backup.sh               # Backup current configs
├── uninstall.sh            # Clean removal script
├── verify.sh               # Test installation
├── config/                 # Configuration files
│   ├── zsh/                # Zsh configuration
│   ├── tmux/               # tmux configuration
│   ├── nvim/               # Neovim configuration
│   └── git/                # Git configuration
├── scripts/                # Utility scripts
├── docs/                   # Documentation
└── themes/                 # Color schemes
```

## 🐛 Troubleshooting

### Common Issues

1. **Fonts not displaying correctly**
   ```bash
   fc-cache -fv ~/.local/share/fonts
   ```

2. **tmux plugins not loading**
   ```bash
   # Inside tmux: Prefix + I
   ~/.tmux/plugins/tpm/bin/install_plugins
   ```

3. **Neovim plugins not installing**
   ```bash
   nvim --headless "+Lazy! sync" +qa
   ```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more solutions.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) for the amazing Zsh framework
- [Neovim](https://neovim.io/) community for the excellent editor
- [tmux](https://github.com/tmux/tmux) for the terminal multiplexer
- All the plugin and tool authors that make this setup possible

## 📸 Screenshots

### Shell Environment
![Shell](docs/images/shell.png)

### Neovim IDE
![Neovim](docs/images/neovim.png)

### tmux Session
![tmux](docs/images/tmux.png)

---

Made with ❤️ for the Linux development community