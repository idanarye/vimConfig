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
    ['<C-s>'] = {
        mode = {'n', 'i', 'x'},
        act = ck.cmd'update',
    },
    ['<Leader><C-s>'] = {
        act = ck.cmd'write',
    },
    ['<C-c>'] = {
        mode = {'x'},
        act = function()
            local visual_mode = vim.fn.mode()
            local vs = vim.fn.getpos('v')
            local ve = vim.fn.getpos('.')
            if ve[2] < vs[2] or (vs[2] == ve[2] and ve[3] < vs[3]) then
                vs, ve = ve, vs
            end
            local lines
            local options
            if visual_mode == 'V' then
                lines = vim.api.nvim_buf_get_lines(0, vs[2] - 1, ve[2], true)
                options = 'V'
            elseif visual_mode == 'v' then
                lines = vim.api.nvim_buf_get_text(0, vs[2] - 1, vs[3] - 1, ve[2] - 1, ve[3], {})
                options = 'v'
            else
                error('Cannot handle visual mode ' .. visual_mode)
            end
            vim.fn.setreg('+', lines, options)
        end,
    },
}
