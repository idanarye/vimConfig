require'neogen'.setup {
    snippet_engine = 'luasnip',
    languages = {
        python = {
            template = {
                annotation_convention = "reST",
            },
        },
        rust = {
            template = {
                annotation_convention = "rust_alternative",
            },
        },
    },
}
