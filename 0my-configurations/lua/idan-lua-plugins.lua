local M = {}

function M:choose_test()
    local cc = self:cached_choice{key = tostring}
    for filename, filetype in vim.fs.dir('tests') do
        if filetype == 'file' and vim.endswith(filename, '_spec.lua') then
            cc(filename)
        end
    end
    return cc:select()
end

function M.gen_test_task(T, choose_test_task_name)
    return function()
        local testfile = T[choose_test_task_name](T)
        vim.cmd'botright new'
        vim.cmd.wincmd('20_')
        vim.fn.termopen{
            'nvim', '--headless',
            '-u', 'tests/minimal_init.lua',
            '-c', "PlenaryBustedDirectory tests/" .. testfile .. " {minimal_init = 'tests/minimal_init.lua'}",
        }
        vim.cmd.startinsert()
    end
end

function M:test_all()
    vim.cmd'botright new'
    vim.cmd.wincmd('20_')
    vim.fn.termopen{
        'nvim', '--headless',
        '-u', 'tests/minimal_init.lua',
        '-c', "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}",
    }
    vim.cmd.startinsert()
end

return M
