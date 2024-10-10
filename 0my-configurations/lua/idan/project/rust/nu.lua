local moonicipal = require'moonicipal'

return function()
    local P, cfg = require'idan.project.rust'()
    local T = moonicipal.tasks_lib()

    function T:_nu_runner()
        P:_shadow_build()
        return function(nu_code)
            local cmd = {
                'nu',
                '--no-config-file',
                '--plugins', ('[target/debug/%s]'):format(P:_crate_name()),
            }
            if nu_code then
                vim.list_extend(cmd, {'--commands', nu_code})
            end
            require'channelot'.windowed_terminal_job({RUST_BACKTRACE = 1}, cmd)
        end
    end

    function T:kill()
        vim.system({'nu', '--commands', [=[
        ps | find $env.process_name | first | kill $in.pid
        ]=]}, {
            env = {
                process_name = P:_crate_name(),
            }
        })
    end

    return moonicipal.merge_libs(T, P), cfg
end
