local neogit = require('neogit')
neogit.setup {}

vim.keymap.set("n", "<leader>gs", ":Neogit <CR>", {desc = "Git", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gd", ":CodeDiff file HEAD<CR>", { desc = "Git diff HEAD", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gD", ":CodeDiff<CR>", { desc = "Git diff current buffer HEAD", silent = true, noremap = true})
