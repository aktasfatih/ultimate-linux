-- Core Options

local opt = vim.opt

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
opt.lazyredraw = true

-- Neovim specific
opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Clipboard configuration
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