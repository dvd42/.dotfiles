vim.keymap.set("n", "<leader>t", "<cmd>Copilot panel<CR>", { desc = "Toggle copilot panel", silent = true, noremap = true})
require('copilot').setup({
    panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<leader>t"
        },
        layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept = "<Right>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
    },
    filetypes = {
        ["."] = true,
        ["*"] = true,
    },
    copilot_node_command = 'node', -- Node.js version must be > 18.x
    server_opts_overrides = {},
})

