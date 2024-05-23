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
