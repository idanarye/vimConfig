local moonicipal = require'moonicipal'
local channelot = require'channelot'

return function()
    local cfg = {
        ---@type string
        hostname = nil,
        ---@type string
        dirname = nil,
        ---@type string[]
        files_to_upload = nil
    }

    local T = moonicipal.tasks_file()

    local function run_ssh_cmd(terminal, cmd)
        return terminal:job{'ssh', '-t', cfg.hostname, 'cd ' .. cfg.dirname .. ';', cmd}
    end

    function T:upload_to_server()
        local t = channelot.windowed_terminal()
        local cmd = {'rsync'}
        if self:is_main() then
            table.insert(cmd, '--verbose')
        end
        vim.list_extend(cmd, cfg.files_to_upload)
        table.insert(cmd, ('%s:~/%s/'):format(cfg.hostname, cfg.dirname))
        local job = t:job(cmd)
        if self:is_main() then
            t:with(function()
                job:check()
                return
            end)
            return
        end
        local ok, err = pcall(function()
            job:check()
        end)
        if not ok then
            t:with(function()
                error(err)
            end)
            moonicipal.abort()
        end
        t.ssh = run_ssh_cmd
        return t
    end

    function T:ssh()
         T:upload_to_server():with(function(t)
             t:ssh[=[exec bash]=]:check()
         end)
    end

    return T, cfg
end
