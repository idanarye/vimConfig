require'caskey'.setup {
    mode = {'n'},
    name = 'LSP',
    ['K'] =  {act = vim.lsp.buf.hover, desc = 'LSP show documentation'},
    ['\\'] = {
        ['f'] = {mode = {'v'}, act = function() vim.lsp.buf.format{ range = {} } end, desc = 'LSP format selected lines'},
        ['a'] = {mode = {'n', 'v'}, act = function()
            local mode = vim.api.nvim_get_mode()
            if mode.mode == 'v' or mode.mode == 'V' or mode.mode == '\22' then
                vim.lsp.buf.code_action{ range = {
                    ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
                    ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
                } }
            else
                vim.lsp.buf.code_action()
            end
        end, desc = 'LSP code actions'},

        ['d'] = {act = vim.lsp.buf.definition, desc = 'LSP jump to definition'},
        ['D'] = {act = vim.lsp.buf.implementation, desc = 'LSP jump to imlementations'},
        ['k'] = {act = vim.lsp.buf.signature_help, desc = 'LSP signature help'},
        ['<C-d>'] = {act = vim.lsp.buf.type_definition, desc = 'LSP jump to type definition'},
        ['n'] = {act = vim.lsp.buf.references, desc = 'LSP jump to references'},
        ['0'] = {act = vim.lsp.buf.document_symbol, desc = 'LSP document symbol'},
        ['W'] = {act = vim.lsp.buf.workspace_symbol, desc = 'LSP workspace symbol'},
        ['<M-d>'] = {act = vim.lsp.buf.declaration, desc = 'LSP jump to declaration'},
        ['r'] = {act = vim.lsp.buf.rename, desc = 'LSP rename'},
        ['q'] = {act = function()
            vim.diagnostic.open_float {
                suffix = function(d)
                    return (' (%s)'):format(d.source)
                end,
            }
        end, desc = 'show diagnostics' }
        -- ['q'] = <cmd> LspDiagnostics 0<CR>
        -- ['Q'] = <cmd> LspDiagnosticsAll<CR>
    },
}

vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
end, {})

require'mason'.setup {
}

local local_settings_loaded, local_settings = pcall(require, 'idan_local_settings')
if not local_settings_loaded then
    local_settings = {}
end

require'nlspsettings'.setup {
    config_home = vim.fn.globpath(vim.o.runtimepath, 'nlsp-settings');
    append_default_schemas = true;
    loader = 'yaml';
}

vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                    resolveSupport = {
                        properties = {
                            'documentation',
                            'detail',
                            'additionalTextEdits',
                        }
                    },
                },
            },
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            },
        },
    },
})


require'lsp_extensions'.inlay_hints{
    prefix = '',
    highlight = "Comment",
    enabled = {"TypeHint", "ChainingHint", "ParameterHint"},
}

--require'lsp_signature'.setup {
    --toggle_key = '<M-s>';
    --floating_window = false;
--}


require'fzf_lsp'.setup {
    --override_ui_select = true;
}


local function resolve_python_info(root_dir)
    local uses_uv = vim.system({'uv', 'tree', '--frozen', '--offline'}, {cwd = root_dir}):wait().code == 0
    local python_cmd
    if uses_uv then
        python_cmd = {'uv', '--quiet', 'run', 'python'}
    else
        python_cmd = {'python'}
    end

    if IdanLocalCfg.override_python_command_for_getting_site_packages then
        python_cmd = IdanLocalCfg.override_python_command_for_getting_site_packages() or python_cmd
    end

    local result = vim.system(python_cmd, {
        cwd = root_dir,
        stdin = require'plenary.strings'.dedent[=[
        import sys
        import site
        import json
        json.dump({
            "python_executable": sys.executable,
            "python_version": "{}.{}".format(*sys.version_info),
            "site_packages": site.getsitepackages(),
        }, sys.stdout)
        ]=],
    }):wait()
    if result.code ~= 0 then
        error(result.stderr)
    end
    local info = vim.json.decode(result.stdout)

    if IdanLocalCfg.add_special_python_site_packages then
        IdanLocalCfg.add_special_python_site_packages(info.site_packages)
    end
    return info
end

