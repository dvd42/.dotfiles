local cmp = require 'cmp'
local lspkind = require 'lspkind'

local borderstyle = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            zindex = 1001,
            scrollbar = true,
            scrolloff = 0,
            col_offset = 0,
            side_padding = 1,
            winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:CursorColumn,Search:None",
}

cmp.setup {
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
        -- { name = 'nvim_lsp_signature_help' },
        { name = "jupynium", priority = 1000 },
        { name = 'nvim_lsp' },
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
        ['<C-Space>'] = cmp.mapping.complete(),
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
}
