local cmp = require 'cmp'
local lspkind = require 'lspkind'

local borderstyle = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            zindex = 1001,
            scrollbar = false,
            winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:CursorColumn,Search:None",
}

cmp.setup({
window = {
    completion = borderstyle,
    documentation = borderstyle
  },
     formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          show_labelDetails = true,}),
     },
     sorting = {
        priority_weight = 1,
        comparators = {
          cmp.config.compare.score,
          cmp.config.compare.exact,
          cmp.config.compare.offset,
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
        {
            name = 'path',
                option = {
                    get_cwd = function() return vim.fn.resolve(vim.fn.getcwd()) end

                },
        },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-j>'] = cmp.mapping.scroll_docs(4), -- Down
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,  -- confirm first item if none selected
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
    }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    require('cmp').setup.buffer({
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })
  end,
})
