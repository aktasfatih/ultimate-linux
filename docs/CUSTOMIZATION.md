# Customization Guide

This guide explains how to customize the Ultimate Linux Development Setup to match your preferences and workflow.

## Table of Contents
- [Configuration Files](#configuration-files)
- [Shell Customization](#shell-customization)
- [tmux Customization](#tmux-customization)
- [Neovim Customization](#neovim-customization)
- [Theme Customization](#theme-customization)
- [Adding New Tools](#adding-new-tools)

## Configuration Files

### Local Overrides

The setup supports local configuration files that won't be overwritten by updates:

```bash
~/.zshrc.local          # Shell customizations
~/.tmux.conf.local      # tmux customizations
~/.config/nvim/lua/user/  # Neovim customizations
```

### Machine-Specific Configuration

Create machine-specific configurations that load automatically:

```bash
# Shell config for specific hostname
~/.zshrc.$(hostname)

# Example: ~/.zshrc.workstation
export WORK_SPECIFIC_VAR="value"
alias work="cd ~/work/projects"
```

## Shell Customization

### Adding Custom Aliases

Create or edit `~/.zshrc.local`:

```bash
# Custom aliases
alias projects="cd ~/projects"
alias serve="python -m http.server"
alias myip="curl -s https://api.ipify.org"

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Project-specific aliases
alias myproject="cd ~/work/myproject && code ."
```

### Changing the Prompt

To use a different prompt theme:

```bash
# In ~/.zshrc.local

# Disable starship
unset STARSHIP_CONFIG

# Use Oh My Zsh theme
ZSH_THEME="agnoster"  # or any other theme

# Or use custom prompt
PS1='%F{blue}%n@%m%f:%F{yellow}%~%f$ '
```

### Adding Zsh Plugins

```bash
# Clone new plugin
git clone https://github.com/some/plugin ~/.oh-my-zsh/custom/plugins/plugin-name

# Add to ~/.zshrc
plugins=(
    # ... existing plugins ...
    plugin-name
)
```

### Environment Variables

Add to `~/.zshenv` or `~/.zshrc.local`:

```bash
# Development
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
export ANDROID_HOME="$HOME/Android/Sdk"
export GOPATH="$HOME/go"

# Custom paths
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
```

## tmux Customization

### Custom Key Bindings

Create `~/.tmux.conf.local`:

```bash
# Change prefix key
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Custom split bindings
bind v split-window -h
bind s split-window -v

# Quick window switching
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
```

### Status Bar Customization

```bash
# Simple status bar
set -g status-left '[#S] '
set -g status-right '%H:%M %d-%b-%y'

# Custom colors
set -g status-style 'bg=black fg=white'
set -g window-status-current-style 'bg=blue fg=black'
```

### Adding tmux Plugins

```bash
# In ~/.tmux.conf.local
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-cpu'

# Install with Prefix + I
```

## Neovim Customization

### Adding Custom Plugins

Create `~/.config/nvim/lua/user/plugins.lua`:

```lua
return {
  -- Add your custom plugins here
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
  
  -- Override existing plugin config
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          flex = {
            flip_columns = 140,
          },
        },
      },
    },
  },
}
```

### Custom Keymaps

Create `~/.config/nvim/lua/user/keymaps.lua`:

```lua
local keymap = vim.keymap.set

-- Custom mappings
keymap("n", "<leader>pp", ":Telescope projects<CR>")
keymap("n", "<leader>gg", ":LazyGit<CR>")
keymap("n", "<C-p>", ":Telescope find_files<CR>")

-- Override existing mappings
keymap("n", "<leader>w", ":w!<CR>")  -- Force save
```

### LSP Configuration

Create `~/.config/nvim/lua/user/lsp.lua`:

```lua
-- Custom LSP settings
return {
  servers = {
    -- Add custom servers
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
    
    -- Custom Python setup
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "strict",
          },
        },
      },
    },
  },
}
```

### Custom Options

Create `~/.config/nvim/lua/user/options.lua`:

```lua
-- Override default options
vim.opt.relativenumber = false
vim.opt.colorcolumn = "80,120"
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Custom variables
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
```

## Theme Customization

### Shell Theme

```bash
# In ~/.zshrc.local

# Custom colors for ls
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34'

# Custom syntax highlighting colors
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
```

### tmux Theme

```bash
# In ~/.tmux.conf.local

# Catppuccin theme
set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_flavour 'mocha'

# Or custom theme
source-file ~/.config/tmux/mytheme.conf
```

### Neovim Theme

```lua
-- In ~/.config/nvim/lua/user/plugins.lua
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
```

## Adding New Tools

### Creating Install Hooks

Add to `~/.zshrc.local`:

```bash
# Install function for custom tools
install_my_tools() {
    # Install tool via script
    curl -fsSL https://example.com/install.sh | bash
    
    # Or via git
    git clone https://github.com/user/tool ~/.local/tools/tool
    ln -sf ~/.local/tools/tool/bin/tool ~/.local/bin/
}

# Auto-install check
if ! command -v mytool &> /dev/null; then
    echo "Installing mytool..."
    install_my_tools
fi
```

### Package Lists

Create `~/.config/dotfiles/packages.txt`:

```
# Additional packages to install
httpie
jq
tldr
ncdu
glances
```

Install with:
```bash
cat ~/.config/dotfiles/packages.txt | grep -v '^#' | xargs sudo apt install -y
```

### Custom Scripts

Add scripts to `~/bin/` or `~/.local/bin/`:

```bash
#!/usr/bin/env bash
# ~/.local/bin/update-all

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Updating Flatpaks..."
flatpak update -y

echo "Updating snaps..."
sudo snap refresh

echo "Updating dotfiles..."
cd ~/.dotfiles && ./update.sh
```

## Advanced Customization

### Conditional Configuration

```bash
# In ~/.zshrc.local

# Work laptop specific
if [[ $(hostname) == "work-laptop" ]]; then
    export GIT_AUTHOR_EMAIL="work@company.com"
    source ~/.work-secrets
fi

# WSL specific
if [[ $(grep -i microsoft /proc/version) ]]; then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi
```

### Plugin Development

Create custom Zsh plugin:

```bash
# ~/.oh-my-zsh/custom/plugins/myplugin/myplugin.plugin.zsh

# Plugin code
myplugin_function() {
    echo "My custom plugin function"
}

# Aliases
alias mp="myplugin_function"

# Completions
_myplugin_completion() {
    # Completion logic
}

compdef _myplugin_completion myplugin_function
```

### Neovim Plugin Development

```lua
-- ~/.config/nvim/lua/myplugin/init.lua

local M = {}

M.setup = function(opts)
    opts = opts or {}
    
    -- Plugin logic
    vim.api.nvim_create_user_command("MyCommand", function()
        print("My custom command")
    end, {})
end

return M
```

## Best Practices

1. **Keep customizations modular**: Use separate files for different aspects
2. **Document your changes**: Add comments explaining custom configs
3. **Version control**: Keep your customizations in a separate git repository
4. **Test before committing**: Ensure customizations work across your systems
5. **Regular backups**: Use `./backup.sh` before major changes

## Sharing Customizations

Create a personal overlay repository:

```bash
# Structure
my-dotfiles-overlay/
├── install.sh
├── shell/
│   └── .zshrc.local
├── tmux/
│   └── .tmux.conf.local
└── nvim/
    └── lua/user/

# Install script
#!/bin/bash
ln -sf $(pwd)/shell/.zshrc.local ~/.zshrc.local
ln -sf $(pwd)/tmux/.tmux.conf.local ~/.tmux.conf.local
ln -sf $(pwd)/nvim/lua/user ~/.config/nvim/lua/
```

This allows you to maintain personal customizations while still benefiting from updates to the base configuration.