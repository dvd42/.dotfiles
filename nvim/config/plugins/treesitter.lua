require'nvim-treesitter.configs'.setup {
    ensure_installed = { "query", "markdown", "regex", "markdown_inline", "c", "cpp", "bash", "lua", "python", "cuda", "html", "cmake", "make", "yaml", "vim", "vimdoc" },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
