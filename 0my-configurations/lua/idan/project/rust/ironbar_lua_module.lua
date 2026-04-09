local moonicipal = require'moonicipal'

return function()
    local P, cfg = require'idan.project.rust'()
    local T = moonicipal.tasks_lib()

    ---@type string
    cfg.ironbar_config = nil

    function T:run()
        if cfg.ironbar_config == nil then
            moonicipal.abort('Must set cfg.ironbar_config')
        end
        require'channelot'.windowed_terminal():with(function(t)
            t:job(P:_build_command()):check()
            t:job{'ironbar', '--config', cfg.ironbar_config}:check()
        end)
    end

    function T.toggle_ironbar_systemctl_service()
        local res = vim.system{'systemctl', '--user', 'is-active', 'ironbar'}:wait()
        if res.code == 0 then
            vim.system{'systemctl', '--user', 'stop', 'ironbar'}:wait()
        elseif res.code == 3 then
            vim.system{'systemctl', '--user', 'start', 'ironbar'}:wait()
        else
            moonicipal.abort('Cannot get status: ' .. res.stderr)
        end
    end

    return moonicipal.merge_libs(T, P), cfg
end
