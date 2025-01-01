local ck = require'caskey'

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
}
