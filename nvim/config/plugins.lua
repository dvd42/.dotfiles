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
    {"navarasu/onedark.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1005, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme onedark]])
    end,
    },
    {"neovim/nvim-lspconfig", lazy = false},
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
    {"ojroques/vim-oscyank", branch = "main"},
    {"tmhedberg/SimpylFold"},
    {"neomake/neomake"},
    {"tpope/vim-fugitive"},
    {"christoomey/vim-tmux-navigator"},
    {"kkoomen/vim-doge"},
    {"tpope/vim-commentary"},
    {"roxma/vim-tmux-clipboard"},
    {"rbgrouleff/bclose.vim"},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"easymotion/vim-easymotion"},
    {"junegunn/fzf"},
    {"junegunn/fzf.vim"},
    {'hrsh7th/nvim-cmp'}, -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'},
    {"eandrju/cellular-automaton.nvim"},
    {
     "kawre/leetcode.nvim",
      build = ":TSUpdate html",
      dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",
            -- optional
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            lang = "python",
            console = {
                open_on_runcode = true, ---@type boolean
            }
        },

    }

})

-- Vim-Oscyank
vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>OSCYankOperator', {})
vim.api.nvim_set_keymap('n', '<leader>cc', '<leader>c_', {})
vim.api.nvim_set_keymap('v', '<leader>c', '<Plug>OSCYankVisual', {})
vim.g.oscyank_max_length = 0
vim.g.oscyank_silent = 0
vim.g.oscyank_trim = 1
vim.g.oscyank_osc52 = "\x1b]52;c;%s\x07"

-- Tmux Navigator
vim.g.tmux_navigator_save_on_switch = 2

-- Cellular-automaton
local config = {
    fps = 50,
    name = 'snake',
    update = function (grid)
        for i = 1, #grid do
            local prev = grid[i][#(grid[i])]
            for j = 1, #(grid[i]) do
                grid[i][j], prev = prev, grid[i][j]
            end
        end
        return true
    end
}
require("cellular-automaton").register_animation(config)

vim.api.nvim_set_keymap('n', '<leader>mir', ':CellularAutomaton make_it_rain<CR>j', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>gol', ':CellularAutomaton game_of_life<CR>j', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>sn', ':CellularAutomaton snake<CR>j', {silent = true})

-- Tree-sitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "vim", "bash", "lua", "python", "cuda", "html", "cmake", "make", "yaml", "vim"},
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- ** LSPConfig **
local lspconfig = require('lspconfig')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})


-- Nvim-Cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {'pyright'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
     settings = {
            python = {
                analysis = {
                    diagnosticSeverityOverrides = {reportGeneralTypeIssues = "warning"},
                    -- You can add other settings here as needed
                }
            }
        }
    }
end


local cmp = require 'cmp'
cmp.setup {
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' }
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-j>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
    }),
}

-- required for lsp to start automatically
vim.api.nvim_exec_autocmds("FileType", {})

-- EasyMotion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1
vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-overwin-f)', {})


vim.o.hidden = true
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. "c"

-- SimpylFold
vim.g.SimpylFold_docstring_preview = 1

-- Doge
vim.g.doge_doc_standard_python = 'google'
vim.g.doge_enable_mappings = 0

-- FzF
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>f', ':Ag!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>/', ':BLines<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>b', ':Buffers<CR>', { noremap = true })

-- BufferTabline
local bufferline = require('bufferline')
bufferline.setup({
    options = {
        style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.no_bold,
        },
        diagnostics = "nvim_lsp",

        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " "
              or (e == "warning" and " " or "󰌶 " )
            s = s .. n .. sym
          end
          return s
        end,
        numbers = "id",
    }
})

-- Onedark
require('onedark').setup  {
    -- Main options --
    style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false,  -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'none',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },
    -- Lualine options --
    lualine = {
        transparent = false, -- lualine center bar transparency
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}

-- Lualine
require('lualine').setup()
