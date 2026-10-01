local moonicipal = require'moonicipal'

return function()
    local T = moonicipal.tasks_lib()

    local cfg = {
        ---@type string
        main_file = 'main.ts',
    }

    function T:run()
        require'blunder'.run{'deno', 'run', cfg.main_file}
    end

    function T:check()
        require'blunder'.run{'deno', 'check'}
    end

    function T:explore()
        require'channelot'.windowed_terminal_job{'deno', 'repl', '--eval-file', cfg.main_file}
    end

    return T, cfg
end
