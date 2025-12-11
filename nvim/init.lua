vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0


-- Leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = vim.g.mapleader

vim.keymap.set("n", "<leader>o", "<cmd>update<bar>source %<CR>", {
  desc = "Save and reload init.lua",
  noremap = true,
  silent = true,
})

local o, wo, opt = vim.o, vim.wo, vim.opt

-- UI
wo.number         = true
wo.relativenumber = true
o.winborder       = "rounded"
o.textwidth       = 100
o.showmatch       = true
o.smartindent     = true

-- Allow 2 sign columns (diagnostics + gitsigns etc.)
opt.signcolumn = "yes:2"

-- Clipboard / mouse
o.clipboard    = "unnamedplus"
o.mouse        = ""
opt.mousescroll = "ver:0,hor:0"


-- Diff behaviour
opt.diffopt:append("algorithm:patience")

-- Search
o.ignorecase = true
o.smartcase  = true
o.gdefault   = true
o.hlsearch   = false

opt.laststatus = 3

-- Indentation
o.expandtab   = true
o.tabstop     = 4
o.softtabstop = 4
o.shiftwidth  = 4

-- Folding (Tree-sitter)
wo.foldenable   = false
opt.foldmethod  = "expr"
opt.foldexpr    = "v:lua.vim.treesitter.foldexpr()"

-- Split behaviour
o.splitbelow = true
o.splitright = true
opt.splitkeep = "screen"


-- Mappings
local mappings = {
  -- Folding
  { "n", "<space>", "za",                           "Toggle fold" },
  { "n", "zf",      "zM",                           "Fold all" },
  { "n", "zo",      "zR",                           "Open all folds" },

  -- Move code blocks (keep selection)
  { "v", "<",       "<gv",                          "Indent left" },
  { "v", ">",       ">gv",                          "Indent right" },

  -- Resize split windows
  { "n", "<Up>",    "<C-W>-<C-W>-",                 "Decrease split height" },
  { "n", "<Down>",  "<C-W>+<C-W>+",                 "Increase split height" },
  { "n", "<Left>",  "<C-W>><C-W>>",                 "Increase split width" },
  { "n", "<Right>", "<C-W><<C-W><",                 "Decrease split width" },

  -- Window navigation
  { "n", "<C-J>",   "<C-W><C-J>",                   "Go to split below" },
  { "n", "<C-K>",   "<C-W><C-K>",                   "Go to split above" },
  { "n", "<C-L>",   "<C-W><C-L>",                   "Go to split right" },
  { "n", "<C-H>",   "<C-W><C-H>",                   "Go to split left" },

  -- Python breakpoint
  { "n", "<C-b>",   "Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>",
                    "Insert Python ipdb breakpoint" },
}

for _, map in ipairs(mappings) do
  local mode, lhs, rhs, desc = unpack(map)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
end

opt.swapfile = false
opt.undofile = true

-- Plugin loading
local home = vim.loop.os_homedir()
local config_path = home .. "/.dotfiles/nvim/config"
package.path = package.path .. ";" .. config_path .. "/?.lua"

require("plugins")
