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
    -- Lazy
    {
      "vague2k/vague.nvim",
      config = function()
        require("vague").setup({
            style = {
                strings = "none",
            }
          -- optional configuration here
        })
	vim.cmd([[colorscheme vague]])
      end
    },
    {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("refactoring").setup()
      end,
    },
    --{
    --    'Chaitanyabsprip/fastaction.nvim',
    --    ---@type FastActionConfig
    --    opts = {},
    --},
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
      "ojroques/vim-oscyank",
      branch = "main",
      config = function()
          require('plugins.oscyank')
      end,
    },
    {"tpope/vim-commentary"},
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
      }
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
      'zbirenbaum/copilot.lua',
      config = function()
          require('plugins.copilot')
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      tag = '0.1.6',
      config = function()
          require('plugins.telescope')
      end,
    },
    {
      'nvimtools/none-ls.nvim',
      dependencies = {'nvimtools/none-ls-extras.nvim', 'nvim-lua/plenary.nvim'},
      config = function()
          require('plugins.none_ls')
      end,
    },
    {"eandrju/cellular-automaton.nvim"},
    {
      "robitx/gp.nvim",
      config = function()
          require("plugins.gp")
      end,
    },
    {
      "NeogitOrg/neogit",
      branch = "master",
      dependencies = {
          "nvim-lua/plenary.nvim",         -- required
          "sindrets/diffview.nvim",
          "nvim-telescope/telescope.nvim", -- optional
      },
      config = true,
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
      'onsails/lspkind.nvim',
    },
    {
      "kndndrj/nvim-dbee",
      dependencies = {
          "MunifTanjim/nui.nvim",
      },
      build = function()
          require("dbee").install()
      end,
      config = function()
          require("plugins.dbee")
      end,
    },
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
          require("plugins.oil")
      end,
    },
    { 'rcarriga/nvim-notify'},

    {
      "folke/which-key.nvim",
      lazy = false,
      init = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 500
      end,
      opts = {
      defer = function(ctx)
        if vim.list_contains({ "d", "y" }, ctx.operator) then
          return true
        end
        return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
      end,
      },
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },

    {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("plugins.fzf_lua")
      end,
    },
    { "junegunn/fzf", build = "./install --bin" },
    {
      "gennaro-tedesco/nvim-possession",
      dependencies = {
          "ibhagwan/fzf-lua",
      },
      config = true,
      init = function()
          local possession = require("nvim-possession")
          vim.keymap.set("n", "<leader>sl", function()
              possession.list()
          end, {desc = "List sessions"})
          vim.keymap.set("n", "<leader>sn", function()
              possession.new()
          end, {desc = "Create session"})
          vim.keymap.set("n", "<leader>su", function()
              possession.update()
          end, {desc = "Update session"})
          vim.keymap.set("n", "<leader>sd", function()
              possession.delete()
          end, {desc = "Delete session"})
      end,
    },
    {
       "kiyoon/jupynium.nvim",
       build = "pip install .",
       dependencies = {
         "rcarriga/nvim-notify",   -- optional
       },
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
    "svampkorg/moody.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    opts = {
        blends = {
            normal = 0.2,
            insert = 0.2,
            visual = 0.25,
            command = 0.2,
            operator = 0.2,
            replace = 0.2,
            select = 0.2,
            terminal = 0.2,
            terminal_n = 0.2,
        },
        disabled_filetypes = { "TelescopePrompt" },
        bold_nr = true,
        recording = {
            enabled = true,
            icon = "󰑋",
            pre_registry_text = " ",
            post_registry_text = "",
        },
      },
    },
    {
     "folke/trouble.nvim",

     opts = {
         modes = {
           diagnostics = {
             mode = "diagnostics",
             win = {
                 wo = {
                   winblend = 100,
                 },
               title = "Diagnostics",
               size = { width = 0.4, height = 0.3 },
               zindex = 1000,
             },
           },
           lsp_symbols = {
             mode = "symbols",
             win = {
                 wo = {
                   winblend = 100,
                 },
               title = "Symbols",
               title_pos = "center",
               size = { width = 0.4, height = 1 },
               zindex = 200,
             },
           },
           lsp_lsp = {
             mode = "lsp",
             win = {
                 wo = {
                   winblend = 100,
                 },
               type = "split",
               position = "right",
               title = "LocList",
               title_pos = "center",
               size = { width = 0.4, height = 0.3 },
               zindex = 1000,
             },
           },
       }
     }, -- for default options, refer to the configuration section for custom setup.
     cmd = "Trouble",
     keys = {
       {
         "<leader>xx",
         "<cmd>Trouble diagnostics toggle<cr>",
         desc = "Diagnostics (Trouble)",
       },
       {
         "<leader>xX",
         "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
         desc = "Buffer Diagnostics (Trouble)",
       },
       {
         "<leader>cs",
         "<cmd>Trouble lsp_symbols toggle<cr>",
         desc = "Symbols (Trouble)",
       },
       {
         "<leader>cl",
         "<cmd>Trouble lsp_lsp toggle<cr>",
         desc = "LSP Definitions / references / ... (Trouble)",
       },
       {
         "<leader>xL",
         "<cmd>Trouble loclist toggle<cr>",
         desc = "Location List (Trouble)",
       },
       {
         "<leader>xQ",
         "<cmd>Trouble qflist toggle<cr>",
         desc = "Quickfix List (Trouble)",
       },
     },
    },
    {
    'goolord/alpha-nvim',
    config = function ()
       require('plugins.alpha')
    end
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
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    {
        "stevearc/dressing.nvim",
        opts = {}
    },
    {
      'r-cha/encourage.nvim',
      config = true
    },
})

