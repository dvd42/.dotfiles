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
    -- { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true,

    -- config = function()
    --     vim.cmd([[colorscheme gruvbox]])
    -- end,
    -- },
    {"navarasu/onedark.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1005, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme onedark]])
    end,
    },
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
    {"ojroques/vim-oscyank", branch = "main"},
    {"tmhedberg/SimpylFold"},
    {"neomake/neomake"},
    {"tpope/vim-fugitive"},
    {"christoomey/vim-tmux-navigator"},
    {"kkoomen/vim-doge", build = ":doge#install()"},
    {"tpope/vim-commentary"},
    {"roxma/vim-tmux-clipboard"},
    {"rbgrouleff/bclose.vim"},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"easymotion/vim-easymotion"},
    {"junegunn/fzf", build = ":fzf#install()"},
    {"junegunn/fzf.vim"},
    {"neoclide/coc.nvim", branch = "release"},
    {"eandrju/cellular-automaton.nvim"}

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
vim.api.nvim_set_keymap('n', '<leader>fml', ':CellularAutomaton game_of_life<CR>j', {silent = true})
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

-- EasyMotion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1
vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-overwin-f)', {})

-- *** CoC ***
-- use <tab> to trigger completion and navigate to the next complete item
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end


vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : v:lua.check_back_space() ? "\\<Tab>" : coc#refresh()', { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true })
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? coc#pum#confirm() : "\\<CR>"', { noremap = true, expr = true })


vim.o.hidden = true
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. "c"


vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', 'g]', '<Plug>(coc-diagnostic-next)', { noremap = false, silent = true })

vim.api.nvim_set_keymap('n', "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.api.nvim_command("autocmd CursorHold * silent call CocActionAsync('highlight')")


vim.api.nvim_set_keymap('n', '<leader>j', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', { noremap = false, silent = true, expr = true, nowait = true })
vim.api.nvim_set_keymap('n', '<leader>k', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', { noremap = false, silent = true, expr = true, nowait = true })
vim.api.nvim_set_keymap('i', '<leader>j', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1) <cr>" : "<Right>"', { silent = true, expr = true, nowait = true })
vim.api.nvim_set_keymap('i', '<leader>k', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0) <cr>" : "<Left>"', { silent = true, expr = true, nowait = true })
vim.api.nvim_set_keymap('v', '<leader>j', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', { noremap = false, silent = true, expr = true, nowait = true })
vim.api.nvim_set_keymap('v', '<leader>k', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', { noremap = false, silent = true, expr = true, nowait = true })


vim.api.nvim_command("command! -nargs=0 Format :call CocActionAsync('format')")

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
        diagnostics = "coc",

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
