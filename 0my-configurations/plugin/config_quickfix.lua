local quicker = require'quicker'
local ck = require'caskey'

quicker.setup {
    edit = {
        enabled = false,
    },
}

ck.setup {
    mode = 'n',
    name = 'quickfix',

    ['<M-q>'] = {
        ['r'] = { act = function()
            quicker.refresh()
        end, desc = 'refresh Quicker buffer ' },
        ['q'] = { act = function()
            quicker.toggle {
            }
        end, desc = 'toggle Quicker quickfix ' },
        ['Q'] = { act = function()
            quicker.open {
                focus = true,
            }
        end, desc = 'focus Quicker quickfix ' },
        ['l'] = { act = function()
            quicker.toggle {
                loclist = true,
            }
        end, desc = 'toggle Quicker loclist ' },
        ['L'] = { act = function()
            quicker.open {
                loclist = true,
                focus = true,
            }
        end, desc = 'focus Quicker loclist ' },
    },
}
