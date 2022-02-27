require'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
    indent = {
        enable = true,
        disable = { 'rust' }, -- I only want this for Python
    },
}
