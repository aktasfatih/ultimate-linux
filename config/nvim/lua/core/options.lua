-- Core Options

local opt = vim.opt

-- Performance mode (disabled - use full features even on remote servers)
vim.g.performance_mode = false

-- General
opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.hidden = true
opt.iskeyword:append("-")
opt.mouse = "a"
opt.pumheight = 10
opt.showmode = false
opt.showtabline = 2
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 300
opt.writebackup = false

-- UI
opt.cursorline = true
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.guifont = "FiraCode Nerd Font:h12"
opt.fillchars = { eob = " " }

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Performance
opt.lazyredraw = false -- Disabled for Noice compatibility
opt.updatetime = 300
opt.timeoutlen = 300
opt.redrawtime = 1500  -- Reduce redraw time
opt.ttimeoutlen = 10   -- Reduce keycode delay
opt.lazyredraw = false

-- Neovim specific
opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Clipboard configuration
local function is_ssh()
  return vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
end

local function has_display()
  return vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= ""
end

if vim.fn.has('mac') == 1 then
  -- macOS clipboard
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 1,
  }
elseif is_ssh() or not has_display() then
  -- SSH or no display - use OSC52 for clipboard
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
else
  -- Linux with display - use xclip
  vim.g.clipboard = {
    name = 'ultimate-linux-clipboard',
    copy = {
      ['+'] = {'xclip', '-selection', 'clipboard'},
      ['*'] = {'xclip', '-selection', 'primary'},
    },
    paste = {
      ['+'] = {'xclip', '-selection', 'clipboard', '-o'},
      ['*'] = {'xclip', '-selection', 'primary', '-o'},
    },
    cache_enabled = 1,
  }
end