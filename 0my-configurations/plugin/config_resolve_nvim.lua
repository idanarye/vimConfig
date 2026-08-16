require'resolve'.setup {
    default_keymaps = false,
}

local ck = require'caskey'
ck.setup {
    mode = {'n'},
    name = 'resolve.nvim',
    ['<Leader>C'] = {
        ['o'] = { act = '<Plug>(resolve-ours)', desc = 'Choose ours' },
        ['t'] = { act = '<Plug>(resolve-theirs)', desc = 'Choose theirs' },
        ['b'] = { act = '<Plug>(resolve-both)', desc = 'Choose both' },
        ['B'] = { act = '<Plug>(resolve-both-reverse)', desc = 'Choose both (reverse)' },
        ['m'] = { act = '<Plug>(resolve-base)', desc = 'Choose base' },
        ['n'] = { act = '<Plug>(resolve-none)', desc = 'Choose none' },
        ['l'] = { act = '<Plug>(resolve-list)', desc = 'List conflicts' },
        ['d'] = {
            name = 'resolve.nvim diff',
            ['do'] = { act = '<Plug>(resolve-diff-ours)', desc = 'Diff ours' },
            ['dt'] = { act = '<Plug>(resolve-diff-theirs)', desc = 'Diff theirs' },
            ['db'] = { act = '<Plug>(resolve-diff-both)', desc = 'Diff both' },
            ['dv'] = { act = '<Plug>(resolve-diff-vs)', desc = 'Diff ours vs theirs' },
            ['dV'] = { act = '<Plug>(resolve-diff-vs-reverse)', desc = 'Diff theirs vs ours' },
        }
    }
}
