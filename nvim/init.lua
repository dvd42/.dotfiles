-- Fixes
vim.o.guicursor = ""

-- Remap Leader
vim.g.mapleader = ","

-- General settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.showcmd = true
vim.o.showmode = true
vim.o.ruler = true
vim.o.textwidth = 155
vim.o.formatoptions = vim.o.formatoptions:gsub('t', '')
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.showmatch = true
vim.wo.foldenable = true
vim.o.autoread = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.o.encoding = 'utf-8'

-- Color settings
vim.cmd[[
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark

highlight CocErrorHighlight ctermfg=Red  guifg=Red
highlight CocWarningHighlight ctermfg=DarkYellow guifg=DarkYellow
highlight CocWarningSign ctermfg=DarkYellow guifg=DarkYellow
]]

vim.o.clipboard = "unnamedplus"
vim.o.mouse = ""
vim.o.pumblend = 0

-- Code
vim.cmd("syntax on")
vim.cmd("syntax enable")

vim.o.diffopt = vim.o.diffopt .. ",algorithm:patience,indent-heuristic"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.gdefault = true
vim.o.magic = true
vim.o.laststatus = 2

-- Indentation
vim.cmd("filetype plugin indent on")
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true

-- Folding
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99

-- Fonts
vim.g.enable_bold_font = 1
vim.g.enable_italic_font = 1

-- Remappings
local mappings = {
    -- Folding
    { "n", "<space>", "za" },
    { "n", "zf", "zM" },
    { "n", "zo", "zR" },
    -- Moving code blocks
    { "v", "<", "<gv" },
    { "v", ">", ">gv" },
    -- Resize split windows
    { "n", "<Up>", "<C-W>-<C-W>-" },
    { "n", "<Down>", "<C-W>+<C-W>+" },
    { "n", "<Left>", "<C-W>><C-W>>" },
    { "n", "<Right>", "<C-W><<C-W><" },
    -- Disable arrow keys in insert mode
    { "i", "<Up>", "<NOP>" },
    { "i", "<Down>", "<NOP>" },
    { "i", "<Left>", "<NOP>" },
    { "i", "<Right>", "<NOP>" },
    -- Split navigations
    { "n", "<C-J>", "<C-W><C-J>" },
    { "n", "<C-K>", "<C-W><C-K>" },
    { "n", "<C-L>", "<C-W><C-L>" },
    { "n", "<C-H>", "<C-W><C-H>" },
    -- Insert breakpoints
    { "", "<C-b>", "Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>" },
    -- Switch buffer on tab
    { "n", "<tab>", ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>" },
    { "n", "<s-tab>", ":if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>" },
}

for _, map in ipairs(mappings) do
    vim.api.nvim_set_keymap(map[1], map[2], map[3], { noremap = true, silent = true })
end

vim.o.nohlsearch = true
vim.o.hlsearch = false


-- Autocommands
vim.cmd[[
augroup MyAutoCmd
  autocmd!
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd BufWritePre * %s/\s\+$//e
augroup END
]]

vim.o.splitbelow = true
vim.o.splitright = true

local home = os.getenv("HOME")

-- Backups
vim.o.undodir = home .. "/.dotfiles/nvim/undodir"
vim.o.undofile = true
vim.o.undolevels = 700
vim.o.history = 700
vim.o.undoreload = 1000

-- Source plugins and custom functions
local config_path = home .. "/.dotfiles/nvim/config"
package.path = package.path .. ';' .. config_path .. '/?.lua'
require("plugins")
-- vim.cmd("source $HOME/.dotfiles/nvim/config/util.vim")
