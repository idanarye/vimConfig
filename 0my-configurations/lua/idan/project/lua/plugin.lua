return function(T)
    function T:choose_test()
        local cc = self:cached_choice{key = tostring}
        for filename, filetype in vim.fs.dir('tests') do
            if filetype == 'file' and vim.endswith(filename, '_spec.lua') then
                cc(filename)
            end
        end
        return cc:select()
    end

    function T:test()
        local testfile = T:choose_test()
        blunder.create_window_for_terminal()
        vim.cmd.wincmd('20_')
        vim.fn.termopen{
            'nvim', '--headless',
            '-u', 'tests/minimal_init.lua',
            '-c', "PlenaryBustedDirectory tests/" .. testfile .. " {minimal_init = 'tests/minimal_init.lua'}",
        }
        vim.cmd.startinsert()
    end

    function T:test_all()
        blunder.create_window_for_terminal()
        vim.cmd.wincmd('20_')
        vim.fn.termopen{
            'nvim', '--headless',
            '-u', 'tests/minimal_init.lua',
            '-c', "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}",
        }
        vim.cmd.startinsert()
    end

    function T:doc()
        vim.fn.system('make docs')
        vim.cmd.checktime()
    end

    return T
end
