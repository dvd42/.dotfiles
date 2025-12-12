local lspconfig = vim.lsp.config

-- Disable hover for Ruff so Pyright “wins” on K
local function ruff_on_attach(client, bufnr)
    client.server_capabilities.hoverProvider = false
end

lspconfig('basedpyright', {
  -- capabilities = capabilities,
  settings = {
    basedpyright = {
      -- Same idea as your old pyright.disableOrganizeImports
      -- Let Ruff handle imports instead.
      disableOrganizeImports = true,

      analysis = {
        -- "openFilesOnly" (lighter, default) or "workspace" (full project)
        diagnosticMode = "workspace",
        typeCheckingMode = "standard", -- or "strict", "basic"
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
        autoSearchPaths = true,

        inlayHints = {
          variableTypes      = true,
          callArgumentNames  = true,
          functionReturnTypes = true,
          genericTypes       = true,
        },
      },
    },
  },
})

lspconfig('ruff', {
    on_attach = ruff_on_attach,

    init_options = {
        settings = {
            configurationPreference = "filesystemFirst",

            fixAll = true,
            organizeImports = true,
            showSyntaxErrors = true,

            codeAction = {
                -- Keep both Quick Fix styles enabled:
                disableRuleComment = {
                    enable = true, -- “Add noqa comment” code actions :contentReference[oaicite:3]{index=3}
                },
                fixViolation = {
                    enable = true, -- “Fix this violation” code actions :contentReference[oaicite:4]{index=4}
                },
            },

            lint = {
                enable = true,
                extendSelect = { "RUF", "A", "F", "E", "W", "B", "ARG", "ASYNC", "RET", "SIM",
                    "PLE", "PLW0245", "PLW2901", "PLW0177", "PLW0128", "PLW0406",
                    "PLW0603", "PLW0711", "PLW1501", "PLR1711", "PLR5501", "PLR1733",
                    "PLR1736", "PLR0124", "PLR1714", "PLR2004", "PLC2801", "RET504"
                }
            },

            format = {
                backend = "internal",
            },
        },
    },
})

-- Keep your enables as-is
vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')
vim.lsp.enable('lua_ls')


vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
    { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
        vim.keymap.set('i', '<C-d>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Show signature help" })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Go to type definition" })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Show code actions" })
        vim.keymap.set('n', '<leader>ft', function()
            vim.lsp.buf.code_action({
                context = { only = { 'source.fixAll.ruff' } },
                apply = true
            })
            vim.lsp.buf.code_action({
                context = { only = { 'source.organizeImports' } },
                apply = true
            })
            vim.lsp.buf.format({ buffer = ev.buf, desc = "Format buffer" })
        end, { buffer = ev.buf, desc = "Fix all Ruff issues" })
    end,
})

-- Toggle inlay hints
vim.keymap.set("n", "<leader>th", function()
  local buf = vim.api.nvim_get_current_buf()

  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
end, { desc = "Toggle inlay hints" })
