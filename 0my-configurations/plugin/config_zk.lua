require'zk'.setup {
}

require'caskey'.setup {
    mode = {'n'},
    name = 'zk',
    ['<M-w>'] = {
        ['<Tab>'] = { act = require'caskey'.cmd'Neotree zk' },
        ['n'] = { act = require'caskey'.cmd'ZkNew', },
        ['f'] = { act = require'caskey'.cmd'ZkNotes', },
        ['t'] = { act = require'caskey'.cmd'ZkTags', },
    },
}
