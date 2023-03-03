local channelot = require'channelot'
local idan_rust = require'idan.rust'

---@class IdanProjectRustCfg
---@field crate_name? string
---@field extra_features_for_build_and_run? string[]
---@field extra_features_for_docs? string[]
---@field only_build_relevant? boolean

---@param cfg? IdanProjectRustCfg
return function(T, cfg)
    cfg = cfg or {}

    local function get_crate_name()
        return cfg.crate_name or idan_rust.jq_cargo_metadata('.packages[].name')
    end

    function T:run_cargo_fmt()
        vim.cmd'!cargo fmt'
    end

    function T:clippy()
        vim.cmd'Erun! cargo clippy -q'
    end

    T{ alias = ':2' }
    function T:run_target()
        local cc = self:cached_choice {
            key = 'name',
            format = 'name',
        }
        for _, target in ipairs(idan_rust.jq_all_bin_targets()) do
            cc(target)
        end
        return cc:select()
    end

    local function target_if_only_build_relevant()
        if cfg.only_build_relevant then
            return T:run_target()
        else
            return nil
        end
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

    local function add_relevant_flags_for_target(cmd, target)
        if target then
            vim.list_extend(cmd, idan_rust.flags_to_run_target(target))
            add_features_to_command(cmd, T:cargo_metadata_by_target()[target.name]['required-features'] or {})
        else
            vim.list_extend(cmd, {'--bins', '--examples'})
            add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        end
    end

    function T:check()
        local cmd = {'cargo', 'check', '-q'}
        add_relevant_flags_for_target(cmd, target_if_only_build_relevant())
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        vim.cmd('Erun! ' .. table.concat(cmd, ' '))
    end

    function T:build()
        local cmd = {'cargo', 'build', '-q'}
        add_relevant_flags_for_target(cmd, target_if_only_build_relevant())
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        vim.cmd'botright new'
        channelot.terminal_job(cmd)
        vim.cmd.startinsert()
    end

    function T:run()
        local target = T:run_target()
        local cmd = {'cargo', 'run'}
        add_relevant_flags_for_target(cmd, target)
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE='1',
            RUST_LOG=('%s=debug,%s=debug'):format(get_crate_name(), target.name),
        }, cmd)
        vim.cmd.startinsert()
    end

    function T:debug()
        local target = T:run_target()

        local cmd = {}
        add_relevant_flags_for_target(cmd, target)
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        cmd = vim.tbl_map(vim.fn.shellescape, cmd)
        local exit_code = vim.fn['erroneous#run']('cargo build -q ' .. table.concat(cmd, ' '), true, true, false)
        if 0 ~= exit_code then
            return
        end

        local executable_path = 'target/debug/'
        if vim.tbl_contains(target.kind, 'example') then
            executable_path = executable_path .. 'examples/'
        end
        executable_path = executable_path .. target.name
        local envvar_ld_lib_path = table.concat({
            'target/debug/deps',
            idan_rust.get_rustup_lib_path(),
            vim.env.LD_LIBRARY_PATH,
        }, ':')
        require'dap'.run {
            type = 'codelldb',
            request = 'launch',
            program = executable_path,
            env = {
                RUST_BACKTRACE='1',
                RUST_LOG=('%s=debug,%s=debug'):format(get_crate_name(), target.name),
                LD_LIBRARY_PATH = envvar_ld_lib_path,
            },
        }
    end

    function T:test()
        vim.cmd'botright new'
        channelot.terminal_job{'cargo', 'test', '--all-features'}
        vim.cmd.startinsert()
    end

    function T:clean()
        vim.cmd'!cargo clean'
    end

    function T:launch_wasm()
        local target = T:run_target()
        local cmd = {'cargo', 'build', '--bins', '--examples', '--all-features', '--target', 'wasm32-unknown-unknown'}
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        vim.cmd'botright new'
        local t = channelot.terminal()
        dump('Build:', cmd)
        t:job({RUST_BACKTRACE = '1'}, cmd):wait()
        local wasm_file_path = 'target/wasm32-unknown-unknown/debug/'
        if vim.tbl_contains(target.kind, 'example') then
            wasm_file_path = wasm_file_path .. 'examples/'
        end
        wasm_file_path = wasm_file_path .. target.name .. '.wasm'
        t:job{'wasm-server-runner', wasm_file_path}:wait()
        t:prompt_exit()
    end

    function T:browse_wasm()
        vim.cmd'!firefox http://127.0.0.1:1334'
    end

    function T:doc()
        vim.cmd'botright new'
        local cmd = {'cargo', 'doc', '--no-deps', '--all-features'}
        for _, extra_feature in ipairs(cfg.extra_features_for_docs or {}) do
            vim.list_extend(cmd, {'--features', extra_feature})
        end
        channelot.terminal_job(cmd)
        vim.cmd.startinsert()
    end

    function T:browse_docs()
        vim.cmd('!firefox target/doc/' .. get_crate_name() .. '/index.html')
    end

    return T
end
