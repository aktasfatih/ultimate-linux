-- Nvim-tree Configuration

-- Define highlight groups and signs for NvimTree diagnostic icons
-- These must exist before nvim-tree tries to use them
local function define_nvimtree_diagnostics()
  -- Define the diagnostic signs that nvim-tree expects
  vim.fn.sign_define("NvimTreeDiagnosticErrorIcon", { text = "", texthl = "DiagnosticError" })
  vim.fn.sign_define("NvimTreeDiagnosticWarnIcon", { text = "", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("NvimTreeDiagnosticInfoIcon", { text = "", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("NvimTreeDiagnosticHintIcon", { text = "", texthl = "DiagnosticHint" })
  
  -- Link the icon highlight groups to diagnostic highlight groups
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorIcon", { link = "DiagnosticError" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnIcon", { link = "DiagnosticWarn" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticInfoIcon", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticHintIcon", { link = "DiagnosticHint" })
  
  -- Also define the file and folder highlight groups
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFileHL", { link = "DiagnosticError" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFileHL", { link = "DiagnosticWarn" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticInfoFileHL", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticHintFileHL", { link = "DiagnosticHint" })
  
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticErrorFolderHL", { link = "DiagnosticError" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticWarnFolderHL", { link = "DiagnosticWarn" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticInfoFolderHL", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "NvimTreeDiagnosticHintFolderHL", { link = "DiagnosticHint" })
end

-- Define diagnostics immediately when this config is loaded
define_nvimtree_diagnostics()

-- Re-define diagnostics on ColorScheme changes to handle theme switches
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = define_nvimtree_diagnostics,
  desc = "Define NvimTree diagnostic signs and highlight groups"
})

-- Also re-define on any sign_unplace event that might clear our signs
vim.api.nvim_create_autocmd({"BufEnter", "FileType", "VimEnter"}, {
  callback = function()
    -- Check if our signs still exist
    local signs = vim.fn.sign_getdefined("NvimTreeDiagnosticHintIcon")
    if vim.tbl_isempty(signs) then
      define_nvimtree_diagnostics()
    end
  end,
  desc = "Ensure NvimTree diagnostic signs are defined"
})

-- Ensure signs are defined before nvim-tree setup
vim.defer_fn(function()
  define_nvimtree_diagnostics()
end, 10)

local nvim_tree = require("nvim-tree")

-- Final check before setup
define_nvimtree_diagnostics()

nvim_tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = { ".git", "node_modules", ".cache" },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  view = {
    width = 30,
    side = "left",
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  renderer = {
    icons = {
      webdev_colors = true,
      git_placement = "before",
      diagnostics_placement = "signcolumn",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        diagnostics = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

-- Ensure NvimTree buffers are not modifiable
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.opt_local.modifiable = false
  end,
  desc = "Make NvimTree buffers non-modifiable"
})

-- Add a safety wrapper to prevent sign errors
local original_error = vim.api.nvim_err_write
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    -- Temporarily suppress sign errors and re-define signs if needed
    vim.api.nvim_err_write = function(msg)
      if msg:match("Unknown sign: NvimTreeDiagnostic") then
        define_nvimtree_diagnostics()
        return
      end
      original_error(msg)
    end
    
    -- Restore original error handler after a short delay
    vim.defer_fn(function()
      vim.api.nvim_err_write = original_error
    end, 100)
  end,
  desc = "Handle NvimTree sign errors on save"
})