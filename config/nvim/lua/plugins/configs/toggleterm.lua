-- ToggleTerm Configuration

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  winbar = {
    enabled = false,
    name_formatter = function(term)
      return term.name
    end,
  },
})

-- Terminal keymaps
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  -- Check if this is lazygit and skip escape mapping
  local bufname = vim.api.nvim_buf_get_name(0)
  if not string.match(bufname, "lazygit") then
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  end
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Custom terminals
local Terminal = require("toggleterm.terminal").Terminal

-- Lazygit
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

-- Node
local node = Terminal:new({ cmd = "node", hidden = true })

function _NODE_TOGGLE()
  node:toggle()
end

-- NCDU
local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

function _NCDU_TOGGLE()
  ncdu:toggle()
end

-- Htop
local htop = Terminal:new({ cmd = "htop", hidden = true })

function _HTOP_TOGGLE()
  htop:toggle()
end

-- Python
local python = Terminal:new({ cmd = "python3", hidden = true })

function _PYTHON_TOGGLE()
  python:toggle()
end

-- Keymaps
vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })