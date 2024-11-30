-- Global mappings.

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local lspconfig = require('lspconfig')


local border = {
    {"╭", "NoiceCmdlinePopupBorder" },
    {"─", "NoiceCmdlinePopupBorder"},
    {"╮", "NoiceCmdlinePopupBorder"},
    {"│", "NoiceCmdlinePopupBorder"},
    {"╯", "NoiceCmdlinePopupBorder"},
    {"─", "NoiceCmdlinePopupBorder"},
    {"╰", "NoiceCmdlinePopupBorder"},
    {"│", "NoiceCmdlinePopupBorder" },
}
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 } 

lspconfig.pyright.setup {
  handlers = handlers,
  capabilities = capabilities,
   settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
      }
}

local on_attach = function(client, bufnr)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
end

-- Find the nearest pyproject.toml or ruff.toml file
local function find_config_file(startpath, max_levels)
    local dir = startpath
    for _ = 1, max_levels do
        if vim.fn.filereadable(dir .. "/pyproject.toml") == 1 then
            return dir .. "/pyproject.toml"
        elseif vim.fn.filereadable(dir .. "/ruff.toml") == 1 then
            return dir .. "/ruff.toml"
        else
            local parent_dir = vim.fn.fnamemodify(dir, ":h")
            if parent_dir == dir then
                break
            else
                dir = parent_dir
            end
        end
    end
    return nil
end

require('lspconfig').ruff_lsp.setup {
    on_attach = on_attach,
    on_new_config = function(new_config, new_root_dir)
        local function get_ruff_config()
            local config_file = find_config_file(new_root_dir, 5)
            if config_file then
                return { "--config", config_file }
            else
                return {
                    "--extend-select",
                    table.concat({
                        "RUF", "A", "F", "E", "W", "B", "ARG", "ASYNC", "RET", "SIM",
                        "PLE", "PLW0245", "PLW2901", "PLW0177", "PLW0128", "PLW0406",
                        "PLW0603", "PLW0711", "PLW1501", "PLR1711", "PLR5501", "PLR1733",
                        "PLR1736", "PLR0124", "PLR1714", "PLR2004", "PLC2801"
                    }, ","),
                    "--ignore",
                    table.concat({
                        "E501", "B904", "RET504", "PLR6301", "RUF012", "RUF001", "RUF002",
                        "RUF031", "A005", "RUF022", "RUF010", "B009", "SIM115", "SIM108", "SIM401"
                    }, ",")
                }
            end
        end

        new_config.init_options = new_config.init_options or {}
        new_config.init_options.settings = new_config.init_options.settings or {}
        new_config.init_options.settings.args = get_ruff_config()
    end,
}


vim.keymap.set('n', '<leader>i', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
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
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = "Show references" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Show code actions" })
    vim.keymap.set('n', '<leader>ft', function()
        vim.lsp.buf.code_action({
            context = { only = { 'source.fixAll.ruff' } },
            apply = true
        })
        vim.lsp.buf.code_action({
            context = { only = { 'source.organizeImports.ruff' } },
            apply = true
        })
        vim.lsp.buf.format({ buffer = ev.buf, desc = "Format buffer" })
    end, { buffer = ev.buf, desc = "Fix all Ruff issues" })

  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.opt.foldmethod = "syntax"
    end
  end,
})
