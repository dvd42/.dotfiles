vim.api.nvim_set_keymap('n', '<leader>yc', '<Plug>OSCYankOperator', {})
vim.api.nvim_set_keymap('v', '<leader>yc', '<Plug>OSCYankVisual', {})

vim.g.oscyank_max_length = 0
vim.g.oscyank_silent = 0
vim.g.oscyank_trim = 1
vim.g.oscyank_osc52 = "\x1b]52;c;%s\x07"

