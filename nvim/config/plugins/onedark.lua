require('onedark').setup  {
    style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = true,
    term_colors = true,
    ending_tildes = false,
    cmp_itemkind_reverse = false,

    -- Lualine options --
    lualine = {
        transparent = true, -- lualine center bar transparency
    },

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}

vim.cmd([[colorscheme onedark]])
