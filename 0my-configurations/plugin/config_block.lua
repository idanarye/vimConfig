local block = require'block'
block.setup {
}

vim.keymap.set('n', '<Leader>B', block.toggle)