require("jupynium").setup({

    default_notebook_URL = "localhost:8888/nbclassic",
})

vim.keymap.set('n', '<leader>mir', ':CellularAutomaton make_it_rain<CR>j', {desc = "Make it Rain", silent = true})
vim.keymap.set('n', '<leader>gol', ':CellularAutomaton game_of_life<CR>j', {desc = "Game of Life", silent = true})

local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 's', function()
  hop.hint_char1({ current_line_only = false })
end, {desc = "HopChar", remap=true})

vim.api.nvim_set_hl(0, 'NormalMoody', { fg = "#7894ab" })
vim.api.nvim_set_hl(0, 'InsertMoody', { fg = "#8faf77" })
vim.api.nvim_set_hl(0, 'VisualMoody', { fg = "#b4be82" })
vim.api.nvim_set_hl(0, 'CommandMoody', { fg = "#be8c8c" })
vim.api.nvim_set_hl(0, 'OperatorMoody', { fg = "#e2a478" })
vim.api.nvim_set_hl(0, 'ReplaceMoody', { fg = "#e2a478" })
vim.api.nvim_set_hl(0, 'SelectMoody', { fg = "#AD6FF7" })


-- vim.keymap.set(
--     'n',
--     '<leader>ca',
--     '<cmd>lua require("fastaction").code_action()<CR>',
--     { desc = "Code action", buffer = bufnr }
-- )
-- vim.keymap.set(
--     'v',
--     '<leader>ca',
--     "<esc><cmd>lua require('fastaction').range_code_action()<CR>",
--     { desc = "Selection Code Action", buffer = bufnr }
-- )

require('encourage').setup({
    messages = {
        "Oh wow, you saved the file! Hope the code's smarter than its author.",
        "File saved. I'm not saying your code's bad, but maybe keep your day job.",
        "Great, another save. Did you actually fix anything, or is this just for show?",
        "Ah, saving again? The 'Undo' button was right there, just so you know.",
        "Code saved. Let's hope it runs better than it looks.",
        "Another save, another disappointment. But who's counting?",
        "Wow, saved again? At least one of us is optimistic about this project.",
        "File saved. Let's call it 'hopeful thinking', shall we?",
        "Code saved. It's like watching a trainwreck in slow motion. 🚂💥",
        "Great, you hit save. Did you want a medal or something?",
        "Save complete. Too bad it doesn't improve the content.",
        "Your code's saved. Don't worry, I've seen worse... I just can't remember when.",
        "Ah, the sweet sound of saving. Too bad it's not the sound of improving.",
        "File saved. Brace yourself for the runtime errors.",
        "Code saved. I guess it's better than letting it fester unsaved.",
        "Keep saving like that, and we might just make it mediocre.",
        "File saved! It's like polishing a brick.",
        "Oh, another save? I'll alert the media.",
        "Saved. Now, let's lower those expectations right away.",
        "Your code is saved. I'd say 'good job', but I'm not a liar.",
        "File successfully saved. Unfortunately, that’s the only thing successful here.",
        "You saved the file! Too bad you can't save it from itself. 😬",
        "Save detected. Not sure if it's bravery or just denial.",
        "Code saved. Now, if only your skills could save you during the review.",
        "Hooray, you hit save! It's almost like real progress.",
        "File saved, as if that's going to fix it.",
        "You've saved again. There's optimism, and then there's whatever this is.",
        "Save complete. Fingers crossed it compiles this time, eh?",
        "Look at you, saving files like you're going to run them.",
        "Ah, a save! Because why correct your mistakes when you can immortalize them?",
        "Code saved. Are we just ignoring the problems now?",
        "Code saved. Somewhere, a rubber duck is weeping.",
        "Ah, you saved. Let’s not pretend it was worth it.",
        "File saved. Alert the press, or maybe just your mom. She'd care.",
        "Saved? Bold of you to assume it's worth the storage space.",
        "File saved. It's like putting lipstick on a pig, but go ahead.",
        "Another save. Clinging to hope is cute, isn't it?",
        "You clicked save! It’s almost like you believe in miracles.",
        "File saved. It's like a participation trophy, but for code.",
        "Oh, a save! I guess it's easier than fixing the problem."
    },
})
