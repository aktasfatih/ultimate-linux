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

-- Toggle word wrap
keymap("n", "<leader>tw", ":set wrap!<CR>", opts)

-- Enhanced navigation
keymap("n", "<leader>mr", "<C-w>L", opts) -- Move to rightmost split
keymap("n", "<leader>ml", "<C-w>H", opts) -- Move to leftmost split
keymap("n", "<leader>mt", "<C-w>K", opts) -- Move to top split
keymap("n", "<leader>mb", "<C-w>J", opts) -- Move to bottom split

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

-- Enhanced file opening (gf variants)
keymap("n", "gf", "<cmd>edit <cfile><CR>", { desc = "Go to file" })
keymap("n", "gF", "<cmd>edit <cfile><CR>", { desc = "Go to file" })
keymap("n", "<leader>gf", "<cmd>vsplit <cfile><CR>", { desc = "Go to file in vertical split" })
keymap("n", "<leader>gF", "<cmd>split <cfile><CR>", { desc = "Go to file in horizontal split" })
keymap("n", "<leader>gt", "<cmd>tabedit <cfile><CR>", { desc = "Go to file in new tab" })

-- Interactive file opener
keymap("n", "<leader>go", function()
  local file = vim.fn.expand("<cfile>")
  if file == "" then
    print("No file under cursor")
    return
  end
  
  local choices = {
    "1. Open in current window",
    "2. Open in vertical split", 
    "3. Open in horizontal split",
    "4. Open in new tab"
  }
  
  local choice = vim.fn.inputlist(vim.list_extend({"How to open '" .. file .. "':"}, choices))
  
  if choice == 1 then
    vim.cmd("edit " .. file)
  elseif choice == 2 then
    vim.cmd("vsplit " .. file)
  elseif choice == 3 then
    vim.cmd("split " .. file)
  elseif choice == 4 then
    vim.cmd("tabedit " .. file)
  end
end, { desc = "Go to file with options" })

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

-- Toggle semantic highlighting
keymap("n", "<leader>ts", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.server_capabilities.semanticTokensProvider then
      if vim.lsp.semantic_tokens.get_client(0) then
        vim.lsp.semantic_tokens.stop(0, client.id)
        vim.notify("Semantic highlighting: DISABLED", vim.log.levels.INFO)
      else
        vim.lsp.semantic_tokens.start(0, client.id)
        vim.notify("Semantic highlighting: ENABLED", vim.log.levels.INFO)
      end
      break
    end
  end
end, { desc = "Toggle Semantic Highlighting" })

-- Git keybindings (Diffview)
keymap('n', '<leader>do', ':DiffviewOpen<CR>', { desc = "Open Diffview" })
keymap('n', '<leader>dc', ':DiffviewClose<CR>', { desc = "Close Diffview" })
keymap('n', '<leader>dm', function()
  -- Get merge base with origin/main (or main if origin/main doesn't exist)
  local merge_base_cmd = "git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null || echo 'HEAD~1'"
  local merge_base = vim.fn.system(merge_base_cmd):gsub("%s+", "")
  
  if merge_base and merge_base ~= "" then
    vim.cmd("DiffviewOpen " .. merge_base .. "..HEAD")
  else
    print("Could not determine merge base. Using HEAD~1")
    vim.cmd("DiffviewOpen HEAD~1..HEAD")
  end
end, { desc = "Diffview: your changes vs main" })
keymap('n', '<leader>db', function()
  -- Compare with specific branch
  local branch = vim.fn.input("Compare with branch: ", "origin/main")
  if branch and branch ~= "" then
    local merge_base = vim.fn.system("git merge-base HEAD " .. branch):gsub("%s+", "")
    if merge_base and merge_base ~= "" then
      vim.cmd("DiffviewOpen " .. merge_base .. "..HEAD")
    else
      print("Could not find merge base with " .. branch)
    end
  end
end, { desc = "Diffview: your changes vs branch" })
keymap('n', '<leader>ds', ':DiffviewOpen --staged<CR>', { desc = "Diffview: staged changes" })
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

-- Octo.nvim (GitHub integration)
keymap("n", "<leader>oi", ":Octo issue list<CR>", { desc = "List issues" })
keymap("n", "<leader>oic", ":Octo issue create<CR>", { desc = "Create issue" })
keymap("n", "<leader>ois", ":Octo issue search<CR>", { desc = "Search issues" })
keymap("n", "<leader>opr", ":Octo pr list<CR>", { desc = "List pull requests" })
keymap("n", "<leader>oprc", ":Octo pr create<CR>", { desc = "Create pull request" })
keymap("n", "<leader>oprs", ":Octo pr search<CR>", { desc = "Search pull requests" })
keymap("n", "<leader>oprv", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
  if branch ~= "" then
    -- First try to find the PR for this branch
    local pr_output = vim.fn.system("gh pr list --head=" .. branch .. " --json number --jq '.[0].number'")
    local pr_number = pr_output:gsub("%s+", "")
    
    if pr_number ~= "" and pr_number ~= "null" then
      -- Open the specific PR
      vim.cmd("Octo pr edit " .. pr_number)
    else
      -- Fallback to review mode or create PR prompt
      print("No PR found for branch '" .. branch .. "'. Use <leader>oprc to create one or <leader>opr to list all PRs.")
    end
  else
    print("Not in a git repository or no current branch")
  end
end, { desc = "View PR for current branch" })
keymap("n", "<leader>oprr", ":Octo review<CR>", { desc = "Enter PR review mode" })
keymap("n", "<leader>ore", ":Octo repo list<CR>", { desc = "List repositories" })
keymap("n", "<leader>orv", ":Octo repo view<CR>", { desc = "View repository" })
keymap("n", "<leader>orf", ":Octo repo fork<CR>", { desc = "Fork repository" })
keymap("n", "<leader>ogs", ":Octo gist list<CR>", { desc = "List gists" })
keymap("n", "<leader>ogc", ":Octo gist create<CR>", { desc = "Create gist" })

-- Debugging (DAP)
keymap("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Start/Continue" })
keymap("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: Step Over" })
keymap("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: Step Into" })
keymap("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: Step Out" })
keymap("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
keymap("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Conditional Breakpoint" })
keymap("n", "<leader>dp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Log Point" })
keymap("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
keymap("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last Debug Config" })
keymap("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate Debug Session" })

-- Debug UI
keymap("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle Debug UI" })
keymap("n", "<leader>de", function() require("dapui").eval() end, { desc = "Evaluate Expression" })
keymap("v", "<leader>de", function() require("dapui").eval() end, { desc = "Evaluate Selection" })

-- Telescope DAP integration
keymap("n", "<leader>dfc", function() require("telescope").extensions.dap.configurations() end, { desc = "Debug Configurations" })
keymap("n", "<leader>dfb", function() require("telescope").extensions.dap.list_breakpoints() end, { desc = "List Breakpoints" })
keymap("n", "<leader>dfv", function() require("telescope").extensions.dap.variables() end, { desc = "Debug Variables" })
keymap("n", "<leader>dff", function() require("telescope").extensions.dap.frames() end, { desc = "Debug Frames" })

-- Language-specific debug keybindings (set via autocmd)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>dgt", function()
      require("dap-go").debug_test()
    end, { desc = "Debug Go Test", buffer = true })
    vim.keymap.set("n", "<leader>dgl", function()
      require("dap-go").debug_last_test()
    end, { desc = "Debug Last Go Test", buffer = true })
  end,
})