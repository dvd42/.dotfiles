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
      branch = "main",
      build = ":TSUpdate",
      lazy = false,
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = {
            "query", "markdown", "regex", "markdown_inline", "c", "cpp", "bash", "lua", "python",
            "cuda", "html", "cmake", "make", "yaml", "vim", "vimdoc", "css", "javascript", "latex",
            "norg", "scss", "svelte", "tsx", "typst", "vue",
          },
          auto_install = true,
        })
        -- New main branch requires explicit vim.treesitter.start() for highlighting
        vim.api.nvim_create_autocmd("FileType", {
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })
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
          "sindrets/diffview.nvim",
      },
      config = function()
          require("plugins.neogit")
      end,

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
      "mrjones2014/smart-splits.nvim",
      lazy = false,
      opts = {
        -- Kitty/Ghostty don't need a special multiplexer_integration beyond tmux.
        -- tmux is auto-detected from $TMUX; the plugin forwards navigation keys
        -- across tmux panes using the matching tmux bindings in tmux.conf.
      },
      config = function(_, opts)
        require("smart-splits").setup(opts)
        local ss = require("smart-splits")

        -- Seamless navigation between nvim splits and tmux panes
        vim.keymap.set({ "n" }, "<C-h>", ss.move_cursor_left,  { desc = "Move to left split"  })
        vim.keymap.set({ "n" }, "<C-j>", ss.move_cursor_down,  { desc = "Move to below split" })
        vim.keymap.set({ "n" }, "<C-k>", ss.move_cursor_up,    { desc = "Move to above split" })
        vim.keymap.set({ "n" }, "<C-l>", ss.move_cursor_right, { desc = "Move to right split" })

        -- Resize splits with Alt+hjkl (matches tmux bindings)
        vim.keymap.set("n", "<M-h>", ss.resize_left,  { desc = "Resize split left"  })
        vim.keymap.set("n", "<M-j>", ss.resize_down,  { desc = "Resize split down"  })
        vim.keymap.set("n", "<M-k>", ss.resize_up,    { desc = "Resize split up"    })
        vim.keymap.set("n", "<M-l>", ss.resize_right, { desc = "Resize split right" })

        -- Terminal-mode navigation
        vim.keymap.set("t", "<C-h>", function() vim.cmd("stopinsert") ss.move_cursor_left()  end)
        vim.keymap.set("t", "<C-j>", function() vim.cmd("stopinsert") ss.move_cursor_down()  end)
        vim.keymap.set("t", "<C-k>", function() vim.cmd("stopinsert") ss.move_cursor_up()    end)
        vim.keymap.set("t", "<C-l>", function() vim.cmd("stopinsert") ss.move_cursor_right() end)
      end,
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
        opts = {
            ensure_installed = { "lua_ls", "ruff", "pyright" },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
      "folke/sidekick.nvim",
      opts = {
        nes = { enabled = false },
        cli = {
          mux = {
            backend = "tmux",
            enabled = true,
          },
        },
      },
      keys = {
        {
          "<c-.>",
          function() require("sidekick.cli").toggle() end,
          desc = "Sidekick Toggle",
          mode = { "n", "t", "i", "x" },
        },
        {
          "<leader>aa",
          function() require("sidekick.cli").toggle() end,
          desc = "Sidekick Toggle CLI",
        },
        {
          "<leader>as",
          function() require("sidekick.cli").select() end,
          desc = "Select CLI",
        },
        {
          "<leader>ad",
          function() require("sidekick.cli").close() end,
          desc = "Detach a CLI Session",
        },
        {
          "<leader>at",
          function() require("sidekick.cli").send({ msg = "{this}" }) end,
          mode = { "x", "n" },
          desc = "Send This",
        },
        {
          "<leader>af",
          function() require("sidekick.cli").send({ msg = "{file}" }) end,
          desc = "Send File",
        },
        {
          "<leader>av",
          function() require("sidekick.cli").send({ msg = "{selection}" }) end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
        {
          "<leader>ap",
          function() require("sidekick.cli").prompt() end,
          mode = { "n", "x" },
          desc = "Sidekick Select Prompt",
        },
        {
          "<leader>ct",
          function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
          desc = "Sidekick Toggle Claude",
        },
      },
    },
    {
      "linrongbin16/gitlinker.nvim",
      cmd = "GitLink",
      config = function()
        require("plugins.gitlinker")
      end,
      keys = {
        { "<leader>gy", "<cmd>GitLink default_branch<cr>", mode = { "n", "v" }, desc = "Copy git link (main)" },
        { "<leader>gY", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" }, desc = "Open git link (main)" },
      },
    },
})
