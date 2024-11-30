local neogit = require('neogit')
neogit.setup {}

vim.keymap.set("n", "<leader>gs", ":Neogit <CR>", {desc = "Git", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", {desc = "Git commit", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>", { desc = "Git pull", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>", { desc = "Git push", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gl", neogit.action('log', 'log_current', {'--graph', '--decorate'}), {desc = "Git log", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git diff HEAD", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gD", ":DiffviewOpen main<CR>", { desc = "Git diff main", silent = true, noremap = true})
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", {desc = "Git file history", silent = true, noremap = true})



