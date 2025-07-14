local dashboard = require("dashboard")

-- ASCII art for the header
local header = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
  "            Ultimate Linux Development Setup         ",
  "                                                     ",
}

dashboard.setup({
  theme = 'doom',
  config = {
    header = header,
    center = {
      {
        icon = ' ',
        icon_hl = 'Title',
        desc = 'Find File           ',
        desc_hl = 'String',
        key = 'f',
        keymap = 'SPC f f',
        key_hl = 'Number',
        action = 'lua require("telescope.builtin").find_files()'
      },
      {
        icon = ' ',
        desc = 'Find Text           ',
        key = 'g',
        keymap = 'SPC f g',
        action = 'lua require("telescope.builtin").live_grep()'
      },
      {
        icon = ' ',
        desc = 'Recent Files        ',
        key = 'r',
        keymap = 'SPC f r',
        action = 'lua require("telescope.builtin").oldfiles()'
      },
      {
        icon = ' ',
        desc = 'File Explorer       ',
        key = 'e',
        keymap = 'SPC e',
        action = 'NvimTreeToggle'
      },
      {
        icon = ' ',
        desc = 'Configuration       ',
        key = 'c',
        keymap = 'SPC f c',
        action = 'edit ~/.config/nvim/init.lua'
      },
      {
        icon = ' ',
        desc = 'Restore Session     ',
        key = 's',
        keymap = 'SPC s r',
        action = 'SessionRestore'
      },
      {
        icon = '⏻ ',
        desc = 'Quit Neovim         ',
        key = 'q',
        keymap = 'SPC q',
        action = 'qa'
      },
    },
    footer = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
    end,
  }
})