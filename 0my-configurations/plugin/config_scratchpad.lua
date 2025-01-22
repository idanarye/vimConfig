local scratchpad = require'scratchpad'

scratchpad.setup {
}

local ck = require'caskey'

ck.setup {
    mode = 'n',
    name = 'scratchpad',

    ['<M-s>'] = {
        ['e'] = { act = function()
            scratchpad.ui:new_scratchpad()
        end, desc = 'open scratchpad'},
        ['p'] = { mode = {'n', 'v'}, act = function()
            scratchpad.ui:sync()
        end, desc = 'push selection'},
    }
}
