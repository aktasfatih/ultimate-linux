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
keymap("n", "<leader>nh", ":nohlsearch<CR>", opts)

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

-- TypeScript/JavaScript specific
keymap("n", "<leader>lo", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {"source.organizeImports"},
      diagnostics = {},
    },
  })
end, { desc = "Organize Imports" })

keymap("n", "<leader>lu", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {"source.removeUnused"},
      diagnostics = {},
    },
  })
end, { desc = "Remove Unused Imports" })

-- Toggle format on save
keymap("n", "<leader>tf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  if vim.g.format_on_save then
    vim.notify("Format on save: ENABLED", vim.log.levels.INFO)
  else
    vim.notify("Format on save: DISABLED", vim.log.levels.INFO)
  end
end, { desc = "Toggle Format on Save" })

-- Git keybindings (Diffview)
keymap('n', '<leader>do', ':DiffviewOpen<CR>', { desc = "Open Diffview" })
keymap('n', '<leader>dc', ':DiffviewClose<CR>', { desc = "Close Diffview" })
keymap('n', '<leader>dh', ':DiffviewFileHistory %<CR>', { desc = "File history" })
keymap('n', '<leader>dH', ':DiffviewFileHistory<CR>', { desc = "All file history" })

-- Git keybindings (Fugitive)
keymap('n', '<leader>G', ':Git<CR>', { desc = "Git status" })
keymap('n', '<leader>gP', ':Git push<CR>', { desc = "Git push" })
keymap('n', '<leader>gp', ':Git pull<CR>', { desc = "Git pull" })
keymap('n', '<leader>gB', ':Git blame<CR>', { desc = "Git blame" })
keymap('n', '<leader>gL', ':Git log<CR>', { desc = "Git log" })
keymap('n', '<leader>gl', ':Git log --oneline<CR>', { desc = "Git log (compact)" })
keymap('n', '<leader>gD', ':Gdiffsplit<CR>', { desc = "Diff split" })
keymap('n', '<leader>gH', ':Ghdiffsplit<CR>', { desc = "Horizontal diff" })
keymap('n', '<leader>gV', ':Gvdiffsplit<CR>', { desc = "Vertical diff" })
keymap('n', '<leader>gw', ':Gwrite<CR>', { desc = "Stage current file" })
keymap('n', '<leader>gW', ':Gwrite!<CR>', { desc = "Stage and force write" })
keymap('n', '<leader>gq', ':Git checkout %<CR>', { desc = "Discard changes" })
keymap('n', '<leader>gC', ':Git commit<CR>', { desc = "Commit" })
keymap('n', '<leader>gA', ':Git commit --amend<CR>', { desc = "Amend commit" })
keymap('n', '<leader>gM', ':Git merge<CR>', { desc = "Start merge" })
keymap('n', '<leader>gS', ':Git stash<CR>', { desc = "Stash changes" })
keymap('n', '<leader>gU', ':Git stash pop<CR>', { desc = "Pop stash" })
keymap('n', '<leader>gR', ':Git rebase -i<CR>', { desc = "Interactive rebase" })
keymap('n', '<leader>gF', ':Git fetch<CR>', { desc = "Fetch from remote" })
keymap('n', '<leader>go', ':GBrowse<CR>', { desc = "Open in browser" })
keymap('n', '<leader>gO', ':GBrowse!<CR>', { desc = "Copy URL to clipboard" })

-- Quick git status in vsplit
keymap('n', '<leader>gs', function()
  vim.cmd('Git')
  vim.cmd('wincmd L')  -- Move to right split
end, { desc = "Git status in vsplit" })

-- Git diff variations
keymap('n', '<leader>gdi', ':Git diff<CR>', { desc = "Diff against index" })
keymap('n', '<leader>gdc', ':Git diff --cached<CR>', { desc = "Diff cached/staged" })
keymap('n', '<leader>gdh', ':Git diff HEAD<CR>', { desc = "Diff against HEAD" })

-- Branch operations
keymap('n', '<leader>gbc', ':Git checkout -b ', { desc = "Create branch" })
keymap('n', '<leader>gbd', ':Git branch -d ', { desc = "Delete branch" })
keymap('n', '<leader>gbD', ':Git branch -D ', { desc = "Force delete branch" })
keymap('n', '<leader>gbr', ':Git branch -m ', { desc = "Rename branch" })

-- Conflict resolution helpers
keymap('n', '<leader>gmt', ':Git mergetool<CR>', { desc = "Open mergetool" })
keymap('n', '<leader>gmc', ':Git merge --continue<CR>', { desc = "Continue merge" })
keymap('n', '<leader>gma', ':Git merge --abort<CR>', { desc = "Abort merge" })
keymap('n', '<leader>grc', ':Git rebase --continue<CR>', { desc = "Continue rebase" })
keymap('n', '<leader>gra', ':Git rebase --abort<CR>', { desc = "Abort rebase" })

-- Visual mode mappings for partial staging
keymap('v', '<leader>gs', ':Gwrite<CR>', { desc = "Stage selection" })
keymap('v', '<leader>gr', ':Gread<CR>', { desc = "Revert selection" })

-- Quickfix navigation
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprev<CR>", opts)
keymap("n", "]Q", ":clast<CR>", opts)
keymap("n", "[Q", ":cfirst<CR>", opts)
keymap("n", "<leader>xq", ":cclose<CR>", opts)
keymap("n", "<leader>xo", ":copen<CR>", opts)