# Ultimate Development Setup

A comprehensive, production-ready dotfiles repository that provides a complete development environment for Linux and macOS systems. This setup includes a modern shell environment, terminal multiplexer, Neovim IDE configuration, and essential development tools.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-zsh-green.svg)
![Editor](https://img.shields.io/badge/editor-neovim-blue.svg)

## 🚀 Quick Start

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/aktasfatih/ultimate-linux/main/install.sh | bash

# Or clone and install
git clone https://github.com/aktasfatih/ultimate-linux.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

## 📋 Prerequisites

### Linux
- Linux-based operating system (Ubuntu, Fedora, Arch, etc.)
- `sudo` access for package installation
- Git (will be installed if not present)

### macOS
- macOS 10.15 (Catalina) or later
- Xcode Command Line Tools (will be installed if not present)
- Homebrew (will be installed if not present)

### Both Platforms
- Internet connection for downloading components
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
- Custom keybindings documentation is available via `<c+s>?`
- Session persistence with tmux-resurrect and continuum
- Mouse support and clipboard integration
- Beautiful status bar with system information

### 📝 Neovim IDE
- Latest Neovim with **lazy.nvim** plugin manager
- LSP support for multiple languages
- Auto-completion, snippets, and formatting
- File explorer, fuzzy finder, git integration
- **GitHub integration** with Octo.nvim (issues, PRs, reviews)
- Treesitter-based syntax highlighting
- Beautiful Catppuccin theme

### 🛠️ Development Tools
- Git with extensive aliases and delta diff viewer
- **GitHub CLI** (`gh`) for repository management
- Language version managers: `fnm` (Node.js), `pyenv` (Python), `rustup` (Rust)
- Docker and docker-compose support
- Comprehensive `.gitignore` templates

## 💻 Platform Support

### Linux Distributions
- **Ubuntu/Debian**: 18.04+
- **Fedora/RHEL/CentOS**: 8+
- **Arch/Manjaro**: Current
- **openSUSE**: Leap 15+
- **Alpine**: 3.12+
- And many more!

### macOS
- **macOS**: 10.15 (Catalina) and later
- **Apple Silicon**: Full native support
- **Intel Macs**: Full support

### Key Differences by Platform
| Feature | Linux | macOS |
|---------|-------|-------|
| Package Manager | apt/yum/pacman/etc. | Homebrew |
| Clipboard | xclip/xsel | pbcopy/pbpaste |
| Font Management | fontconfig | Native |
| System Tools | GNU coreutils | BSD utils |
| Find Command | GNU find (-executable) | BSD find (-perm +111) |

## 📦 What Gets Installed

<details>
<summary><b>🐧 Linux Packages & Tools</b></summary>

### Base Packages
- **Core**: git, curl, wget, build-essential, cmake, unzip, tar, gzip
- **Security**: ca-certificates, gnupg
- **Clipboard**: xclip, xsel (for terminal clipboard integration)

### Shell Environment
- **Zsh**: zsh + Oh My Zsh framework
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Prompt**: Starship cross-shell prompt

### Modern CLI Tools
- **File Operations**: eza (ls replacement), bat (cat replacement)
- **Search**: ripgrep (grep replacement), fd-find (find replacement)
- **Navigation**: fzf (fuzzy finder), zoxide (cd replacement)
- **Git**: delta (diff tool), lazygit (TUI), **gh** (GitHub CLI)
- **System**: dust (du replacement), procs (ps replacement), bottom (htop replacement)

### Development Environment
- **Terminal**: tmux + TPM (plugin manager)
- **Editor**: Neovim (latest) + lazy.nvim plugin manager
- **Languages**: Python 3 (with pip included) + pipx, Node.js + npm
- **Version Managers**: fnm (Node), pyenv (Python), rustup (Rust)

### Language Servers (for Neovim)
- **Python**: pyright, black, flake8
- **JavaScript/TypeScript**: typescript-language-server, prettier, eslint
- **Bash**: bash-language-server
- **Lua**: lua-language-server
- **Rust**: rust-analyzer (if Rust is installed)
- **Go**: gopls (if Go is installed)

### Fonts
- Nerd Fonts: FiraCode, JetBrainsMono, Hack, SourceCodePro

</details>

<details>
<summary><b>🍎 macOS Packages & Tools</b></summary>

### Prerequisites (Auto-installed)
- **Homebrew**: Package manager for macOS
- **Xcode Command Line Tools**: Development essentials

### Base Packages
- **Core**: git, curl, wget, cmake
- **Security**: ca-certificates, gnupg
- **Note**: Built-in tools (tar, unzip, gzip) not installed via Homebrew; No build-essential (Xcode tools handle this), no xclip (uses pbcopy/pbpaste)

### Shell Environment
- **Zsh**: Already included in macOS + Oh My Zsh framework
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Prompt**: Starship cross-shell prompt

### Modern CLI Tools
- **File Operations**: eza (ls replacement), bat (cat replacement)
- **Search**: ripgrep (grep replacement), fd (find replacement)
- **Navigation**: fzf (fuzzy finder), zoxide (cd replacement)
- **Git**: delta (diff tool), lazygit (TUI), **gh** (GitHub CLI)
- **System**: dust (du replacement), procs (ps replacement), bottom (htop replacement)

### Development Environment
- **Terminal**: tmux + TPM (plugin manager)
- **Editor**: Neovim (latest) + lazy.nvim plugin manager
- **Languages**: Python 3 (with pip included) + pipx, Node.js + npm
- **Version Managers**: fnm (Node), pyenv (Python), rustup (Rust)

### Language Servers (for Neovim)
- **Python**: pyright, black, flake8
- **JavaScript/TypeScript**: typescript-language-server, prettier, eslint
- **Bash**: bash-language-server
- **Lua**: lua-language-server
- **Rust**: rust-analyzer (if Rust is installed)
- **Go**: gopls (if Go is installed)

### Fonts
- Nerd Fonts: FiraCode, JetBrainsMono, Hack, SourceCodePro
- **Note**: Fonts installed to `~/.local/share/fonts` (works with macOS font system)

</details>

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

# GitHub CLI authentication (for Octo.nvim)
gh auth login

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

### GitHub Integration (Octo.nvim)
- **List issues**: `<leader>oi`
- **List PRs**: `<leader>opr`
- **Create PR**: `<leader>oprc`
- **List repos**: `<leader>ore`
- Note: Requires `gh auth login` after installation

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

## 🍎 macOS-Specific Notes

1. **Homebrew Installation**: The installer will automatically install Homebrew if it's not present.

2. **Xcode Command Line Tools**: Required for compilation. The installer will prompt you to install them if needed.

3. **Font Installation**: After installation, manually install Nerd Fonts:
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-fira-code-nerd-font
   ```

4. **Terminal App**: For best results, use [iTerm2](https://iterm2.com/) or [Alacritty](https://alacritty.org/) instead of Terminal.app.

5. **System Integrity Protection**: Some features may require disabling SIP for full functionality (not recommended for most users).

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

---

Made with ❤️ for the Linux development community
