local M = {}

function M.init()
  -- UI preferences
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_execute_on_save = false
  vim.g.omni_sql_no_default_maps = true

  -- Toggle DBUI
  vim.keymap.set('n', '<leader>w', ':DBUIToggle<CR>', { desc = 'DBUI', noremap = true, silent = true })

  -- Execute query mapping for SQL buffers
  local exec = '<Plug>(DBUI_ExecuteQuery)'
  vim.api.nvim_create_autocmd('FileType', {
    pattern  = { 'sql', 'mysql', 'plsql' },
    callback = function(ev)
      vim.keymap.set('n', 'BB', exec, { buffer = ev.buf, silent = true, desc = 'Execute SQL via Dadbod' })
      vim.keymap.set('v', 'BB', exec, { buffer = ev.buf, silent = true, desc = 'Execute SQL via Dadbod' })
    end,
  })
end

return M

