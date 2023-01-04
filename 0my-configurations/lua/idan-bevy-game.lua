local channelot = require'channelot'
local idan_rust = require'idan-rust'

---@class IdanBevyGameCfg
---@field crate_name string

---@param cfg IdanBevyGameCfg
return function(T, cfg)
    T.run_cargo_fmt = idan_rust.tasks.run_cargo_fmt
    T.clippy = idan_rust.tasks.clippy

    function T:cargo_metadata_by_target()
        return idan_rust.jq_cargo_metadata('.packages[].targets | INDEX(.name)')
    end

    function T:check()
        local cmd = {'cargo', 'check', '-q', '--examples'}
        vim.cmd('Erun! ' .. table.concat(vim.tbl_map(vim.fn.shellescape, cmd), ' '))
    end

    function T:build()
        local cmd = {'cargo', 'build', '-q', '--examples'}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        vim.cmd'botright new'
        channelot.terminal_job(cmd)
        vim.cmd.startinsert()
    end

    function T:run()
        local cmd = {'cargo', 'run'}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE='1',
            RUST_LOG=('%s=debug'):format(cfg.crate_name),
        }, cmd)
        vim.cmd.startinsert()
    end

    T{ alias = ':1' }
    function T:level()
        local function remove_suffix(filename)
            if filename then
                local result, _ = filename:gsub('%.yol', '')
                return result
            end
        end
        local cc = self:cached_choice {
            key = tostring,
            format = function(filename)
                return remove_suffix(filename):gsub('_', ' ')
            end,
        }
        local level_index = vim.json.decode(table.concat(vim.fn.readfile('assets/levels/index.yoli'), '\n'))
        for _, level in ipairs(level_index[2]) do
            cc(level.filename)
        end
        return remove_suffix(cc:select())
    end

    function T:execute()
        local cmd = {'cargo', 'run'}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        vim.list_extend(cmd, {'--', '--level', T:level()})
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE='1',
            RUST_LOG=('%s=debug'):format(cfg.crate_name),
        }, cmd)
        vim.cmd.startinsert()
    end

    function T:go()
        local cmd = {'cargo', 'run'}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        vim.list_extend(cmd, {'--', '--editor'})
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE='1',
            RUST_LOG=('%s=debug'):format(cfg.crate_name),
        }, cmd)
        vim.cmd.startinsert()
    end

    function T:clean()
        vim.cmd'!cargo clean'
    end

    function T:launch_wasm()
        local cmd = {'cargo', 'run', '--target', 'wasm32-unknown-unknown'}
        vim.cmd'botright new'
        channelot.terminal_job({RUST_BACKTRACE = '1'}, cmd)
    end

    function T:browse_wasm()
        vim.cmd'!firefox http://127.0.0.1:1334'
    end

    function T:doc()
        vim.cmd'botright new'
        channelot.terminal_job{'cargo', 'doc', '--no-deps', '--all-features'}
        vim.cmd.startinsert()
    end

    function T:browse_docs()
        vim.cmd('!firefox target/doc/' .. cfg.crate_name .. '/index.html')
    end

    return T
end
