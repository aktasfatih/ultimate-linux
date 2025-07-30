-- Treesitter Configuration

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "html",
    "java",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
  },
  
  sync_install = false,
  auto_install = true,
  
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },
  
  indent = {
    enable = true,
    disable = { "yaml" },
  },
  
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<C-s>",
      node_decremental = "<C-backspace>",
    },
  },
  
  autotag = {
    enable = true,
  },
})

-- Setup textobjects after treesitter loads
vim.defer_fn(function()
  local has_textobjects, textobjects = pcall(require, "nvim-treesitter.configs")
  if has_textobjects then
    textobjects.setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    })
  end
end, 100)