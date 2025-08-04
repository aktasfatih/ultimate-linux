-- Auto Commands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove whitespace on save
augroup("RemoveWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "RemoveWhitespace",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Auto resize splits
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  command = "tabdo wincmd =",
})

-- Close some filetypes with <q>
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create directories when saving
augroup("AutoCreateDir", { clear = true })
autocmd("BufWritePre", {
  group = "AutoCreateDir",
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Format on save (optional, can be toggled)
vim.g.format_on_save = true
augroup("FormatOnSave", { clear = true })
autocmd("BufWritePre", {
  group = "FormatOnSave",
  callback = function()
    if vim.g.format_on_save then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- Terminal settings
augroup("TerminalSettings", { clear = true })
autocmd("TermOpen", {
  group = "TerminalSettings",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- Performance debugging commands
vim.api.nvim_create_user_command("StartupTime", function()
  vim.cmd("tabnew")
  vim.cmd("StartupTime")
end, { desc = "Show startup time analysis" })

vim.api.nvim_create_user_command("TogglePerformanceMode", function()
  vim.notify("Performance mode is disabled. Full feature set is always enabled.", vim.log.levels.INFO)
end, { desc = "Performance mode (disabled)" })

vim.api.nvim_create_user_command("CheckPerformance", function()
  local stats = {}
  stats.performance_mode = "Disabled (Full features enabled)"
  stats.loaded_plugins = #vim.tbl_keys(require("lazy").plugins())
  stats.lsp_clients = #vim.lsp.get_clients()
  
  local report = string.format([[
Performance Report:
- Mode: %s
- Loaded plugins: %d
- Active LSP clients: %d
- SSH session: %s

Tips for better performance:
1. Run :Lazy profile to see plugin load times
2. Use :LspInfo to check LSP server status
3. Run :checkhealth for diagnostics
4. Consider using minimal config on remote servers
]], stats.performance_mode, stats.loaded_plugins, stats.lsp_clients,
    (vim.env.SSH_CLIENT or vim.env.SSH_TTY) and "Yes" or "No")
  
  vim.notify(report, vim.log.levels.INFO)
end, { desc = "Check Neovim performance" })