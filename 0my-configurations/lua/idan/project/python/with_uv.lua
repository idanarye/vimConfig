local moonicipal = require'moonicipal'
local blunder = require'blunder'
local channelot = require'channelot'

return function()
    local cfg = {
        ---@type string
        entry_point = 'main.py',
    }

    local T = moonicipal.tasks_lib()

    function T:entry_point()
        return cfg.entry_point or 'main.py'
    end

    function T:run()
        blunder.run{'uv', '-q', 'run', T:entry_point()}
    end

    function T:debug()
        require'dap'.run {
            type = 'python',
            request = 'launch',
            program = T:entry_point(),
        }
    end

    function T:explore()
        channelot.windowed_terminal_job{'uv', '-q', 'run', 'ipython', '-i', T:entry_point()}
    end

    return T, cfg
end
