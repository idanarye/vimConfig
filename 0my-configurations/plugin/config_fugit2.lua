local fugit2 = require'fugit2'

pcall(fugit2.setup, {
})

local ck = require'caskey'

ck.setup {
    mode = 'n',
    name = 'Fugit2',
    ['<Leader>g'] = {
        ['g'] = { act = fugit2.git_status, desc = 'Show Fugit2 status panel' },
    },
}
