return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "ojroques/vim-oscyank",
    config = function()
      -- Configure OSC52 clipboard support for better tmux integration
      vim.g.oscyank_term = 'tmux'
      vim.g.oscyank_silent = true
      
      -- Set up autocommands for clipboard synchronization
      vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('OSCYankPost', {}),
        callback = function()
          if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            require('vim.ui.clipboard.osc52').copy('+')(vim.v.event.regcontents)
          end
        end,
      })
    end,
  },
}