if true then
    vim.lsp.enable('basedpyright')
    vim.lsp.config('basedpyright', {
        before_init = function(_params, config)
            local python_info = resolve_python_info(config.root_dir)

            config.settings.python.pythonPath = python_info.python_executable

            vim.list_extend(config.settings.basedpyright.analysis.extraPaths, python_info.site_packages)
            -- TODO: only do this if version is less than 3.12?
            config.settings.basedpyright.analysis.diagnosticSeverityOverrides.reportImplicitOverride = 'none'
        end,
        settings = {
            python = {
            },
            basedpyright = {
                analysis = {
                    extraPaths = {},
                    diagnosticSeverityOverrides = {
                        reportUnknownParameterType = 'none',
                        reportUnknownArgumentType = 'none',
                        reportUnknownLambdaType = 'none',
                        reportUnknownVariableType = 'none',
                        reportUnknownMemberType = 'none',
                        reportAny = 'none',
                        reportExplicitAny = 'none',
                        reportUnusedCallResult = 'none',
                    },
                },
            },
        },
    })
end

if true then
    vim.lsp.enable('ruff')
    vim.lsp.config('ruff', {
        before_init = function(_params, config)
            if IdanLocalCfg.modify_ruff_settings then
                IdanLocalCfg.modify_ruff_settings(config.init_options.settings)
            end
        end,
        init_options = {
            settings = {
                lint = {
                    select = {
                        'E', -- pycodestyle errors
                        'W', -- pycodestyle warnings
                        'F', -- flake8
                        'Q', -- quotes
                        'N', -- pep8 naming
                        'U', -- pyupgrade
                        'B', -- bugbear
                        'A', -- bultins
                        'COM', -- commas
                        'C', -- comprehensions
                        'ISC', -- implicit-str-concat
                        'PIE', -- flake8-pie
                        'ERA', -- eradicate
                        'PLE', -- pylint errors
                    },
                    ['extend-select'] = {'E223'},
                    preview = true,
                },
                format = {
                    preview = true,
                },

            },
        },
    })
end


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.enable('emmylua_ls')
vim.lsp.config('emmylua_ls', {
    on_init = function(client)
        --local path = client.workspace_folders[1].name
        --if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            --return
        --end
        local set_of_plugins = {}
        for _, plugin_name in ipairs({
            'nvim',
            'runtime',
            '0my-configurations',
            'local',

            'nvim-dap',
            'plenary.nvim',

            'nvim-moonicipal',
            'nvim-channelot',
            'nvim-buffls',
            'nvim-blunder',
            'nvim-impairative',
            'vim-for-weka',
        })
        do
            set_of_plugins[plugin_name] = true
        end
        local plugin_paths_to_add = vim.tbl_filter(function(plugin_path)
            local plugin_name = vim.fs.basename(vim.fs.dirname(plugin_path))
            return set_of_plugins[plugin_name]
        end, vim.api.nvim_get_runtime_file("lua", true))

        client.settings.Lua = {
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                    vim.env.VIMRUNTIME .. '/lua/vim/lsp',
                    unpack(plugin_paths_to_add),
                }
            },
        }
    end
})

vim.lsp.enable('kotlin_language_server')

vim.lsp.enable('jsonls')
-- For some reason this doesn't work:
vim.lsp.config('jsonls', {
    settings = {
        json = {
            schemas = {
                {
                    uri = 'https://raw.githubusercontent.com/YarnSpinnerTool/YarnSpinner/refs/heads/main/YarnSpinner.Compiler/YarnProject.schema.json',
                    fileMatch = { '*.yarnproject' },
                },
            },
        }
    }
})

vim.lsp.enable('yamlls')
vim.lsp.config('yamlls',  {
    settings = {
        yaml = {
            schemas = local_settings.yaml_schemas,
        },
    },
})

vim.lsp.enable('serve_d')

vim.lsp.enable('nushell')

vim.lsp.enable('protols')

vim.lsp.enable('yarn_spinner')

vim.cmd [=[
augroup YarnFileType
autocmd!
autocmd BufRead,BufNewFile *.yarn setfiletype yarn
autocmd BufRead,BufNewFile *.yarnproject setfiletype json
augroup END
]=]
