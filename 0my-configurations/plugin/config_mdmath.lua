local mdmath = require'mdmath'
mdmath.setup {
    filetypes = {'markdown'},
}

require'idan.impairative-toggling':manual {
    key = 'm',
    name = 'MdMath',
    enable = mdmath.enable,
    disable = mdmath.disable,
    toggle = function()
        if next(vim.api.nvim_get_autocmds{buf = 0, group = 'MdMathManager'}) then
            mdmath.disable()
        else
            mdmath.enable()
        end
    end,
}
