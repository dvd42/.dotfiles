-- local null_ls = require("null-ls")

-- null_ls.setup({
--   ensure_installed = { "black", "flake8"},
--   sources = {
--     null_ls.builtins.formatting.black.with({
--         extra_args = {"--line-length", "100"}
--     }),
--     require('none-ls.diagnostics.flake8').with({
--         extra_args = {"--max-line-length", "100", "--extend-ignore=E203,W503,E501"}
--     }),

--     null_ls.builtins.formatting.isort.with({
--         extra_args = {"--line-length", "100", "--profile", "black", "--skip-gitignore"}
--     }),

--     null_ls.builtins.code_actions.refactoring,
--     },
-- })

