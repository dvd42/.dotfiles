local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
      "thesimonho/kanagawa-paper.nvim",
      lazy = false,
      priority = 1000,
      -- Load and apply the Kanagawa Paper colorscheme before all other plugins
      config = function()
        require('kanagawa-paper').load()
        vim.cmd('colorscheme kanagawa-paper')
      end,
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      config = function()
          require('plugins.lsp')
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      config = function()
          require('plugins.lualine')
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
          require('plugins.treesitter')
      end,
    },
    {
      'smoka7/hop.nvim',
      version = "*",
      opts = {
        keys = 'etovxqpdygfblzhckisuran' -- pragma: allowlist secret
      },
      keys = {
        {
          's',
          function()
            require('hop').hint_char1({ current_line_only = false })
          end,
          mode = { 'n', 'x', 'o' },
          desc = 'HopChar',
          remap = true,
        },
      },
    },
    {
      'hrsh7th/nvim-cmp',
      lazy = false,
      dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "onsails/lspkind.nvim",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-buffer",
      },
      config = function()
          require('plugins.cmp')
      end,
    },
    {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' } },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
      },
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
      init = function()
        require('plugins.dadbod').init()
      end,
    },
    {
      'zbirenbaum/copilot.lua',
      config = function()
          require('plugins.copilot')
      end,
    },
    {
      "eandrju/cellular-automaton.nvim",
      keys = {
        { '<leader>mir', ':CellularAutomaton make_it_rain<CR>j', mode = 'n', desc = 'Make it Rain', silent = true },
        { '<leader>gol', ':CellularAutomaton game_of_life<CR>j', mode = 'n', desc = 'Game of Life', silent = true },
      },
    },
    {
      "NeogitOrg/neogit",
      branch = "master",
      dependencies = {
          "nvim-lua/plenary.nvim", -- required
      },
      config = function()
          require("plugins.neogit")
      end,

    },
    {
        "esmuellert/vscode-diff.nvim",
        branch = "next",  -- change to main once merge conflict tool has been integrated
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
          require("plugins.gitsigns")
      end,
    },
    {   'romgrk/barbar.nvim',

      dependencies = {
          'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
          'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      config = function()
          require('plugins.barbar')
      end,
    },
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
          require("plugins.oil")
      end,
    },
    {
      "folke/which-key.nvim",
      lazy = false,
      init = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 500
      end,
      opts = {
      defer = function(ctx)
        if vim.list_contains({ "d", "y", "g" }, ctx.operator) then
          return true
        end
        return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
      end,
      },
    },
    {
      "echasnovski/mini.sessions",
      version = false,
      config = function()
        require("plugins.sessions")
      end,
    },
    {
      "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
          "MunifTanjim/nui.nvim",
          "rcarriga/nvim-notify",
      },
      config = function()
          require("plugins.noice")
      end,
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event  = "LspAttach",
      priority = 1000,
      config = function()
        require("plugins.tiny_inline_diagnostic")
      end,
    },
    {
       "letieu/wezterm-move.nvim",
       keys = {
         { "<C-h>", function() require("wezterm-move").move "h" end },
         { "<C-j>", function() require("wezterm-move").move "j" end },
         { "<C-k>", function() require("wezterm-move").move "k" end },
         { "<C-l>", function() require("wezterm-move").move "l" end },
       },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown" },
      },
      ft = { "markdown" },
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      config = function()
        require("plugins.snacks")
      end,
    },
    {
      name = 'encourage.nvim',
      dir = vim.loop.os_homedir() .. "/.dotfiles/nvim/local-plugins/encourage.nvim",
      config = function()
        require('encourage').setup()
      end,
    },
    {
      "aliqyan-21/wit.nvim",
      config = function()
        require('wit').setup()
      end
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.minuet")
        end,
    }
})
