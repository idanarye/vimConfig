require'lualine'.setup {
    inactive_sections = {
        lualine_a = {
            function()
                return vim.fn.winnr()
            end,
        },
    },
}
