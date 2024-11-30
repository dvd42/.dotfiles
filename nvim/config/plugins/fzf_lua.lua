require("fzf-lua").setup({"telescope",
  grep = {
    rg_opts = [[--hidden --context 10 --follow -g '!**/wandb/*' -g '!*.json' -g '!.git/*' -g '!*.ipynb' -g '!*.csv' -g '!*.tbx' -g '!*.tmx' ]]
			.. [[ --line-number --no-heading --color=always --smart-case -g "!.git" -e]],

        actions = {
            ["default"] = require("fzf-lua.actions").file_edit,
            ["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
        }
    }
})
vim.keymap.set('n', '<C-f>f', ':FzfLua lines<CR>', {desc= 'Grep open files'})
vim.keymap.set('n', '<C-f>F', ':FzfLua grep<CR><CR>', {desc = 'Grep project files'})
