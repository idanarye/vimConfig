local peek = require'peek'

peek.setup {
    app = 'browser',
}

vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
vim.api.nvim_create_user_command('PeekClose', peek.close, {})
