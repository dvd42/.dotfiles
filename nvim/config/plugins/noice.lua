require("noice").setup({
  notify = { enabled = false, },
  lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
    hover = {
      enabled = true,
      silent = false,
      view = "hover",
      opts = {
        win_options = {
          conceallevel = 0,
          concealcursor = "",
        },
      },
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
      opts = {
        lang = "markdown",
        replace = true,
        format = { "{message}" },
        win_options = {
          conceallevel = 0,
          concealcursor = "",
        },
      },
    },

  },
  routes = {
      -- Make gitsigns hunk navigation messages readable
      {
        view = "notify",
        filter = {
          event = "msg_show",
          any = {
            { find = "^Hunk %d+ of %d+" },
            { find = "^No hunks$" },
            { find = "^No more hunks$" },
          },
        },
      opts = { format = { { "{message}", hl_group = "Normal" } }, replace = true },
      },
      {
        view = "split",
        filter = { event = "msg_show", min_height = 10 },
      },
      {
        filter = { event = "msg_show", find = "B written" },
        opts = { skip = true },
      },
  },

  -- Unify hover/signature styling with cmp
  views = {
    hover = {
      border = { style = "rounded" },
      zindex = 1001,
      scrollbar = false,
      win_options = {
        conceallevel = 0,
        concealcursor = "",
        winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:CursorColumn,Search:None",
      },
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
