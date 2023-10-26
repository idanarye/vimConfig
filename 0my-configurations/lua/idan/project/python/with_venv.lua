local moonicipal = require'moonicipal'
local channelot = require'channelot'
local blunder = require'blunder'

---@class IdanWorkProjectPythonWithVenvCfg
---@field package_name? string
---@field venv_name string
---@field venv_python_version string
---@field run_targets? string[]
---@field locally_install_packages? { [string]: string }

---@param cfg? IdanWorkProjectPythonWithVenvCfg
return function(cfg)
    cfg = cfg or {}

    local T = moonicipal.tasks_lib()

    function T:pyproject()
        local pyproject = require'toml'.parse(table.concat(vim.fn.readfile('pyproject.toml'), '\n'))
        if self:is_main() then
            dump(pyproject)
        end
        return pyproject
    end

    function T:packages()
        if cfg.package_name then
            return {cfg.package_name}
        end
        local packages = vim.tbl_get(T:pyproject(), 'tool', 'setuptools', 'packages')
        if packages then
            return packages
        end
        return {}
    end

    if cfg.run_targets then
        T{ alias = ':2' }
        function T:run_target()
            local cc = self:cached_choice {
                key = function(target)
                    return vim.inspect(target)
                end,
            }
            for _, target in ipairs(cfg.run_targets) do
                cc(target)
            end
            return cc:select()
        end

        function T:run()
            local target = T:run_target() or moonicipal.abort()
            local command
            if type(target) == "string" then
                command = {target}
            elseif vim.tbl_islist(target) then
                command = target
            else
                error("Bad target " .. vim.inspect(target))
            end
            blunder.run({'python', unpack(command)}, {
                fmt = [=[%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m ]=],
            })
        end

        function T:debug()
            local target = T:run_target() or moonicipal.abort()
            local program
            local args
            if type(target) == "string" then
                program = target
                args = nil
            elseif vim.tbl_islist(target) then
                program = target[1]
                args = {unpack(target, 2)}
            else
                error("Bad target " .. vim.inspect(target))
            end
            require'dap'.run {
                type = 'python',
                request = 'launch',
                program = program,
                args = args,
            }
        end
    end

    function T:read_cluster_ips()
        local cluster_name = moonicipal.input { prompt = 'Cluster name: ' }
        if not cluster_name or cluster_name == '' then
            moonicipal.abort()
        end
        blunder.create_window_for_terminal()
        vim.fn.termopen({'teka', 'explore', cluster_name, '--cmd', require'plenary.strings'.dedent[=[
        import os
        import json
        with open(os.environ['IPS_JSON_FILE'], 'w') as f:
            json.dump([ip for h in system.hosts for ip in h.host_ips], f)
        ]=]}, {
            env = {
                IPS_JSON_FILE = vim.fs.normalize('$PWD/current-ips.json')
            },
        })
    end

    ---@param dlg fun(terminal: ChannelotTerminal)
    local function virtualenv_creation(dlg)
        blunder.create_window_for_terminal()
        require'idan'.notify_error(function()
            channelot.terminal():with(function(t)
                t:job{'pyenv', 'virtualenv-delete', '-f', cfg.venv_name}:wait()
                t:job{'pyenv', 'virtualenv', cfg.venv_python_version, cfg.venv_name}:check()
                t:job{'pyenv', 'local', cfg.venv_name}:check()
                dlg(t)
            end)
        end)
    end

    function T:recreate_virtualenv_as_is()
        virtualenv_creation(function(t)
            t:job{'pip', 'install', '.'}:wait()
        end)
    end

    function T:recreate_virtualenv()
        local pyproject = T:pyproject()
        local project_dependencies_to_install = pyproject.project.dependencies

        if cfg.locally_install_packages then
            local pattern = vim.regex[=[\v^(\w|-)+]=]
            project_dependencies_to_install = vim.tbl_filter(function(package)
                local s, e = pattern:match_str(package)
                if s then
                    local actual_name = package:sub(s + 1, e)
                    return cfg.locally_install_packages[actual_name] == nil
                end
                return true
            end, project_dependencies_to_install)
        end

        virtualenv_creation(function(t)
            if cfg.locally_install_packages then
                if next(project_dependencies_to_install) then
                    t:job{'pip', 'install', unpack(project_dependencies_to_install)}:wait()
                end
                for _, dependency_path in pairs(cfg.locally_install_packages) do
                    t:job{'pip', 'install', '-e', dependency_path}:wait()
                end
            else
                t:job{'pip', 'install', '.'}:wait()
            end
            t:job{'pip', 'install', 'mypy', 'ipython', 'sphinx==5.3.0'}:wait()
            local packages = T:packages()
            t:job{
                'python', '-m', 'mypy',
                '--follow-imports', 'silent',
                '--install-types', '--non-interactive',
                unpack(packages)
            }:wait()
        end)
    end

    function T:run_mypy()
        blunder.run{
            'python',
            '-m', 'mypy',
            '--follow-imports', 'silent',
            '--install-types',
            '--non-interactive',
            unpack(T:packages())
        }
    end

    function T:black_this_file()
        local bufnum = vim.api.nvim_get_current_buf()
        local orig = vim.api.nvim_buf_get_lines(bufnum, 0, vim.api.nvim_buf_line_count(bufnum), true)
        local j = channelot.job{'black', '-'}
        for _, line in ipairs(orig) do
            j:writeln(line)
        end
        j:close_stdin()
        local output = { stdout = {}, stderr = {} }
        for std, line in j:iter() do
            table.insert(output[std], line)
        end
        local result = j:wait()
        if result == 0 then
            vim.api.nvim_buf_set_lines(bufnum, 0, vim.api.nvim_buf_line_count(bufnum), true, output.stdout)
        else
            vim.notify(table.concat(output.stderr, '\n'))
        end
    end

    function T:copy_git_hash()
        vim.fn.system('xclip', vim.fn.systemlist{'git', 'rev-parse', 'HEAD'}[1])
    end

    function T:doc()
        blunder.create_window_for_terminal()
        channelot.terminal():with(function(t)
            for _, package in ipairs(T:packages()) do
                t:job{'python', '-m', 'sphinx.ext.apidoc', '-o', 'docs', package}:wait()
            end
            t:job{'python', '-m', 'sphinx.cmd.build', '-b', 'html', 'docs', 'docs/_build/html'}:wait()
        end)
    end

    function T:clear_docs()
        local files_to_remove = {}
        for _, look_in in ipairs{'docs'} do
            vim.list_extend(files_to_remove, vim.fn.systemlist{
                'git', 'ls-files',
                '--others', '--ignored',
                '--exclude-from', '.gitignore',
                '--full-name',
                '--directory',
                look_in,
            })
        end
        if next(files_to_remove) == nil then
            return
        end
        blunder.create_window_for_terminal()
        vim.fn.termopen{'rm', '--verbose', '-Rf', unpack(files_to_remove)}
    end

    function T:browse_docs()
        vim.fn.system{'firefox', 'docs/_build/html/index.html'}
    end

    return T
end
