local ck = require'caskey'
local yop = require'yop'

ck.setup {
    mode = {'n'},
    ['<Leader>'] = {
        ['<M-s>'] = { act = function()
            vim.cmd.new()
            vim.fn.termopen{'nu'}
            vim.cmd.startinsert()
        end, desc = 'Start Terminal' },
    },
    ['<C-w>u'] = { act = function()
        for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local win_config = vim.api.nvim_win_get_config(winnr)
            if win_config.relative and win_config.relative ~= '' then
                vim.api.nvim_win_close(winnr, false)
            end
        end
    end, desc = 'Close all bubble windows'},
    ['<Leader><C-s>'] = {
        act = ck.cmd'write',
    },
}

yop.op_map({'n', 'v'}, 's', function(_lines, _info)
    return vim.fn.getreg(vim.v.register, false, true)
end, {desc = 'replace with register content'})
