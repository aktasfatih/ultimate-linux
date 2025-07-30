-- LSP Configuration

-- Setup neodev for Neovim Lua development
require("neodev").setup()

-- Mason setup (now handled in plugins/init.lua)

-- Mason LSP config (now handled in plugins/init.lua)

-- Mason DAP (Debug Adapter Protocol) config
require("mason-nvim-dap").setup({
  ensure_installed = {
    "delve",              -- Go debugger
    "js-debug-adapter",   -- Node.js/JavaScript debugger
    "debugpy",            -- Python debugger
    "bash-debug-adapter", -- Bash debugger
  },
  automatic_installation = true,
  handlers = {
    function(config)
      -- Default handler
      require("mason-nvim-dap").default_setup(config)
    end,
    delve = function(config)
      config.configurations = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- works with go.mod packages and sub packages 
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }
      require("mason-nvim-dap").default_setup(config)
    end,
  },
})

-- LSP capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP on_attach
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Enable semantic highlighting if available
  if client.server_capabilities.semanticTokensProvider then
    vim.lsp.semantic_tokens.start(bufnr, client.id)
    
    -- Force refresh semantic tokens for better highlighting
    if client.name == "gopls" then
      vim.defer_fn(function()
        vim.lsp.semantic_tokens.force_refresh(bufnr)
      end, 500)
    end
  end
  
  -- Attach navic if available and Neovim is 0.10+
  if vim.fn.has('nvim-0.10') == 1 and client.server_capabilities.documentSymbolProvider then
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then
      navic.attach(client, bufnr)
    end
  end

  -- LSP keymaps using modern vim.keymap.set
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end

-- LSP settings (servers are now auto-configured by mason-lspconfig)
-- Setup handlers for automatic server configuration
-- Use vim.defer_fn to ensure mason-lspconfig is fully loaded
vim.defer_fn(function()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup_handlers({
    -- Default handler for all servers
    function(server_name)
      local lspconfig = require("lspconfig")
      
      lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
    
    -- Custom configuration for lua_ls
    ["lua_ls"] = function()
      local lspconfig = require("lspconfig")
      
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end,
    
    -- Custom configuration for rust_analyzer
    ["rust_analyzer"] = function()
      local lspconfig = require("lspconfig")
      
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })
    end,
    
    -- Custom configuration for gopls (Go language server)
    ["gopls"] = function()
      local lspconfig = require("lspconfig")
      
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            semanticTokens = true,  -- Enable semantic tokens
            -- Enhanced semantic highlighting
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })
    end,
  })
end, 100)

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- None-ls setup (successor to null-ls)
local none_ls = require("null-ls")
require("mason-null-ls").setup({
  ensure_installed = {
    "prettier",
    "stylua",
    "black",
    "isort",
    "shfmt",
    "shellcheck",
    "hadolint",
  },
  automatic_installation = true,
})

none_ls.setup({
  sources = {
    -- Formatting
    none_ls.builtins.formatting.prettier.with({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "css", "scss", "html", "markdown" },
    }),
    none_ls.builtins.formatting.stylua,
    none_ls.builtins.formatting.black,
    none_ls.builtins.formatting.isort,
    none_ls.builtins.formatting.shfmt,
    none_ls.builtins.formatting.gofmt,       -- Go formatting
    none_ls.builtins.formatting.goimports,   -- Go imports
    
    -- Diagnostics
    none_ls.builtins.diagnostics.shellcheck,
    none_ls.builtins.diagnostics.hadolint,
    none_ls.builtins.diagnostics.eslint,     -- JavaScript/TypeScript linting
    none_ls.builtins.diagnostics.flake8,     -- Python linting
    none_ls.builtins.diagnostics.golangci_lint, -- Go linting
  },
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Attach navic if available and Neovim is 0.10+
    if vim.fn.has('nvim-0.10') == 1 and client.server_capabilities.documentSymbolProvider then
      local navic_ok, navic = pcall(require, "nvim-navic")
      if navic_ok then
        navic.attach(client, bufnr)
      end
    end
  end,
})