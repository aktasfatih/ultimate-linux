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
    vim.keymap.set(mode, l, r, opts)
  end
  
  -- Navigation
  map("n", "]c", function()
    if vim.wo.diff then return "]c" end
    vim.schedule(function() gs.next_hunk() end)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })
  
  map("n", "[c", function()
    if vim.wo.diff then return "[c" end
    vim.schedule(function() gs.prev_hunk() end)
    return "<Ignore>"
  end, { expr = true, desc = "Previous hunk" })
  
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
  end,
})

-- Also set up autocmd as backup
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
  callback = function()
    local ok, gs = pcall(require, 'gitsigns')
    if ok and vim.fn.finddir('.git', vim.fn.expand('%:p:h') .. ';') ~= '' then
      -- Only set up keymaps if not already set
      local maps = vim.api.nvim_buf_get_keymap(0, 'n')
      local has_gitsigns_maps = false
      for _, map in ipairs(maps) do
        if map.lhs:match("<leader>hp") then
          has_gitsigns_maps = true
          break
        end
      end
      
      if not has_gitsigns_maps and vim.b.gitsigns_attached then
        setup_gitsigns_keymaps(0)
      end
    end
  end,
})

-- Return true to indicate successful setup
return true