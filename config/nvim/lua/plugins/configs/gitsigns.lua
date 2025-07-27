-- Fixed Gitsigns Configuration
-- This ensures keymaps are always created

local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  vim.notify("Gitsigns not found!", vim.log.levels.ERROR)
  return
end

-- Create a function to set up keymaps
local function setup_gitsigns_keymaps(bufnr)
  local gs = package.loaded.gitsigns
  
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.silent = true
    vim.keymap.set(mode, l, r, opts)
  end
  
  -- Navigation - using simpler approach for better reliability
  map("n", "]c", function()
    if vim.wo.diff then 
      vim.cmd("normal! ]c")
    else
      gs.next_hunk()
    end
  end, { desc = "Next hunk" })
  
  map("n", "[c", function()
    if vim.wo.diff then 
      vim.cmd("normal! [c")
    else
      gs.prev_hunk()
    end
  end, { desc = "Previous hunk" })
  
  -- Actions
  map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
  map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
  map("v", "<leader>hs", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage hunk" })
  map("v", "<leader>hr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset hunk" })
  map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
  map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
  map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
  map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
  map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
  map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
  map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
  map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
  map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
  
  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
end

gitsigns.setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    -- Set up keymaps when Gitsigns attaches to a buffer
    setup_gitsigns_keymaps(bufnr)
    
    -- Also set up buffer-local variable to track attachment
    vim.b[bufnr].gitsigns_attached = true
  end,
})

-- Force immediate setup for current buffer if in a git repo
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("GitSignsKeymaps", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    
    -- Check if we're in a git repository
    if vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';') ~= '' then
      -- Check if gitsigns is attached
      if vim.b[bufnr].gitsigns_attached then
        -- Check if keymaps exist
        local maps = vim.api.nvim_buf_get_keymap(bufnr, 'n')
        local has_next_hunk = false
        for _, map in ipairs(maps) do
          if map.lhs == "]c" then
            has_next_hunk = true
            break
          end
        end
        
        -- If keymaps don't exist, set them up
        if not has_next_hunk then
          setup_gitsigns_keymaps(bufnr)
        end
      end
    end
  end,
})

-- Debug command to check Gitsigns status
vim.api.nvim_create_user_command('GitsignsDebug', function()
  local bufnr = vim.api.nvim_get_current_buf()
  print("Buffer:", bufnr)
  print("Gitsigns attached:", vim.b[bufnr].gitsigns_attached or false)
  print("In git repo:", vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';') ~= '')
  
  local maps = vim.api.nvim_buf_get_keymap(bufnr, 'n')
  local gitsigns_maps = {}
  for _, map in ipairs(maps) do
    if map.lhs == "]c" or map.lhs == "[c" then
      table.insert(gitsigns_maps, map.lhs)
    end
  end
  print("Gitsigns navigation maps:", vim.inspect(gitsigns_maps))
end, {})

-- Return true to indicate successful setup
return true