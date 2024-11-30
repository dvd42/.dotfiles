-- ** Telescope **
require("notify").setup({
  background_colour = "#000000",
})
local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require('telescope.actions').close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format('%s %s', 'edit', j.path))
      end
    end
  else
    require('telescope.actions').select_default(prompt_bufnr)
  end

end


require('telescope').setup({

    extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                           -- the default case_mode is "smart_case"
        }
    },
    defaults = {
        prompt_prefix = "󰼛 ",

        mappings = {
          i = {
            ['<CR>'] = select_one_or_multi,
          }
        },

        selection_caret = "󱞩 ",

      },
      pickers = {
        find_files = {
          hidden = true,
          -- needed to exclude some files & dirs from general search
          -- when not included or specified in .gitignore
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!*git/*",
            "--glob=!**/wandb/*",
            "--glob=!**/mlruns/*",
            "--glob=!**/.idea/*",
            "--glob=!**/*.csv",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },
        },
      },
})

local builtin = require('telescope.builtin')
require('telescope').load_extension('fzf')
require('telescope').load_extension('noice')

vim.keymap.set('n', '<C-p>', builtin.find_files, {desc = "Search files"})
vim.keymap.set('n', '<C-f>b', builtin.buffers, {desc = "Search buffers"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Search help"})

