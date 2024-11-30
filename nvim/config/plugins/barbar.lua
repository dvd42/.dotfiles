vim.g.barbar_auto_setup = false -- disable auto-setup

require'barbar'.setup {

  icons = {
    -- Configure the base icons on the bufferline.
    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
    button = '',
    buffer_index = true,
    separator_at_end = true,
    highlight_visible = false,
    gitsigns = {
          added = {enabled = true, icon =  " "},
          changed = {enabled = true, icon = " "},
          deleted = {enabled = true, icon = " "},
        },

    preset = 'default',
  },

}

local map = vim.api.nvim_set_keymap
local function desc_opts(description)
    return { noremap = true, silent = true, desc = description }
end

-- Move to previous/next
map('n', '<tab>', '<Cmd>BufferNext<CR>', desc_opts("Move to next buffer"))
map('n', '<s-tab>', '<Cmd>BufferPrevious<CR>', desc_opts("Move to previous buffer"))

-- Re-order to previous/next
map('n', '<leader><', '<Cmd>BufferMovePrevious<CR>', desc_opts("Move buffer to previous position"))
map('n', '<leader>>', '<Cmd>BufferMoveNext<CR>', desc_opts("Move buffer to next position"))

-- Goto buffer in position...
for i = 1, 9 do
    map('n', '<leader>' .. i, '<Cmd>BufferGoto ' .. i .. '<CR>', desc_opts("Go to buffer " .. i))
end
map('n', '<leader>0', '<Cmd>BufferLast<CR>', desc_opts("Go to last buffer"))

-- Close buffer
map('n', '<leader>bc', '<Cmd>BufferClose<CR>', desc_opts("Close current buffer"))
map('n', '<leader>ac', '<Cmd>BufferCloseAllButCurrent<CR>', desc_opts("Close all but the current buffer"))
map('n', '<leader>pd', '<Cmd>BufferPickDelete<CR>', desc_opts("Pick and delete a buffer"))

-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', desc_opts("Sort buffers by number"))
map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', desc_opts("Sort buffers by name"))
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', desc_opts("Sort buffers by directory"))
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', desc_opts("Sort buffers by language"))
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', desc_opts("Sort buffers by window number"))
