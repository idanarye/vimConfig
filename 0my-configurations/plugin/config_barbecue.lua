require'barbecue'.setup {
    -- show_navic = false,
}

local barbecue_ui = require'barbecue.ui'
barbecue_ui.toggle(false)

vim.keymap.set('n', '<Leader>C', barbecue_ui.toggle)
