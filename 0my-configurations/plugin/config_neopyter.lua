local ck = require'caskey'

require'neopyter'.setup {
    on_attach = function(buf_nr)
        ck.emit('NeopyterAttach', buf_nr)
    end,
}

ck.setup {
    when = ck.emitted'NeopyterAttach',
    name = 'Neopyter',
    ['<C-Cr>'] = {
        mode = {'n', 'i'},
        act = ck.cmd'Neopyter execute notebook:run-cell',
    },
    ['<LocalLeader>'] = {
        mode = 'n',
        ['X'] = { act = ck.cmd'Neopyter execute notebook:run-all-above' },
    }
}
