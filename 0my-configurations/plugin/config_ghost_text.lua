vim.g.nvim_ghost_autostart = 0

local augroup = vim.api.nvim_create_augroup('nvim_ghost_user_autocommands', {})

vim.api.nvim_create_autocmd('User', {
    group = augroup,
    pattern = {'*github.com'},
    callback = function()
        vim.o.filetype = 'markdown'
    end,
})
