-- Alpha (Dashboard) Configuration

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header
dashboard.section.header.val = {
  [[                                                    ]],
  [[     ██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗    ]],
  [[     ██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝    ]],
  [[     ██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗      ]],
  [[     ██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝      ]],
  [[     ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗    ]],
  [[      ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ]],
  [[                                                    ]],
  [[                 L I N U X   D E V   S E T U P                          ]],
  [[                                                    ]],
}

dashboard.section.header.opts.hl = "Include"

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("s", "󰁯  Restore Session", ":SessionRestore<CR>"),
  dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
  dashboard.button("m", "  Mason", ":Mason<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- Footer
local function footer()
  local version = vim.version()
  local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  
  return {
    "",
    "Neovim " .. print_version,
    datetime,
    "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
  }
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Type"

-- Layout
dashboard.config.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

-- Disable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])

alpha.setup(dashboard.config)