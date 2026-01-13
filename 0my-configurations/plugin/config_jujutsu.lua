require'lazyjj'.setup {
    mapping = '<Leader><C-j>'  -- NOTE: This is the default
}

require'jujutsu-nvim'.setup {
    diff_preset = 'diffview',  -- NOTE: default is difftastic but I don't have it installed
}

local ck = require'caskey'

ck.setup {
    mode = {'n'},
    ['<Leader>j'] = {
        ['j'] = {act = ck.cmd'JJ', desc = 'Run JJ (Jujutsu)'},
    },
}
