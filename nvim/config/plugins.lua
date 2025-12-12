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
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod', ft = { 'sql', 'mysql', 'plsql' } },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
      },
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    {
      'zbirenbaum/copilot.lua',
      config = function()
          require('plugins.copilot')
      end,
    },
    {"eandrju/cellular-automaton.nvim"},
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
        local sessions = require("mini.sessions")

        sessions.setup({
          -- Directory where sessions are stored
          directory = vim.fn.stdpath("data") .. "/sessions",

          autoread = false,
          autowrite = true,
        })

        vim.keymap.set("n", "<leader>sl", function()
          sessions.select()   -- Opens a simple session picker
        end, { desc = "List sessions" })

        vim.keymap.set("n", "<leader>sn", function()
          -- Prompt user for a session name
          local name = vim.fn.input("Session name: ")
          if name ~= "" then
            sessions.write(name)
          end
        end, { desc = "Create session" })

        vim.keymap.set("n", "<leader>su", function()
          local name = sessions.get_latest()
          if name then
            sessions.write(name)
          else
            vim.notify("No latest session to update", vim.log.levels.WARN)
          end
        end, { desc = "Update session" })

        vim.keymap.set("n", "<leader>sr", function()
          sessions.select("delete")
        end, { desc = "Delete session" })
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
      opts = {
        preset = "classic",
        transparent_bg = true,

        options = {
          show_source = { enabled = true },

          format = function(diag)
            local code = diag.code

            -- Fallback: extract code if server nests it (common in some LSPs)
            if not code and diag.user_data then
              if diag.user_data.lsp and diag.user_data.lsp.code then
                code = diag.user_data.lsp.code
              elseif diag.user_data.code then
                code = diag.user_data.code
              end
            end

            if code and diag.source then
              -- Example: "Unused variable 'x' [ruff/PLR2004]"
              return string.format("%s [%s/%s]", diag.message, diag.source, code)
            elseif code then
              -- No source? Rare, but safe.
              return string.format("%s [%s]", diag.message, code)
            elseif diag.source then
              -- Your existing look: message [ruff]
              return string.format("%s [%s]", diag.message, diag.source)
            else
              return diag.message
            end
          end,
        },
        hi = {
          background = "None",
        },
      },
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
      opts = {
        animate = {},
        picker = {
          formatters = {
            file = {
              filename_first = true,
              truncate       = 100,
            },
          },
        },
        bigfile = {},
        dashboard = {},
        image = {},
        scroll = {},
        indent = {},
        scope = {},
        zen = {},
        dim = {},
        words = {},
        notifier = {},
      },
      keys = {
        -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<C-f>F", function() Snacks.picker.grep({ hidden = true }) end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<C-p>", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<C-f>f", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "<leader>gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      },
    },
    {
      'r-cha/encourage.nvim',
      config = true
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
            require("minuet").setup({
                provider = "openai",
                -- How many alternative completions to ask for
                n_completions = 3,

                -- Disable Minuet auto-completion; we only want manual trigger
                cmp = {
                    enable_auto_complete = false,
                },

                provider_options = {
                    openai = {
                        model = "gpt-4.1",
                        optional = {
                            max_completion_tokens = 128,
                        },
                    },
                },
            })
        end,
    }
})

vim.keymap.set('n', '<leader>mir', ':CellularAutomaton make_it_rain<CR>j', {desc = "Make it Rain", silent = true})
vim.keymap.set('n', '<leader>gol', ':CellularAutomaton game_of_life<CR>j', {desc = "Game of Life", silent = true})

local hop = require('hop')
vim.keymap.set('', 's', function()
  hop.hint_char1({ current_line_only = false })
end, {desc = "HopChar", remap=true})


require('encourage').setup({
    messages = {
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


vim.keymap.set('n', '<leader>z', function()
  Snacks.zen()
end, { noremap = true, silent = true })


local exec = '<Plug>(DBUI_ExecuteQuery)'

vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'sql', 'mysql', 'plsql' },      -- only for SQL buffers
  callback = function(ev)
    -- normal-mode: run the whole buffer
    vim.keymap.set('n', 'BB', exec,
      { buffer = ev.buf, silent = true, desc = 'Execute SQL via Dadbod' })

    -- visual-mode: run the visually-selected block
    vim.keymap.set('v', 'BB', exec,
      { buffer = ev.buf, silent = true, desc = 'Execute SQL via Dadbod' })
  end,
})
vim.g.db_ui_execute_on_save = false
vim.g.omni_sql_no_default_maps = true
vim.api.nvim_set_keymap('n', '<leader>w', ':DBUIToggle<CR>', { desc="DBUI", noremap = true, silent = true })
