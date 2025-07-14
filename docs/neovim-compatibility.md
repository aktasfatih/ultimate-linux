# Neovim Compatibility Guide

## Neovim 0.9.x Compatibility

Your current Neovim version (0.9.5) is fully supported with some features disabled for compatibility.

### Features Available in 0.9.x
✅ **Core IDE Features**
- LSP support with auto-completion
- Treesitter syntax highlighting
- File explorer (NvimTree)
- Fuzzy finding (Telescope)
- Git integration (Fugitive, Gitsigns)
- Terminal support (Toggleterm)
- Beautiful Catppuccin theme
- Enhanced statusline (Lualine)
- Bufferline for tabs
- Session management
- Smooth scrolling (Neoscroll)

✅ **Development Tools**
- Mason for LSP server management
- None-ls for formatting and linting
- Multiple language support (TypeScript, Python, Rust, Go, etc.)
- Snippets and auto-pairs
- Comment toggling
- Todo comments
- Trouble for diagnostics

### Features Disabled for 0.9.x (Require 0.10+)
❌ **Advanced UI Features**
- `nvim-treesitter-context` - Sticky context headers
- `noice.nvim` - Enhanced command line and messages
- `nvim-navic` - Breadcrumb navigation in winbar
- `lspsaga.nvim` - Beautiful LSP UI enhancements
- `nvim-bqf` - Better quickfix window

### How to Get Full Features

#### Option 1: Upgrade Neovim (Recommended)
```bash
# Run the provided update script
./scripts/update-neovim.sh

# Or manually install latest stable
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```

#### Option 2: Install from Source
```bash
# Build latest Neovim from source
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

#### Option 3: Use AppImage
```bash
# Download latest AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

### Working with 0.9.x

Despite some disabled features, you still have a powerful IDE setup:

1. **First Launch**
   ```vim
   " Install plugins
   :Lazy install
   
   " Install LSP servers
   :Mason
   ```

2. **Key Mappings** (Space is leader)
   - `<leader>ff` - Find files
   - `<leader>fg` - Live grep
   - `<leader>fb` - Browse buffers
   - `<leader>e` - File explorer
   - `K` - Hover documentation
   - `gd` - Go to definition
   - `gr` - Find references
   - `<leader>ca` - Code actions
   - `<leader>f` - Format file

3. **Plugin Management**
   ```vim
   :Lazy sync    " Update plugins
   :Lazy clean   " Remove unused
   :Lazy profile " Check performance
   ```

### Troubleshooting

If you see errors on startup:
1. Run `:Lazy install` to ensure all plugins are installed
2. Run `:Mason` to install language servers
3. Check `:messages` for specific errors
4. Run `./scripts/check-neovim.sh` for diagnostics

### Performance

The configuration is optimized for 0.9.x with:
- Disabled Python/Ruby/Node providers
- Lazy loading of plugins
- Conditional feature loading
- Minimal startup overhead

Your Neovim should start quickly and run smoothly even with the version limitations.