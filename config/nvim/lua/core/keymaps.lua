-- Core Keymaps

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Window management
keymap("n", "<leader>sv", "<C-w>v", opts) -- split vertical
keymap("n", "<leader>sh", "<C-w>s", opts) -- split horizontal
keymap("n", "<leader>se", "<C-w>=", opts) -- equal width
keymap("n", "<leader>sx", ":close<CR>", opts) -- close window

-- Clear highlights
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Quick save
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- Search and replace
keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", opts)

-- Toggle relative line numbers
keymap("n", "<leader>rn", ":set relativenumber!<CR>", opts)

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)

-- Clipboard operations
keymap("n", "<leader>y", '"+y', opts) -- copy to system clipboard
keymap("v", "<leader>y", '"+y', opts) -- copy to system clipboard
keymap("n", "<leader>Y", '"+Y', opts) -- copy line to system clipboard
keymap("n", "<leader>p", '"+p', opts) -- paste from system clipboard
keymap("n", "<leader>P", '"+P', opts) -- paste before from system clipboard
keymap("v", "<leader>p", '"+p', opts) -- paste from system clipboard

-- Better yank behavior (don't move cursor)
keymap("n", "Y", "y$", opts)