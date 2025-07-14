# Ultimate Linux Tools Guide

This guide provides comprehensive documentation for all tools installed by the Ultimate Linux Development Setup. Tools are organized by category and include usage examples.

## Table of Contents

- [Core Shell Tools](#core-shell-tools)
- [Modern CLI Replacements](#modern-cli-replacements)
- [Terminal & Productivity](#terminal--productivity)
- [Development Tools](#development-tools)
- [Git & Version Control](#git--version-control)
- [File Search & Navigation](#file-search--navigation)
- [System Monitoring](#system-monitoring)
- [Language Servers & Formatters](#language-servers--formatters)

## Core Shell Tools

### Zsh with Oh My Zsh
**Purpose**: Advanced shell with powerful features and customization

```bash
# Zsh is your default shell after installation
# Key features configured:
- Auto-suggestions as you type
- Syntax highlighting
- Git branch in prompt
- Thousands of plugins available

# Common Oh My Zsh commands
omz update              # Update Oh My Zsh
omz plugin list         # List all available plugins
omz theme list          # List all available themes
```

### Starship Prompt
**Purpose**: Fast, customizable, cross-shell prompt

```bash
# Configuration file: ~/.config/starship.toml
starship config         # Open config in editor
starship explain        # Explain current prompt
starship timings        # Debug prompt performance

# The prompt shows:
- Current directory
- Git status and branch
- Language versions (Node.js, Python, Rust, etc.)
- Command duration
- Exit code if non-zero
```

## Modern CLI Replacements

### eza (ls replacement)
**Purpose**: Modern, colorful file listing with Git integration

```bash
# Basic usage
eza                     # List files (alias: ls)
eza -la                 # List all files with details (alias: ll)
eza --tree              # Tree view (alias: lt)
eza --git               # Show git status

# Advanced usage
eza --icons             # Show file icons
eza --header            # Show column headers
eza --git-ignore        # Respect .gitignore
eza --color=always      # Force colors
eza --group-directories-first  # Directories first
```

### bat (cat replacement)
**Purpose**: View files with syntax highlighting and line numbers

```bash
# Basic usage
bat file.txt            # View file with syntax highlighting
bat -n file.txt         # Show line numbers
bat -p file.txt         # Plain output (no decorations)

# Advanced usage
bat --theme=Nord file.txt     # Use specific theme
bat --list-themes             # List available themes
bat --diff file1.txt file2.txt  # Show diff
bat --show-all               # Show non-printable characters
bat *.md                     # View multiple files

# Integration with other tools
git show HEAD:file.txt | bat -l txt  # Syntax highlight git output
man bash | bat -l man               # Syntax highlight man pages
```

### ripgrep (grep replacement)
**Purpose**: Ultra-fast recursive search with smart defaults

```bash
# Basic usage
rg "pattern"            # Search for pattern in current directory
rg -i "pattern"         # Case-insensitive search
rg -w "word"            # Match whole words only
rg -F "literal"         # Search for literal string (no regex)

# Advanced usage
rg -t py "import"       # Search only Python files
rg -g "*.js" "console"  # Search files matching glob
rg --hidden "TODO"      # Include hidden files
rg -C 3 "error"         # Show 3 lines of context
rg -l "pattern"         # List only filenames
rg -v "pattern"         # Invert match
rg -z "pattern"         # Search in compressed files

# Integration examples
rg "TODO" | fzf         # Interactive filtering of results
rg -l "pattern" | xargs bat  # View all matching files
```

### fd (find replacement)
**Purpose**: User-friendly file finder with intuitive syntax

```bash
# Basic usage
fd pattern              # Find files/dirs matching pattern
fd -e txt               # Find by extension
fd -t f pattern         # Find only files
fd -t d pattern         # Find only directories

# Advanced usage
fd -H pattern           # Include hidden files
fd -I pattern           # Don't respect .gitignore
fd -d 2 pattern         # Max depth 2
fd -x ls -la            # Execute command on results
fd -E "*.log" pattern   # Exclude files matching glob

# Common patterns
fd "^test.*\.py$"       # Regex: test*.py files
fd -e md -x bat         # View all markdown files
fd -t f -0 | xargs -0 du -h  # Safe handling of filenames
```

## Terminal & Productivity

### tmux (Terminal Multiplexer)
**Purpose**: Multiple terminal sessions in one window

```bash
# Session management
tmux new -s dev         # New session named 'dev'
tmux ls                 # List sessions
tmux attach -t dev      # Attach to session
tmux kill-session -t dev  # Kill session

# Key bindings (Ctrl+a is prefix)
Ctrl+a c                # Create new window
Ctrl+a n/p              # Next/previous window
Ctrl+a 0-9              # Switch to window number
Ctrl+a d                # Detach from session
Ctrl+a |                # Split pane vertically
Ctrl+a -                # Split pane horizontally
Ctrl+a x                # Kill current pane
Ctrl+a z                # Toggle pane zoom
Ctrl+a [                # Enter copy mode (vim bindings)

# Copy mode (vim-like)
v                       # Start selection
y                       # Copy selection
Ctrl+a ]                # Paste

# Session persistence
# tmux sessions survive disconnections - just reattach!
```

### fzf (Fuzzy Finder)
**Purpose**: Interactive fuzzy search for files, commands, and more

```bash
# Basic usage
fzf                     # Interactive file picker
vim $(fzf)              # Open selected file in vim
cd $(fd -t d | fzf)     # Interactive directory navigation

# Key bindings (configured in shell)
Ctrl+r                  # Fuzzy search command history
Ctrl+t                  # Fuzzy file picker (insert path)
Alt+c                   # Fuzzy cd to directory

# Advanced usage
# Preview files while selecting
fzf --preview 'bat --color=always {}'

# Multi-select with Tab
fzf -m | xargs rm       # Select multiple files to delete

# Custom commands
git branch | fzf | xargs git checkout  # Interactive branch switch
ps aux | fzf | awk '{print $2}' | xargs kill  # Interactive process kill
```

### zoxide (cd replacement)
**Purpose**: Smarter directory navigation that learns from your usage

```bash
# Basic usage (after cd-ing to directories a few times)
z proj                  # Jump to most frecent 'proj' directory
z parent child          # Jump using multiple keywords
zi proj                 # Interactive selection with fzf

# Managing database
zoxide query proj       # Show matching directories
zoxide remove /path     # Remove from database
zoxide edit             # Edit database directly

# Integration
# Works automatically - just use 'cd' normally and 'z' for smart jumps
```

## Development Tools

### Neovim
**Purpose**: Hyperextensible text editor with IDE features

```bash
# Basic usage
nvim file.txt           # Open file
nvim .                  # Open file explorer
nvim +10 file.txt       # Open at line 10
nvim -d file1 file2     # Diff mode

# Key features configured:
- LSP support for intelligent code completion
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Git integration with fugitive
- File explorer with neo-tree
- Terminal integration

# Common keybindings
<Space>                 # Leader key
<Space>ff               # Find files
<Space>fg               # Find with grep
<Space>e                # Toggle file explorer
<Space>gg               # Open lazygit
```

### lazygit
**Purpose**: Terminal UI for Git with interactive staging

```bash
# Launch
lazygit                 # Open in current repo
lg                      # Alias for lazygit

# Key bindings
h/l                     # Navigate panels
j/k                     # Navigate items
Space                   # Stage/unstage files
c                       # Commit
p                       # Push
P                       # Pull
b                       # Branch operations
?                       # Show help

# Features:
- Interactive staging of chunks
- Easy rebasing and cherry-picking
- Branch visualization
- Stash management
- Submodule support
```

### pyenv (Python Version Manager)
**Purpose**: Install and manage multiple Python versions

```bash
# List available versions
pyenv install --list    # Show available versions
pyenv versions          # Show installed versions

# Install and use versions
pyenv install 3.11.0    # Install Python 3.11.0
pyenv global 3.11.0     # Set global Python version
pyenv local 3.10.0      # Set project-specific version
pyenv shell 3.9.0       # Set shell-specific version

# Virtual environments
pyenv virtualenv 3.11.0 myproject  # Create virtualenv
pyenv activate myproject           # Activate virtualenv
pyenv deactivate                   # Deactivate
```

### fnm (Fast Node Manager)
**Purpose**: Fast Node.js version management

```bash
# List versions
fnm list                # Show installed versions
fnm list-remote         # Show available versions

# Install and use
fnm install 18          # Install Node.js v18
fnm use 18              # Use Node.js v18
fnm default 18          # Set default version

# Project-specific versions
# Create .node-version or .nvmrc file
echo "18.17.0" > .node-version
# fnm will auto-switch when entering directory
```

### pipx
**Purpose**: Install Python applications in isolated environments

```bash
# Install Python tools globally without conflicts
pipx install black      # Install black formatter
pipx install poetry     # Install poetry
pipx install httpie     # Install httpie

# Manage installations
pipx list               # List installed apps
pipx upgrade black      # Upgrade specific app
pipx upgrade-all        # Upgrade all apps
pipx uninstall black    # Remove app
pipx reinstall-all      # Reinstall all apps
```

## Git & Version Control

### delta
**Purpose**: Beautiful git diffs with syntax highlighting

```bash
# Automatically used by git for:
git diff                # Syntax highlighted diffs
git show                # Syntax highlighted commits
git blame               # Syntax highlighted blame

# Features configured:
- Side-by-side diffs
- Line numbers
- File headers with language info
- Navigate between files with n/N
```

## File Search & Navigation

### File Search Workflow
```bash
# Find and edit files
fd -t f | fzf --preview 'bat {}' | xargs nvim

# Search content and edit
rg -l "pattern" | fzf | xargs nvim

# Interactive grep with preview
rg "TODO" --json | delta

# Find and delete old logs
fd -e log -t f --changed-before 30d -x rm
```

## System Monitoring

### bottom (System Monitor)
**Purpose**: Cross-platform graphical process/system monitor

```bash
# Launch
btm                     # Start bottom
bottom                  # Full command

# Key bindings
h/j/k/l                 # Vim-style navigation
Tab                     # Switch widgets
/                       # Search in process list
dd                      # Kill process
c                       # Sort by CPU
m                       # Sort by memory
n                       # Sort by name
?                       # Help menu

# Command line options
btm -b                  # Basic mode
btm -g                  # Show GPU info
btm --dot-marker        # Use dots in graphs
```

### procs (ps replacement)
**Purpose**: Modern process viewer with human-readable output

```bash
# Basic usage
procs                   # List all processes
procs firefox           # Search for process
procs --tree            # Tree view

# Sorting and filtering
procs --sortd cpu       # Sort by CPU (descending)
procs --sortd mem       # Sort by memory
procs --filter "Idle"   # Filter by state

# Display options
procs --theme auto      # Auto theme based on terminal
procs --pager less      # Use pager for output
procs --watch           # Continuous update mode
```

### dust (du replacement)
**Purpose**: Intuitive disk usage analyzer

```bash
# Basic usage
dust                    # Show disk usage of current dir
dust /home              # Show disk usage of specific dir
dust -n 10              # Show only top 10 items

# Display options
dust -r                 # Reverse sort (smallest first)
dust -d 3               # Max depth 3
dust -X .git            # Exclude .git directories
dust -b                 # Show bytes instead of human-readable
```

### htop (Interactive Process Viewer)
**Purpose**: Interactive process monitoring (server mode only)

```bash
# Launch
htop                    # Start htop

# Key bindings
F1/?                    # Help
F2                      # Setup
F3                      # Search
F4                      # Filter
F5                      # Tree view
F6                      # Sort by column
F9                      # Kill process
F10/q                   # Quit

# Tips:
- Use arrow keys to navigate
- Space to tag processes
- U to untag all
- K to kill tagged processes
```

## Language Servers & Formatters

These tools work automatically in Neovim to provide IDE features:

### Python Development
- **pyright**: Type checking and IntelliSense
- **black**: Opinionated code formatter
- **flake8**: Linting for style and errors

### JavaScript/TypeScript
- **typescript-language-server**: IntelliSense for JS/TS
- **prettier**: Code formatter
- **eslint**: Linter for code quality

### Other Languages
- **rust-analyzer**: Rust IDE features
- **gopls**: Go language server
- **bash-language-server**: Bash script intelligence
- **lua-language-server**: Lua support (for Neovim config)

## Tips & Tricks

### Command Aliases
The setup includes many useful aliases:
```bash
# Git aliases
ga      # git add
gc      # git commit
gp      # git push
gl      # git pull
gst     # git status

# Directory navigation
..      # cd ..
...     # cd ../..
~       # cd ~
-       # cd -

# Common commands
ll      # eza -la
lt      # eza --tree
cat     # bat
find    # fd
grep    # rg
```

### Productivity Workflows

1. **Quick file editing**:
   ```bash
   # Fuzzy find and edit
   nvim $(fzf)
   
   # Search content and edit
   nvim $(rg -l "TODO" | fzf)
   ```

2. **Project navigation**:
   ```bash
   # Jump to project
   z myproject
   
   # Open project in tmux
   tmux new -s myproject -c ~/projects/myproject
   ```

3. **Git workflow**:
   ```bash
   # Interactive git
   lazygit
   
   # Quick commits
   ga . && gc -m "Update" && gp
   ```

4. **System maintenance**:
   ```bash
   # Update everything
   ./update.sh
   
   # Check system resources
   btm
   
   # Find large files
   dust | head -20
   ```

## Customization

All tools can be customized:
- Shell: `~/.zshrc.local` or `~/.bashrc.local`
- Tmux: `~/.tmux.conf.local`
- Neovim: `~/.config/nvim/lua/user/`
- Git: `~/.gitconfig`
- Starship: `~/.config/starship.toml`

Machine-specific configs:
- `~/.zshrc.$(hostname)`
- `~/.bashrc.$(hostname)`