-- Remap Leader
vim.g.mapleader = ","
-- this HAS to be at the top for some reason
vim.cmd [[ hi DevIconDefaultCurrent ctermfg=255 guibg=#282830 ]]

-- General settings
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.showcmd = true
vim.o.showmode = true
vim.o.ruler = true
vim.o.textwidth = 155
vim.o.formatoptions = vim.o.formatoptions:gsub('t', '')
vim.o.wildmenu = true
vim.o.showmatch = true
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
]]

vim.o.clipboard = "unnamedplus"
vim.o.mouse = ""
vim.opt.mousescroll = "ver:0,hor:0" 

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
vim.wo.foldenable = false
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

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
    { "v", "<", "<gv", "Indent left" },
    { "v", ">", ">gv", "Indent right" },
    -- Resize split windows
    { "n", "<Up>", "<C-W>-<C-W>-" },
    { "n", "<Down>", "<C-W>+<C-W>+" },
    { "n", "<Left>", "<C-W>><C-W>>" },
    { "n", "<Right>", "<C-W><<C-W><" },
    -- Disable arrow keys in insert mode
    -- Split navigations
    { "n", "<C-J>", "<C-W><C-J>" },
    { "n", "<C-K>", "<C-W><C-K>" },
    { "n", "<C-L>", "<C-W><C-L>" },
    { "n", "<C-H>", "<C-W><C-H>" },
    -- Insert breakpoints
    { "n", "<C-b>", "Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>", "Insert breakpoint" },
    -- Switch buffer on tab
}

for _, map in ipairs(mappings) do
    vim.keymap.set(map[1], map[2], map[3], {desc = map[4], noremap = true, silent = true })
end

-- vim.o.nohlsearch = true
vim.o.hlsearch = false

vim.o.splitbelow = true
vim.o.splitright = true

local home = os.getenv("HOME")

-- Backups
vim.o.undodir = home .. "/.dotfiles/nvim/undodir"
vim.o.undofile = true
vim.o.undolevels = 700
vim.o.history = 700
vim.o.undoreload = 1000
vim.opt.backup = true
-- Set the backup directory
vim.opt.backupdir = home .. '/.dotfiles/nvim/backup//'
vim.opt.directory:prepend(home .. '/.dotfiles/nvim/swap//')
-- Ensure the directory exists
local backupdir = home .. '/.dotfiles/nvim/backup'
local swapdir = home .. '/.dotfiles/nvim/swap'

if vim.fn.isdirectory(backupdir) == 0 then
    vim.fn.mkdir(backupdir, 'p')
end

if vim.fn.isdirectory(swapdir) == 0 then
    vim.fn.mkdir(swapdir, 'p')
end

-- Source plugins and custom functions
local config_path = home .. "/.dotfiles/nvim/config"
package.path = package.path .. ';' .. config_path .. '/?.lua'
require("plugins")
require('util')

vim.cmd [[
  hi BufferDefaultCurrentSign ctermfg=255 guifg=#cdcdcd guibg=#282830
  hi BufferDefaultCurrentCHANGED ctermfg=255 guibg=#282830
  hi BufferDefaultCurrentADDED ctermfg=255 guibg=#282830
  hi BufferDefaultCurrentDELETED ctermfg=255 guibg=#282830
  hi BufferDefaultCurrentIndex ctermfg=255 guifg=#d2a374 guibg=#282830
  hi BufferDefaultCurrentTarget ctermfg=255 guibg=#282830
  hi BufferDefaultCurrent ctermfg=255 guifg=#d2a374 guibg=#282830
  hi BufferDefaultInactive ctermfg=255 guifg=#7894ab guibg=#282830
  hi BufferDefaultCurrentMod ctermfg=255 guifg=#d2a374 guibg=#282830
]]

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    math.randomseed(os.time())
    local fg_color = tostring(math.random(0, 12))
    local hi_setter = "hi AlphaHeader ctermfg="
    vim.cmd(hi_setter .. fg_color)
  end
})
