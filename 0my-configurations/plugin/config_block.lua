local block = require'block'
block.setup {
    automatic = true,
}

vim.keymap.set('n', '<Leader>B', block.toggle)
