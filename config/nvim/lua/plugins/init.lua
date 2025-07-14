-- Plugin specifications

return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mason = true,
          telescope = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- UI Components
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("plugins.configs.dashboard")
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },

  -- Smooth scrolling (disabled for instant scrolling)
  -- {
  --   "karb94/neoscroll.nvim",
  --   event = "WinScrolled",
  --   config = function()
  --     require("neoscroll").setup({
  --       mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
  --       hide_cursor = true,
  --       stop_eof = true,
  --       respect_scrolloff = false,
  --       cursor_scrolls_alone = true,
  --       easing_function = nil,
  --       pre_hook = nil,
  --       post_hook = nil,
  --     })
  --   end,
  -- },

  -- Better UI for messages, cmdline and popupmenu (only for Neovim 0.10+)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = vim.fn.has('nvim-0.10') == 1,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  -- Winbar with context (requires Neovim 0.10+ for proper winbar support)
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    enabled = vim.fn.has('nvim-0.10') == 1,
    config = function()
      require("nvim-navic").setup({
        icons = {
          File          = " ",
          Module        = " ",
          Namespace     = " ",
          Package       = " ",
          Class         = " ",
          Method        = " ",
          Property      = " ",
          Field         = " ",
          Constructor   = " ",
          Enum          = "練",
          Interface     = "練",
          Function      = " ",
          Variable      = " ",
          Constant      = " ",
          String        = " ",
          Number        = " ",
          Boolean       = "◩ ",
          Array         = " ",
          Object        = " ",
          Key           = " ",
          Null          = "ﳠ ",
          EnumMember    = " ",
          Struct        = " ",
          Event         = " ",
          Operator      = " ",
          TypeParameter = " ",
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = false,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.nvim-tree")
    end,
  },

  -- Improved syntax highlighting (only for Neovim 0.10+)
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = vim.fn.has('nvim-0.10') == 1,
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        zindex = 20,
        on_attach = nil,
      })
    end,
  },

  -- Highlight matching words
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay = 120,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp" },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.configs.treesitter")
    end,
  },
  
  -- Treesitter extensions (load after treesitter)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
  },

  -- LSP (with version pins for Neovim 0.9.5 compatibility)
  {
    "neovim/nvim-lspconfig",
    commit = "0b8165cf95806bc4bb8f745bb0c92021b2ed4b98", -- Last commit supporting Neovim 0.9
    dependencies = {
      { "williamboman/mason.nvim", version = "v1.10.0" },
      { "williamboman/mason-lspconfig.nvim", version = "v1.29.0" },
      "folke/neodev.nvim",
      "nvimtools/none-ls.nvim",
      { "jay-babu/mason-null-ls.nvim", version = "v2.6.0" },
    },
    config = function()
      require("plugins.configs.lsp")
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      require("plugins.configs.telescope")
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
  },

  -- Utilities
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("plugins.configs.which-key")
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        "css",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        html = {
          mode = "background",
        },
      })
    end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        -- Animation style
        stages = "fade_in_slide_out",
        -- Timeout for notifications
        timeout = 3000,
        -- Other options
        background_colour = "#000000",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
      })
      
      -- Create a wrapper to handle both old and new API
      local banned_messages = { "No information available" }
      vim.notify = function(msg, level, opts)
        -- Filter out banned messages
        for _, banned in ipairs(banned_messages) do
          if msg == banned then
            return
          end
        end
        
        -- Handle string levels (old API)
        if type(level) == "string" then
          level = vim.log.levels[level:upper()] or vim.log.levels.INFO
        end
        
        -- Handle missing level
        if type(level) ~= "number" then
          opts = level
          level = vim.log.levels.INFO
        end
        
        -- Ensure opts is a table
        if type(opts) == "string" then
          opts = { title = opts }
        elseif type(opts) ~= "table" then
          opts = {}
        end
        
        notify(msg, level, opts)
      end
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- Essential for Next.js development
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "xml" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Better TypeScript errors
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },

  -- Database viewer (useful for Supabase)
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("plugins.configs.toggleterm")
    end,
  },

  -- Session management
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      })
    end,
  },

  -- Tmux integration
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Modern file icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        },
        color_icons = true,
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      })
    end,
  },

  -- Enhanced LSP UI (requires newer Neovim APIs)
  {
    "nvimdev/lspsaga.nvim",
    enabled = vim.fn.has('nvim-0.10') == 1,
    config = function()
      require("lspsaga").setup({
        ui = {
          theme = "round",
          border = "rounded",
          winblend = 0,
          expand = "",
          collapse = "",
          preview = " ",
          code_action = "💡",
          diagnostic = "🐞",
          incoming = " ",
          outgoing = " ",
          hover = ' ',
          kind = {},
        },
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  },

  -- Better quickfix (disabled for Neovim 0.9.x)
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    enabled = false, -- Disabled due to compatibility issues with Neovim 0.9.x
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {"┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█"},
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
              ret = false
            end
            return ret
          end
        },
        func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = ''
        },
        filter = {
          fzf = {
            action_for = {['ctrl-s'] = 'split'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
          }
        }
      })
    end
  },

  -- Improved search (compatible with 0.9+)
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      -- Safe setup for older Neovim versions
      local ok, hlslens = pcall(require, "hlslens")
      if ok then
        hlslens.setup()
      end
    end
  },

  -- Color picker
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable" },
    config = function()
      require("ccc").setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  },
}