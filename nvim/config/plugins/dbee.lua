require("dbee").setup {
    sources = {
        require("dbee.sources").MemorySource:new({
           {
             name = "data_warehouse",
             type = "redshift",
             url = "postgres://{{ env \"REDSHIFT_USER\" }}:{{ env `DB_PASSWORD` }}@bi.c96b1crcgfzs.us-west-2.redshift.amazonaws.com:5439/data_warehouse",
           },
        }),
    },
}

vim.api.nvim_set_keymap('n', '<leader>w', ':Dbee toggle<CR>', { desc="Query database", noremap = true, silent = true })
