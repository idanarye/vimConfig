local channelot = require'channelot'
local idan_rust = require'idan-rust'

---@class IdanBevyPluginCfg
---@field crate_name string

---@param cfg IdanBevyPluginCfg
return function(T, cfg)
    T.run_cargo_fmt = idan_rust.tasks.run_cargo_fmt
    T.clippy = idan_rust.tasks.clippy

    T{ alias = ':2' }
    function T:cargo_example()
        return idan_rust.tasks.cargo_example(self)
    end

    function T:cargo_required_features_for_all_examples()
        return idan_rust.jq_cargo_metadata('.packages[].targets | map(select(.kind[] == "example") | (.["required-features"] // [])[]) | unique')
    end

    function T:cargo_metadata_by_target()
        return idan_rust.jq_cargo_metadata('.packages[].targets | INDEX(.name)')
    end

    local function add_features_to_command(cmd, features)
        for _, feature in ipairs(features) do
            vim.list_extend(cmd, {'--features', feature})
        end
    end

    function T:check()
        local cmd = {'cargo', 'check', '-q', '--examples'}
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        vim.cmd('Erun! ' .. table.concat(vim.tbl_map(vim.fn.shellescape, cmd), ' '))
    end

    function T:build()
        local cmd = {'cargo', 'build', '-q', '--examples'}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        vim.cmd'botright new'
        channelot.terminal_job(cmd)
        vim.cmd.startinsert()
    end

    function T:run()
        local example = T:cargo_example()
        local cmd = {'cargo', 'run', '--example', example.name}
        vim.list_extend(cmd, {'--features', 'bevy/dynamic'})
        add_features_to_command(cmd, T:cargo_metadata_by_target()[example.name]['required-features'] or {})
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE='1',
            RUST_LOG=('%s=debug,%s=debug'):format(cfg.crate_name, example.name),
        }, cmd)
        vim.cmd.startinsert()
    end

    function T:test()
        vim.cmd'botright new'
        channelot.terminal_job{'cargo', 'test', '--doc', '--all-features'}
        vim.cmd.startinsert()
    end

    function T:clean()
        vim.cmd'!cargo clean'
    end

    function T:launch_wasm()
        local example = T:cargo_example()
        local cmd = {'cargo', 'build', '--examples', '--all-features', '--target', 'wasm32-unknown-unknown'}
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        vim.cmd'botright new'
        local t = channelot.terminal()
        t:job({RUST_BACKTRACE = '1'}, cmd):wait()
        t:job({
            EXAMPLE = example.name,
        }, 'wasm-server-runner target/wasm32-unknown-unknown/debug/examples/$EXAMPLE.wasm'):wait()
        t:prompt_exit()
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
