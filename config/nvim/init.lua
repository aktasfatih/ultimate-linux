-- Ultimate Linux Development Setup - Neovim Configuration

-- Check Neovim version compatibility
local nvim_version = vim.version()
if nvim_version.major == 0 and nvim_version.minor < 9 then
  vim.notify("This configuration requires Neovim 0.9+. Current version: " .. vim.version.major .. "." .. vim.version.minor .. "." .. vim.version.patch, vim.log.levels.ERROR)
  return
end

-- Show warning for 0.9.x users about limited features
if nvim_version.major == 0 and nvim_version.minor == 9 then
  vim.defer_fn(function()
    -- Use pcall to handle case where vim.notify might not be fully initialized
    pcall(vim.notify, "Neovim 0.9.x detected. Some features disabled for compatibility. Upgrade to 0.10+ for full experience.", vim.log.levels.WARN, {})
  end, 1000)
end

-- Performance optimization: disable providers we don't need
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core settings
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load plugins (always use full configuration)
local plugins_spec = "plugins"
require("lazy").setup(plugins_spec, {
  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
