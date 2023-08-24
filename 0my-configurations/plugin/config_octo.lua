require'octo'.setup {
    picker = 'fzf-lua',
}

local ck = require'caskey'
ck.setup {
    mode = {'n'},
    name = 'Octo',
    ['<Leader>go'] = { act = ck.cmd'Octo actions' },
}
