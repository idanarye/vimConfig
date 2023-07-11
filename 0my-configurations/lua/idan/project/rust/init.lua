local channelot = require'channelot'
local blunder = require'blunder'
local idan_rust = require'idan.rust'

---@class IdanProjectRustCfg
---@field crate_name? string
---@field extra_features_for_build_and_run? string[]
---@field extra_features_for_docs? string[]
---@field extra_features_for_wasm? string[]
---@field only_build_relevant? boolean
---@field cli_args_for_targets? {string: string[]}
---@field extra_logging? {string: string}

---@param cfg? IdanProjectRustCfg
return function(T, cfg)
    cfg = cfg or {}

    local function get_crate_name()
        return cfg.crate_name or idan_rust.jq_cargo_metadata('.packages[].name')
    end

    local function get_rust_log_envvar(override)
        local logging = cfg.extra_logging or {}
        if type(override) == 'table' then
            logging = vim.tbl_extend('force', logging, override)
        end
        local parts = {}
        for k, v in pairs(logging) do
            if vim.tbl_islist(k) then
                k = table.concat(k, ',')
            end
            table.insert(parts, ('%s=%s'):format(k, v))
        end
        return table.concat(parts, ',')
    end

    function T:run_cargo_fmt()
        vim.cmd'!cargo fmt'
    end

    function T:clippy()
        blunder.run{'cargo', 'clippy', '-q'}
    end

    T{ alias = ':2' }
    function T:run_target()
        local function name_with_args(target)
            if target.cli_args then
                return target.name .. vim.inspect(target.cli_args)
            else
                return target.name
            end
        end
        local cc = self:cached_choice {
            key = name_with_args,
            format = name_with_args,
        }
        for _, target in ipairs(idan_rust.jq_all_bin_targets()) do
            cc(target)
            local cli_args = (cfg.cli_args_for_targets or {})[target.name]
            if cli_args then
                for _, args in ipairs(cli_args) do
                    cc(vim.tbl_extend('error', target, {
                        cli_args = args,
                    }))
                end
            end
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
        return idan_rust.jq_cargo_metadata('.packages | map(.targets[] | select(.kind[] == "example") | (.["required-features"] // [])[]) | unique')
    end

    function T:cargo_metadata_by_target()
        return idan_rust.jq_cargo_metadata('.packages | map(.targets[]) | INDEX(.name)')
    end

    local function add_features_to_command(cmd, features)
        if features == nil then
            return
        end
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
        blunder.run(cmd)
    end

    function T:build()
        local cmd = {'cargo', 'build', '-q'}
        add_relevant_flags_for_target(cmd, target_if_only_build_relevant())
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        blunder.run(cmd)
    end

    function T:_simple_target_runner()
        return function(target_name, ...)
            local cli_args = {...}
            for _, target in ipairs(idan_rust.jq_all_bin_targets()) do
                if target.name == target_name then
                    local cmd = {'cargo', 'run'}
                    add_relevant_flags_for_target(cmd, target)
                    add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
                    if next(cli_args) ~= nil then
                        table.insert(cmd, '--')
                        vim.list_extend(cmd, cli_args)
                    end
                    vim.cmd'botright new'
                    channelot.terminal_job({
                        RUST_BACKTRACE = '1',
                        RUST_LOG = get_rust_log_envvar {
                            [{get_crate_name(), target.name}] = 'debug',
                        },
                    }, cmd)
                    vim.cmd.startinsert()
                    return
                end
            end
            require'moonicipal'.abort('No target named ' .. target_name)
        end
    end

    function T:run()
        local target = T:run_target()
        local cmd = {'cargo', 'run'}
        add_relevant_flags_for_target(cmd, target)
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        if target.cli_args then
            table.insert(cmd, '--')
            vim.list_extend(cmd, target.cli_args)
        end
        vim.cmd'botright new'
        channelot.terminal_job({
            RUST_BACKTRACE = '1',
            RUST_LOG = get_rust_log_envvar {
                [{get_crate_name(), target.name}] = 'debug',
            },
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
            args = target.cli_args,
            env = {
                RUST_BACKTRACE = '1',
                RUST_LOG = get_rust_log_envvar {
                    [{get_crate_name(), target.name}] = 'debug',
                },
                LD_LIBRARY_PATH = envvar_ld_lib_path,
            },
        }
    end

    function T:test()
        blunder.run{'cargo', 'test', '--all-features'}
    end

    function T:clean()
        vim.cmd'!cargo clean'
    end

    function T:launch_wasm()
        local target = T:run_target()
        local cmd = {'cargo', 'build', '--bins', '--examples', '--all-features', '--target', 'wasm32-unknown-unknown'}
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        add_features_to_command(cmd, cfg.extra_features_for_wasm)
        vim.cmd'botright new'
        local t = channelot.terminal()
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
        local cmd = {'cargo', 'doc', '--no-deps', '--all-features'}
        local extra_features_for_docs = cfg.extra_features_for_docs
        if extra_features_for_docs == nil then
            local from_cargo = idan_rust.jq_cargo_metadata('.packages[].metadata.docs.rs.features')
            if vim.tbl_islist(from_cargo) then
                extra_features_for_docs = from_cargo
            else
                extra_features_for_docs = {}
            end
        end
        for _, extra_feature in ipairs(extra_features_for_docs) do
            vim.list_extend(cmd, {'--features', extra_feature})
        end
        blunder.run(cmd)
    end

    function T:browse_docs()
        vim.cmd('!firefox target/doc/' .. get_crate_name() .. '/index.html')
    end

    return T
end
