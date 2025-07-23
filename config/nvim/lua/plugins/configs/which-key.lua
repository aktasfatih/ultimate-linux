-- Which-key Configuration

local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  operators = { gc = "Comments" },
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = false,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = true,
  show_keys = true,
  triggers = "auto",
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
})

-- Keymaps
local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>q!<CR>", "Quit" },
  ["Q"] = { "<cmd>qa!<CR>", "Quit All" },
  ["h"] = { "<cmd>nohlsearch<CR>", "Clear Highlight" },
  ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
  ["r"] = { "<cmd>Telescope oldfiles<CR>", "Recent Files" },
  ["n"] = { "<cmd>enew<CR>", "New File" },
  
  b = {
    name = "Buffers",
    b = { "<cmd>Telescope buffers<CR>", "List Buffers" },
    d = { "<cmd>bdelete<CR>", "Delete Buffer" },
    f = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Find in Buffer" },
    n = { "<cmd>bnext<CR>", "Next Buffer" },
    p = { "<cmd>bprevious<CR>", "Previous Buffer" },
    P = { "<cmd>BufferLineTogglePin<CR>", "Pin Buffer" },
    o = { "<cmd>BufferLineCloseOthers<CR>", "Close Others" },
    r = { "<cmd>BufferLineCloseRight<CR>", "Close Right" },
    l = { "<cmd>BufferLineCloseLeft<CR>", "Close Left" },
    s = { "<cmd>BufferLineSortByDirectory<CR>", "Sort by Directory" },
  },
  
  f = {
    name = "Find",
    f = { "<cmd>Telescope find_files<CR>", "Find Files" },
    g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
    h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
    c = { "<cmd>Telescope commands<CR>", "Commands" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    r = { "<cmd>Telescope registers<CR>", "Registers" },
    m = { "<cmd>Telescope marks<CR>", "Marks" },
    o = { "<cmd>Telescope oldfiles<CR>", "Recent Files" },
    e = { "<cmd>Telescope file_browser<CR>", "File Browser" },
  },
  
  g = {
    name = "Git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<CR>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
    u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", "Undo Stage Hunk" },
    o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
    d = { "<cmd>Gitsigns diffthis HEAD<CR>", "Diff" },
  },
  
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
    d = { "<cmd>Telescope lsp_document_diagnostics<CR>", "Document Diagnostics" },
    w = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
    f = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format" },
    i = { "<cmd>LspInfo<CR>", "Info" },
    I = { "<cmd>Mason<CR>", "Mason Info" },
    j = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic" },
    l = { "<cmd>lua vim.lsp.codelens.run()<CR>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace Symbols" },
    R = { "<cmd>Telescope lsp_references<CR>", "References" },
  },
  
  s = {
    name = "Search",
    c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
    h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
    M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
    R = { "<cmd>Telescope registers<CR>", "Registers" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    C = { "<cmd>Telescope commands<CR>", "Commands" },
  },
  
  t = {
    name = "Terminal",
    n = { "<cmd>lua _NODE_TOGGLE()<CR>", "Node" },
    u = { "<cmd>lua _NCDU_TOGGLE()<CR>", "NCDU" },
    t = { "<cmd>lua _HTOP_TOGGLE()<CR>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<CR>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
  },
  
  T = {
    name = "Treesitter",
    i = { "<cmd>TSInstallInfo<CR>", "Install Info" },
    u = { "<cmd>TSUpdate<CR>", "Update" },
    s = { "<cmd>TSSync<CR>", "Sync" },
  },
  
  c = {
    name = "Claude",
    c = { "<cmd>ClaudeCode<CR>", "Toggle Claude Code" },
    r = { "<cmd>ClaudeCodeContinue<CR>", "Continue Conversation" },
  },
}

wk.register(mappings, opts)