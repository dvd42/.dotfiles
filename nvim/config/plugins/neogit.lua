local neogit = require('neogit')
neogit.setup {}

vim.keymap.set("n", "<leader>gs", ":Neogit <CR>", {desc = "Git", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git diff HEAD", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", {desc = "Git file history", silent = true, noremap = true})
