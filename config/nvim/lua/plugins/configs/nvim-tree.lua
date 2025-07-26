-- Nvim-tree Configuration

-- Define highlight groups for NvimTree diagnostic icons
-- These highlight groups must exist before nvim-tree tries to use them
local function define_nvimtree_highlights()
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

-- Define highlights immediately when this config is loaded
define_nvimtree_highlights()

-- Re-define highlights on ColorScheme changes to handle theme switches
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = define_nvimtree_highlights,
  desc = "Define NvimTree diagnostic highlight groups"
})

local nvim_tree = require("nvim-tree")

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