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
return function(T, cfg)
    cfg = cfg or {}

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
                    return target
                end,
            }
            for _, target in ipairs(cfg.run_targets) do
                cc(target)
            end
            return cc:select()
        end

        function T:run()
            local target = T:run_target() or moonicipal.abort()
            vim.o.errorformat = [=[%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m ]=]
            blunder.run{'python', target}
        end

        function T:debug()
            local target = T:run_target() or moonicipal.abort()
            require'dap'.run {
                type = 'python',
                request = 'launch',
                program = target,
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

        blunder.create_window_for_terminal()
        local t = channelot.terminal()
        t:job{'pyenv', 'virtualenv-delete', '-f', cfg.venv_name}:wait()
        t:job{'pyenv', 'virtualenv', cfg.venv_python_version, cfg.venv_name}:wait()
        t:job{'pyenv', 'local', cfg.venv_name}:wait()
        t:job{'pip', 'install', 'mypy', 'ipython', 'sphinx==5.3.0'}:wait()
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
        local packages = T:packages()
        t:job{
            'python', '-m', 'mypy',
            '--follow-imports', 'silent',
            '--install-types', '--non-interactive',
            unpack(packages)
        }:wait()
        t:prompt_exit()
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

    function T:copy_git_hash()
        vim.fn.system('xclip', vim.fn.systemlist{'git', 'rev-parse', 'HEAD'}[1])
    end

    function T:doc()
        blunder.create_window_for_terminal()
        local t = channelot.terminal()
         for _, package in ipairs(T:packages()) do
             t:job{'python', '-m', 'sphinx.ext.apidoc', '-o', 'docs', package}:wait()
         end
         t:job{'python', '-m', 'sphinx.cmd.build', '-b', 'html', 'docs', 'docs/_build/html'}:wait()
        t:prompt_exit()
    end

    function T:clear_docs()
        vim.cmd'!rm -R docs/_build/ docs/_apidoc/'
    end

    function T:browse_docs()
        vim.fn.system{'firefox', 'docs/_build/html/index.html'}
    end

    return T
end
