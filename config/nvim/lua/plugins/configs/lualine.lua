-- Lualine Configuration

local lualine = require("lualine")

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " },
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- Custom components
local filename = {
  "filename",
  file_status = true,
  newfile_status = false,
  path = 1,
  symbols = {
    modified = "  ",
    readonly = "",
    unnamed = "",
    newfile = "",
  },
}

-- LSP clients
local lsp = {
  function()
    local msg = ""
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = " LSP:",
  color = { fg = "#ffffff", gui = "bold" },
}

-- Battery status (if available)
local battery = {
  function()
    local handle = io.popen("cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1")
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      local level = tonumber(result:gsub("%s+", ""))
      if level then
        local icon = ""
        if level > 80 then
          icon = ""
        elseif level > 60 then
          icon = ""
        elseif level > 40 then
          icon = ""
        elseif level > 20 then
          icon = ""
        else
          icon = ""
        end
        return icon .. " " .. level .. "%%"
      end
    end
    return ""
  end,
  cond = function()
    return vim.fn.isdirectory("/sys/class/power_supply") == 1
  end,
}

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, diagnostics },
    lualine_c = { 
      filename,
      -- Only show navic if available
      vim.fn.has('nvim-0.10') == 1 and {
        "navic",
        color_correction = nil,
        navic_opts = nil
      } or nil
    },
    lualine_x = { 
      lsp,
      battery,
      diff, 
      spaces, 
      "encoding", 
      filetype 
    },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  extensions = { "nvim-tree", "toggleterm", "quickfix" },
})