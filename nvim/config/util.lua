-- *** This file holds some custom functions and commands ***
vim.api.nvim_create_user_command('Clean', function()
    vim.fn.system('rm ~/.dotfiles/nvim/swap/*')
end, {})
