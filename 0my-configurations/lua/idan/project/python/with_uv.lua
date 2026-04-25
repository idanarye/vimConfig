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
            name = 'python-launch',
            type = 'python',
            request = 'launch',
            program = T:entry_point(),
        }
    end

    function T:explore()
        channelot.windowed_terminal_job{'uv', '-q', 'run', '--with', 'ipython', 'python', '-m', 'IPython', '-i', T:entry_point()}
    end

    T{alias = ':1'}
    function T:type_checker()
        local cc = self:cached_choice {
            key = 'tool',
            format = 'tool',
        }
        cc {
            tool = 'basedpyright',
            args = {},
        }
        cc {
            tool = 'ty',
            args = {'check', '--no-progress', '--output-format', 'concise'},
            efm = '%f:%l:%c: %m',
        }
        cc {
            tool = 'pyrefly',
            args = {'check', '--output-format', 'min-text', '--summary=none'},
            efm = [=[%t%*[A-Z] %f:%l:%c-%k: %m]=],
        }
        return cc:select()
    end

    function T:check()
        local checker = T:type_checker()
        local uv_cmd = {
            'uv', '--quiet', 'run',
            '--with', checker.tool,
            '--',
            checker.tool,
            unpack(checker.args)
        }
        -- channelot.windowed_terminal_job(uv_cmd, {pty = false}):using(blunder.for_channelot{efm = checker.efm}):wait()
        blunder.run(uv_cmd, {efm = checker.efm})
    end

    return T, cfg
end
