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
          mason = true,
          telescope = true,
          which_key = true,
          semantic_tokens = false, -- Disable for performance
          rainbow_delimiters = true,
          lsp_trouble = true,
        },
        custom_highlights = function(colors)
          return {
            -- Enhanced semantic highlighting for Go and other languages
            ["@lsp.type.variable"] = { fg = colors.text },
            ["@lsp.type.variable.readonly"] = { fg = colors.blue },
            ["@lsp.type.parameter"] = { fg = colors.peach },
            ["@lsp.type.function"] = { fg = colors.blue },
            ["@lsp.type.method"] = { fg = colors.blue },
            ["@lsp.type.property"] = { fg = colors.teal },
            ["@lsp.type.field"] = { fg = colors.teal },
            ["@lsp.type.enum"] = { fg = colors.yellow },
            ["@lsp.type.enumMember"] = { fg = colors.peach },
            ["@lsp.type.type"] = { fg = colors.yellow },
            ["@lsp.type.class"] = { fg = colors.yellow },
            ["@lsp.type.struct"] = { fg = colors.yellow },
            ["@lsp.type.interface"] = { fg = colors.yellow },
            ["@lsp.type.namespace"] = { fg = colors.blue },
            ["@lsp.type.keyword"] = { fg = colors.mauve },
            ["@lsp.type.string"] = { fg = colors.green },
            ["@lsp.type.number"] = { fg = colors.peach },
            ["@lsp.type.boolean"] = { fg = colors.peach },
            ["@lsp.type.comment"] = { fg = colors.overlay1 },
            -- Go-specific enhancements
            ["@lsp.type.variable.go"] = { fg = colors.text },
            ["@lsp.type.function.go"] = { fg = colors.blue, style = { "bold" } },
            ["@lsp.type.method.go"] = { fg = colors.sapphire, style = { "bold" } },
            ["@lsp.type.type.go"] = { fg = colors.yellow, style = { "italic" } },
            ["@lsp.type.struct.go"] = { fg = colors.yellow, style = { "bold" } },
            ["@lsp.type.interface.go"] = { fg = colors.yellow, style = { "italic", "bold" } },
            ["@lsp.type.package.go"] = { fg = colors.mauve, style = { "italic" } },
            -- Additional Go semantic tokens
            ["@lsp.typemod.variable.readonly.go"] = { fg = colors.blue },
            ["@lsp.typemod.variable.defaultLibrary.go"] = { fg = colors.red },
            ["@lsp.typemod.function.defaultLibrary.go"] = { fg = colors.sapphire, style = { "bold" } },
            ["@lsp.typemod.method.defaultLibrary.go"] = { fg = colors.sapphire, style = { "bold" } },
            ["@lsp.typemod.type.defaultLibrary.go"] = { fg = colors.yellow, style = { "italic" } },
            -- Treesitter Go highlights (fallback)
            ["@keyword.go"] = { fg = colors.mauve, style = { "bold" } },
            ["@keyword.function.go"] = { fg = colors.mauve, style = { "bold" } },
            ["@keyword.return.go"] = { fg = colors.mauve, style = { "bold" } },
            ["@type.go"] = { fg = colors.yellow, style = { "italic" } },
            ["@type.builtin.go"] = { fg = colors.yellow, style = { "bold" } },
            ["@function.builtin.go"] = { fg = colors.sapphire, style = { "bold" } },
            ["@constant.builtin.go"] = { fg = colors.peach, style = { "bold" } },
            ["@string.go"] = { fg = colors.green },
            ["@number.go"] = { fg = colors.peach },
            ["@boolean.go"] = { fg = colors.peach, style = { "bold" } },
          }
        end,
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

  -- Better UI for messages, cmdline and popupmenu (DISABLED - causes performance issues)
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   enabled = false, -- Disabled due to performance impact with notifications
  --   opts = {
  --     lsp = {
  --       override = {
  --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --         ["vim.lsp.util.stylize_markdown"] = true,
  --         ["cmp.entry.get_documentation"] = true,
  --       },
  --     },
  --     routes = {
  --       {
  --         filter = {
  --           event = "msg_show",
  --           any = {
  --             { find = "%d+L, %d+B" },
  --             { find = "; after #%d+" },
  --             { find = "; before #%d+" },
  --           },
  --         },
  --         view = "mini",
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       command_palette = true,
  --       long_message_to_split = true,
  --       inc_rename = false,
  --       lsp_doc_border = false,
  --     },
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   }
  -- },

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
    event = "VeryLazy",
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

  -- Highlight matching words (DISABLED - causes significant lag)
  {
    "RRethy/vim-illuminate",
    enabled = false, -- Disabled due to performance impact on cursor movement
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

  -- Rainbow brackets for better syntax highlighting
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow", 
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- Enhanced Go syntax highlighting (lazy loaded)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" }, -- Lazy load only for Go files
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        goimports = "gopls",
        fillstruct = "gopls",
        dap_debug = false,
        dap_debug_gui = false,
        trouble = false,
        luasnip = true,
        lsp_cfg = false, -- Do not override LSP config
        lsp_gofumpt = false,
        lsp_on_attach = false,
        lsp_keymaps = false,
        lsp_codelens = false,
        lsp_diag_hdlr = false,
        lsp_inlay_hints = { enable = false },
        icons = { breakpoint = '🧘', currentpos = '🏃' },
      })
    end,
  },

  -- Mason (load early for commands)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-LSPConfig (bridge between mason and native vim.lsp.config)
  -- Updated for Mason 2.0 + Neovim 0.11+ compatibility
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "bashls",
          "cssls",
          "html",
          "jsonls",
          "yamlls",
          "dockerls",
          "taplo",
          "tailwindcss",
          "eslint",
          "prismals",
        },
        -- Mason 2.0: automatic_enable is now default (true)
        -- This automatically calls vim.lsp.enable() for installed servers
        -- No need for setup_handlers or automatic_installation anymore
      })
    end,
  },

  -- LSP (Neovim 0.11+ native vim.lsp.config)
  -- nvim-lspconfig is still used as a data source for server configs
  -- but we use the native vim.lsp.config() and vim.lsp.enable() APIs
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
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
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
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
    event = { "BufReadPre", "BufNewFile" },  -- Load on buffer events only
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
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      })
    end,
  },

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },  -- Only load when Octo command is used
    config = function()
      require("octo").setup({
        use_local_fs = false,
        enable_builtin = true,
        default_remote = {"upstream", "origin"},
        default_merge_method = "commit",
        ssh_aliases = {},
        reaction_viewer_hint_icon = "",
        user_icon = " ",
        timeline_marker = "",
        timeline_indent = 2,
        right_bubble_delimiter = "",
        left_bubble_delimiter = "",
        github_hostname = "",
        snippet_context_lines = 4,
        gh_env = {},
        timeout = 5000,
        ui = {
          use_signcolumn = true,
          use_signstatus = true,
        },
        issues = {
          order_by = {
            field = "CREATED_AT",
            direction = "DESC"
          }
        },
        pull_requests = {
          order_by = {
            field = "CREATED_AT", 
            direction = "DESC"
          },
          always_select_remote_on_create = false
        },
        file_panel = {
          size = 10,
          use_icons = true
        },
        mappings = {
          issue = {
            close_issue = { lhs = "<space>ic", desc = "close issue" },
            reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
            list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
            reload = { lhs = "<C-r>", desc = "reload issue" },
            open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            add_assignee = { lhs = "<space>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
            create_label = { lhs = "<space>lc", desc = "create label" },
            add_label = { lhs = "<space>la", desc = "add label" },
            remove_label = { lhs = "<space>ld", desc = "remove label" },
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ca", desc = "add comment" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          pull_request = {
            checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
            merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
            squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
            list_commits = { lhs = "<space>pc", desc = "list PR commits" },
            list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
            show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
            add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
            remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
            close_issue = { lhs = "<space>ic", desc = "close PR" },
            reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
            list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
            reload = { lhs = "<C-r>", desc = "reload PR" },
            open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            goto_file = { lhs = "gf", desc = "go to file" },
            add_assignee = { lhs = "<space>aa", desc = "add assignee" },
            remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
            create_label = { lhs = "<space>lc", desc = "create label" },
            add_label = { lhs = "<space>la", desc = "add label" },
            remove_label = { lhs = "<space>ld", desc = "remove label" },
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ca", desc = "add comment" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          review_thread = {
            goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
            add_comment = { lhs = "<space>ca", desc = "add comment" },
            add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
            delete_comment = { lhs = "<space>cd", desc = "delete comment" },
            next_comment = { lhs = "]c", desc = "go to next comment" },
            prev_comment = { lhs = "[c", desc = "go to previous comment" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
            react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
            react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
            react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
            react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
            react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
            react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
            react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
          },
          submit_win = {
            approve_review = { lhs = "<C-a>", desc = "approve review" },
            comment_review = { lhs = "<C-m>", desc = "comment review" },
            request_changes = { lhs = "<C-r>", desc = "request changes review" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          },
          review_diff = {
            add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
            add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
            focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
            next_thread = { lhs = "]t", desc = "move to next thread" },
            prev_thread = { lhs = "[t", desc = "move to previous thread" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
            goto_file = { lhs = "gf", desc = "go to file" },
          },
          file_panel = {
            next_entry = { lhs = "j", desc = "move to next changed file" },
            prev_entry = { lhs = "k", desc = "move to previous changed file" },
            select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
            refresh_files = { lhs = "R", desc = "refresh changed files panel" },
            focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
            toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
            select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
            select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
            close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
            toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          }
        }
      })
    end,
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
    enabled = true,
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

  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "ClaudeCode", "ClaudeCodeContinue" },
    keys = {
      { "<C-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cr", "<cmd>ClaudeCodeContinue<cr>", desc = "Continue Claude conversation" },
    },
    config = function()
      require("claude-code").setup({
        -- Window position: "right", "left", "top", "bottom", or "float"
        position = "right",
        -- Window width (for left/right) or height (for top/bottom) as percentage
        size = 50,
        -- Use project root as working directory
        use_git_root = true,
        -- Automatically detect and reload files changed by Claude
        auto_reload = true,
        -- Show line numbers in Claude terminal
        line_numbers = false,
        -- Additional command arguments for Claude Code CLI
        additional_args = {},
      })
    end,
  },

  -- Debug Adapter Protocol (DAP) - Core debugging support
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Debug UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          require("plugins.configs.dap-ui")
        end,
      },
      -- Virtual text during debugging
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            clear_on_continue = false,
            display_callback = function(variable, _buf, _stackframe, _node)
              return variable.name .. ' = ' .. variable.value
            end,
          })
        end,
      },
      -- Telescope integration for DAP
      {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
    },
    config = function()
      require("plugins.configs.dap")
    end,
  },

  -- Go debugging support
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    config = function()
      require("dap-go").setup({
        -- Additional dap configurations can be added here
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        -- delve configurations
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })
    end,
  },

  -- Node.js debugging support
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      
      -- Configure Node.js debugging
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with \"localhost\"",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
          }
        }
      end
    end,
  },
}