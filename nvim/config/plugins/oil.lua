require("oil").setup {
    lsp_file_methods = {
        -- Enable or disable LSP file operations (rename, move, etc.)
        enabled = true,
        -- How long to wait for LSP responses before giving up
        timeout_ms = 1000,
        -- Automatically save buffers that were changed by LSP rename edits:
        --   false       -> do not autosave
        --   true        -> save all affected buffers
        --   "unmodified"-> save only buffers that were not already modified
        autosave_changes = "unmodified",
    },
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

