local ck = require'caskey'

ck.setup {
    mode = {'n'},
    ['<Leader>'] = {
        ['<M-s>'] = { act = function()
            vim.cmd.new()
            vim.fn.termopen{'nu'}
            vim.cmd.startinsert()
        end, desc = 'Start Terminal' },
    }
}
