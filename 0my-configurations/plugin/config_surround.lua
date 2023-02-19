--local config = require'nvim-surround.config'
require'nvim-surround'.setup {
    surrounds = {
        --['\29'] = {
        --[config.termcode'<C-]>'] = {
        ['<C-]>'] = {
            add = { '{{', '}}' },
            --find = function()
                --return M.get_selection({ motion = "a)" })
            --end,
            --delete = "^(.)().-(.)()$",
        },
    },
}
