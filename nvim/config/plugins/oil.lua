require("oil").setup {
    columns = { "icon" },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<M-h>"] = "actions.select_split",
      ["<M-l>"] = "actions.refresh",
    },
    view_options = {
        show_hidden = true,
    },
    vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
}

