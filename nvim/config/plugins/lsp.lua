local lspconfig = vim.lsp.config

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

-- Disable hover for Ruff so Pyright “wins” on K
local function ruff_on_attach(client, bufnr)
    client.server_capabilities.hoverProvider = false
end

lspconfig('pyright', {
    capabilities = capabilities,
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
    },
    handlers = {
        [vim.lsp.protocol.Methods.textDocument_rename] = function(err, result, ctx)
            if err then
                vim.notify('Pyright rename failed: ' .. err.message, vim.log.levels.ERROR)
                return
            end

            for _, change in ipairs(result.documentChanges or {}) do
                for _, edit in ipairs(change.edits or {}) do
                    if edit.annotationId then
                        edit.annotationId = nil
                    end
                end
            end

            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
        end,
    },
})

lspconfig('ruff', {
    capabilities = capabilities,
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
vim.lsp.enable('pyright')
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
