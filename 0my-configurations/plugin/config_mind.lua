local mind = require'mind'

mind.setup {
}

vim.keymap.set('n', '<M-w><M-w>', function()
    mind.open_main()
end)
vim.keymap.set('n', '<M-w>p', function()
    mind.open_project(true)
end)
