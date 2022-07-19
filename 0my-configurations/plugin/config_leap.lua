local leap = require'leap'

leap.setup {
}

vim.keymap.set({'n', 'v'}, '<Leader><Leader>s', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'v'}, '<Leader><Leader>S', '<Plug>(leap-backward)')

vim.keymap.set('o', '<Leader><Leader>z', '<Plug>(leap-forward)')
vim.keymap.set('o', '<Leader><Leader>Z', '<Plug>(leap-backward)')
vim.keymap.set('o', '<Leader><Leader>x', '<Plug>(leap-forward-x)')
vim.keymap.set('o', '<Leader><Leader>X', '<Plug>(leap-backward-x)')
