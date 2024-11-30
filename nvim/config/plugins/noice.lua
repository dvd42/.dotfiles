require("noice").setup({
  lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
    hover = {
      enabled = true,
      silent = false, -- set to true to not show a message if hover is not available
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {}, -- merged with defaults from documentation
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
      view = "hover",
      ---@type NoiceViewOptions
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { 
            concealcursor = "n", conceallevel = 3, 
            winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:NoicePopupmenuSelected,Search:None",

        },
      },
    },

  },
  views = {
    notify = {
        backend = "notify",
        fallback = "mini",
        format = "notify",
        replace = true,
        merge = false,
    },
  },
  routes = {
      {
        view = "split",
        filter = { event = "msg_show", min_height = 10},
      },
      {
        filter = { event = "msg_show", find = "B written" },
        opts = { skip = true },
      },
  },

  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
})

vim.keymap.set('n', '<leader>cc', '<Cmd>Noice dismiss<CR>', { desc = "Clear notify messages", noremap = true, silent = true })
