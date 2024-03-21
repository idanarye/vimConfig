require'octo'.setup {
    picker = 'fzf-lua',
    suppress_missing_scope = {
        projects_v2 = true,
    },
}

local ck = require'caskey'
ck.setup {
    mode = {'n'},
    name = 'Octo',
    ['<Leader>go'] = { act = ck.cmd'Octo actions' },
}
