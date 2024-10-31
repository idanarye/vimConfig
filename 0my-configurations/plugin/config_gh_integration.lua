require'ghlite'.setup {
    open_command = 'xdg-open',
}

local ck = require'caskey'
ck.setup {
    mode = {'n'},
    name = 'GHLite',
    ['<Leader>g'] = {
    },
}
