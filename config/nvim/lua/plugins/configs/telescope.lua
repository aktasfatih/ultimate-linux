-- Telescope Configuration

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = { ".git/", "node_modules/", "target/", "dist/", "build/" },
    
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = true,
    },
    live_grep = {
      theme = "ivy",
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      initial_mode = "normal",
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<A-c>"] = telescope.extensions.file_browser.actions.create,
          ["<A-r>"] = telescope.extensions.file_browser.actions.rename,
          ["<A-m>"] = telescope.extensions.file_browser.actions.move,
          ["<A-y>"] = telescope.extensions.file_browser.actions.copy,
          ["<A-d>"] = telescope.extensions.file_browser.actions.remove,
          ["<C-o>"] = telescope.extensions.file_browser.actions.open,
          ["<C-g>"] = telescope.extensions.file_browser.actions.goto_parent_dir,
          ["<C-e>"] = telescope.extensions.file_browser.actions.goto_home_dir,
          ["<C-w>"] = telescope.extensions.file_browser.actions.goto_cwd,
          ["<C-t>"] = telescope.extensions.file_browser.actions.change_cwd,
          ["<C-h>"] = telescope.extensions.file_browser.actions.toggle_hidden,
        },
        ["n"] = {
          ["c"] = telescope.extensions.file_browser.actions.create,
          ["r"] = telescope.extensions.file_browser.actions.rename,
          ["m"] = telescope.extensions.file_browser.actions.move,
          ["y"] = telescope.extensions.file_browser.actions.copy,
          ["d"] = telescope.extensions.file_browser.actions.remove,
          ["o"] = telescope.extensions.file_browser.actions.open,
          ["g"] = telescope.extensions.file_browser.actions.goto_parent_dir,
          ["e"] = telescope.extensions.file_browser.actions.goto_home_dir,
          ["w"] = telescope.extensions.file_browser.actions.goto_cwd,
          ["t"] = telescope.extensions.file_browser.actions.change_cwd,
          ["h"] = telescope.extensions.file_browser.actions.toggle_hidden,
        },
      },
    },
  },
})

-- Load extensions
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- File pickers
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", opts)

-- Git pickers
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)

-- LSP pickers
keymap("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", opts)
keymap("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", opts)
keymap("n", "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)

-- Other pickers
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", opts)
keymap("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts)
keymap("n", "<leader>fm", "<cmd>Telescope marks<cr>", opts)