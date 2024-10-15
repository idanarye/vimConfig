local moonicipal = require'moonicipal'
local channelot = require'channelot'
local blunder = require'blunder'
local idan_rust = require'idan.rust'

---@alias IdanProjectRustCliArgsForTarget {[number]: string, with_job?: fun(job: ChannelotJob), pty?: boolean}

return function()
    local T = moonicipal.tasks_lib()

    local cfg = {
        ---@type string?
        crate_name = nil,
        ---@type string[]
        extra_features_for_build_and_run = {},
        ---@type string[]?
        extra_features_for_docs = nil,
        ---@type boolean
        wasm_use_all_features = true,
        ---@type string[]
        extra_features_for_wasm = {},
        ---@type boolean
        only_build_relevant = false,
        ---@type {[string]: {[number|string]: IdanProjectRustCliArgsForTarget}}
        cli_args_for_targets = {},
        ---@type {[string]: string}
        extra_logging = {},
        ---@type {[string]: {[string]: string[]}}
        variants_for_targets = {},
        ---@type string[]
        features_for_clippy = {},
        ---@type string[]
        features_for_tests = {},
    }

    function T:_crate_name()
        return cfg.crate_name or idan_rust.jq_cargo_metadata('.packages[].name')
    end

    local function get_rust_log_envvar(override)
        local logging = cfg.extra_logging
        if type(override) == 'table' then
            logging = vim.tbl_extend('force', logging, override)
        end
        local parts = {}
        for k, v in pairs(logging) do
            if vim.islist(k) then
                k = table.concat(k, ',')
            end
            table.insert(parts, ('%s=%s'):format(k, v))
        end
        return table.concat(parts, ',')
    end

    local function target_if_only_build_relevant()
        if cfg.only_build_relevant then
            return T:run_target()
        else
            return nil
        end
    end

    function T:watch_cargo_metdata()
        local current_window = vim.api.nvim_get_current_win()
        vim.cmd'botright vnew'
        vim.fn.termopen{'watch', '--color', '--differences', idan_rust.CARGO_METADATA_GENERATION_COMMAND}
        vim.api.nvim_set_current_win(current_window)
    end

    function T:jq_cargo_metdata()
        channelot.create_window_for_terminal()
        vim.cmd.wincmd'L'
        vim.fn.termopen{
            'fzf',
            '--disabled', '--ansi', '--no-sort', '--tac',
            '--query', '.',
            '--bind', 'start:reload:' .. idan_rust.CARGO_METADATA_GENERATION_COMMAND .. ' | jq --color-output {q}',
            '--bind', 'change:reload:' .. idan_rust.CARGO_METADATA_GENERATION_COMMAND .. ' | jq --color-output {q}',
        }
    end

    function T:cargo_required_features_for_all_examples()
        return idan_rust.jq_cargo_metadata('.packages | map(.targets[] | select(.kind[] == "example") | (.["required-features"] // [])[]) | unique')
    end

    function T:cargo_metadata_by_target()
        return idan_rust.jq_cargo_metadata('.packages | map(.targets[]) | INDEX(.name)')
    end

    function T:cargo_all_packages()
        return idan_rust.jq_cargo_metadata('.packages | map(.name)')
    end

    local function flags_to_include_all_packages()
        local result = {}
        for _, subpackage in ipairs(T:cargo_all_packages()) do
            vim.list_extend(result, {
                '--package', subpackage,
            })
        end
        return result
    end

    local function add_features_to_command(cmd, features)
        if features == nil then
            return
        end
        if features.no_default_features then
            table.insert(cmd, '--no-default-features')
        end
        for _, feature in ipairs(features) do
            vim.list_extend(cmd, {'--features', feature})
        end
    end

    local function add_features_or_all_features(cmd, features_or_all_features)
        if features_or_all_features then
            add_features_to_command(cmd, features_or_all_features)
        else
            table.insert(cmd, '--all-features')
        end
    end

    local function run_command_with_features(cmd, features_or_all_features)
        add_features_or_all_features(cmd, cfg.features_for_clippy)
        blunder.run(cmd)
    end

    function T:run_cargo_fmt()
        vim.cmd'!cargo fmt'
    end

    function T:clippy()
        run_command_with_features({
            'cargo', 'clippy', '-q', '--workspace', '--all-targets',
        }, cfg.features_for_clippy)
    end

    T{ alias = ':2' }
    function T:run_target()
        local function name_with_args(target)
            local result = target.name
            if target.variant_name then
                result = result .. ('[%s]'):format(target.variant_name)
            end
            if target.cli_args_name then
                result = result .. ' <' .. target.cli_args_name .. '>'
            elseif target.cli_args then
                result = result .. vim.inspect(target.cli_args)
            end
            return result
        end
        local cc = self:cached_choice {
            key = name_with_args,
            format = name_with_args,
        }
        for _, target in ipairs(idan_rust.jq_all_bin_targets()) do
            local cli_args = cfg.cli_args_for_targets[target.name]
            local variants = cfg.variants_for_targets[target.name] or {[false] = {}}
            for variant_name, variant_features in pairs(variants) do
                local variant = vim.tbl_extend('keep', target, {})
                if variant_name then
                    variant.variant_name = variant_name
                    variant.variant_features = variant_features
                end
                cc(variant)
                if cli_args then
                    for name, args in pairs(cli_args) do
                        if type(name) == 'number' then
                            name = nil
                        end
                        cc(vim.tbl_extend('error', variant, {
                            cli_args_name = name,
                            cli_args = args,
                        }))
                    end
                end
            end
        end
        return cc:select()
    end

    local function add_relevant_flags_for_target(cmd, target)
        if target then
            vim.list_extend(cmd, {'--package', target.package_name})
            vim.list_extend(cmd, idan_rust.flags_to_run_target(target))
            add_features_to_command(cmd, T:cargo_metadata_by_target()[target.name]['required-features'] or {})
            add_features_to_command(cmd, target.variant_features or {})
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

    function T:_build_command()
        local cmd = {'cargo', 'build', '-q'}
        add_relevant_flags_for_target(cmd, target_if_only_build_relevant())
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        return cmd
    end

    function T:build()
        blunder.run(T:_build_command())
    end

    function T:_shadow_build()
        local build_failed = channelot.shadow_terminal():with(function(t)
            t:job(T:_build_command()):using(blunder.for_channelot):check()
        end)
        if build_failed then
            moonicipal.abort()
        end
    end

    function T:_build_and_keep_terminal()
        local t = channelot.windowed_terminal()
        local build_exit_status = t:job(T:_build_command()):using(blunder.for_channelot):wait()
        if build_exit_status ~= 0 then
            t:prompt_after_process_exited(build_exit_status)
            moonicipal.abort()
        end
        return t
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
                    channelot.windowed_terminal_job({
                        RUST_BACKTRACE = '1',
                        RUST_LOG = get_rust_log_envvar {
                            [{T:_crate_name(), target.name}] = 'debug',
                        },
                    }, cmd)
                    return
                end
            end
            require'moonicipal'.abort('No target named ' .. target_name)
        end
    end

    T{ alias = ':0' }
    function T:target_and_command()
        local target = T:run_target()
        local cmd = {'cargo', 'run'}
        add_relevant_flags_for_target(cmd, target)
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})
        local run_opts = {}
        if type(target.cli_args) == 'table' then
            if type(target.cli_args[1]) == 'string' then
                table.insert(cmd, '--')
                vim.list_extend(cmd, target.cli_args)
            end
            ---@type fun(job: ChannelotJob)?
            run_opts.with_job = target.cli_args.with_job
            ---@type boolean?
            run_opts.pty = target.cli_args.pty
        end
        if self:is_main() then
            vim.print(target)
            vim.print(cmd)
        end
        return target, cmd, run_opts
    end

    function T:run()
        local target, cmd, run_opts = T:target_and_command()
        local job = channelot.windowed_terminal_job({
            RUST_BACKTRACE = '1',
            RUST_LOG = get_rust_log_envvar {
                [{T:_crate_name(), target.name}] = 'debug',
            },
        }, cmd, {
            pty = run_opts.pty
        })
        if run_opts.with_job then
            run_opts.with_job(job)
        end
        job:wait()
    end

    function T:debug()
        local target = T:run_target()

        local cmd = {'cargo', 'build'}
        add_relevant_flags_for_target(cmd, target)
        add_features_to_command(cmd, cfg.extra_features_for_build_and_run or {})

        local build_failed = require'channelot'.shadow_terminal():with(function(t)
            t:job(cmd):using(blunder.for_channelot):check()
        end)
        if build_failed then
            moonicipal.abort()
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
                    [{T:_crate_name(), target.name}] = 'debug',
                },
                LD_LIBRARY_PATH = envvar_ld_lib_path,
            },
        }
    end

    function T:test()
        --blunder.run{'cargo', 'test', '--all-targets'}
        run_command_with_features({
            'cargo', 'test', '--all-targets',
        }, cfg.features_for_clippy)
    end

    function T:clean()
        vim.cmd'!cargo clean'
    end

    local function get_build_wasm_command()
        local cmd = {'cargo', 'build', '--target', 'wasm32-unknown-unknown'}
        add_features_to_command(cmd, T:cargo_required_features_for_all_examples())
        if cfg.wasm_use_all_features == nil or cfg.wasm_use_all_features then
            vim.list_extend(cmd, {'--bins', '--examples'})
            table.insert(cmd, '--all-features')
        else
            local target = T:run_target()
            add_relevant_flags_for_target(cmd, target)
        end
        add_features_to_command(cmd, cfg.extra_features_for_wasm)
        return cmd
    end

    function T:query()
        vim.print(get_build_wasm_command())
    end

    function T:build_wasm()
        local cmd = get_build_wasm_command()
        channelot.windowed_terminal_job({RUST_BACKTRACE = '1'}, cmd):using(blunder.for_channelot):wait()
    end

    function T:launch_wasm()
        local target = T:run_target()
        local cmd = get_build_wasm_command()
        channelot.windowed_terminal():with(function(t)
            t:job({RUST_BACKTRACE = '1'}, cmd):using(blunder.for_channelot):check()
            local wasm_file_path = 'target/wasm32-unknown-unknown/debug/'
            if vim.tbl_contains(target.kind, 'example') then
                wasm_file_path = wasm_file_path .. 'examples/'
            end
            wasm_file_path = wasm_file_path .. target.name .. '.wasm'
            t:job{'wasm-server-runner', wasm_file_path}:check()
        end)
    end

    function T:browse_wasm()
        vim.cmd'!firefox --new-window http://127.0.0.1:1334'
    end

    function T:doc()
        local cmd = {'cargo', 'doc', '--no-deps', unpack(flags_to_include_all_packages())}
        local extra_features_for_docs = cfg.extra_features_for_docs
        if extra_features_for_docs == nil then
            local from_cargo = idan_rust.jq_cargo_metadata('.packages | map(.metadata.docs.rs | select (. != null))[0].features')
            if vim.islist(from_cargo) then
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
        vim.cmd('!firefox --new-window target/doc/' .. T:_crate_name() .. '/index.html')
    end

    return T, cfg
end
