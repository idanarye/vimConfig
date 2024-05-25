require'impairative.replicate-unimpaired'()

local impairative = require'impairative'

impairative.toggling {
    disable = ']o',
    enable = '[o',
    toggle = 'yo',
}
:option {
    key = 'e',
    option = 'conceallevel',
    values = {[true] = 2, [false] = 0},
}
:getter_setter {
    key = 'i',
    name = 'inlay hints',
    get = vim.lsp.inlay_hint.is_enabled,
    set = vim.lsp.inlay_hint.enable,
}
