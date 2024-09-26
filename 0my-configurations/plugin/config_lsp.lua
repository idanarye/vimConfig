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
        -- ['q'] = <cmd> LspDiagnostics 0<CR>
        -- ['Q'] = <cmd> LspDiagnosticsAll<CR>
    },
}

vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
end, {})

require'mason'.setup {
    registries = {
        'github:mason-org/mason-registry',
        'lua:idan.mason-registry.index',
    },
}
require'mason-lspconfig'.setup {}
local mason_core_path = require'mason-core.path'

local lspconfig = require'lspconfig'
local lsp_extensions = require'lsp_extensions'

local local_settings_loaded, local_settings = pcall(require, 'idan_local_settings')
if not local_settings_loaded then
    local_settings = {}
end

require'nlspsettings'.setup {
    config_home = vim.fn.globpath(vim.o.runtimepath, 'nlsp-settings');
    append_default_schemas = true;
    loader = 'yaml';
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

lsp_extensions.inlay_hints{
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


-- This is already defined by rustaceanvim in config_rust.lua
-- lspconfig.rust_analyzer.setup {}

lspconfig.pylsp.setup {
    capabilities = capabilities,

    on_new_config = function(new_config, new_root_dir)
        local uses_uv = vim.system({'uv', 'tree', '--frozen', '--offline'}, {cwd = new_root_dir}):wait().code == 0
        local python_cmd
        if uses_uv then
            python_cmd = {'uv', '--quiet', 'run', 'python'}
        else
            python_cmd = {'python'}
        end

        local result = vim.system(python_cmd, {
            cwd = new_root_dir,
            stdin = require'plenary.strings'.dedent[=[
            import site
            for site_package in site.getsitepackages():
                print(site_package)
            ]=],
        }):wait()
        local site_packages = vim.split(result.stdout, '\n', {plain = true, trimempty = true})

        if IdanLocalCfg.add_special_python_site_packages then
            IdanLocalCfg.add_special_python_site_packages(site_packages)
        end

        vim.list_extend(new_config.settings.pylsp.plugins.jedi.extra_paths, site_packages)
    end,

    cmd_env = vim.empty_dict(),

    root_dir = function(startpath)
        if startpath == '' then
            startpath = vim.fn.getcwd()
        end
        return lspconfig.pylsp.document_config.default_config.root_dir(startpath)
    end,

    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = false,
                },
                flake8 = {
                    enabled = true,
                    maxLineLength = 130,
                },
                pylsp_black = {
                    enabled = true,
                },
                pylsp_mypy = {
                    enabled = true,
                    overrides = {'--follow-imports', 'silent', true},
                },
                jedi = {
                    extra_paths = {}
                },
            }
        },
    },
}


--lspconfig.ccls.setup {
    --capabilities = capabilities;
--}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup {
    capabilities = capabilities;

    root_dir = function(startpath)
        if vim.endswith(startpath, '.moonicipal.lua') then
            return vim.fs.dirname(startpath)
        end
        return lspconfig.lua_ls.document_config.default_config.root_dir(startpath)
    end,

    cmd = {mason_core_path.bin_prefix'lua-language-server'},
    settings = {
        Lua = {
            --runtime = {
                --version = 'LuaJIT',
                ---- Setup your lua path
                --path = runtime_path,
            --},
            --diagnostics = {
                --globals = {'vim'},
            --},
            --workspace = {
                ---- Make the server aware of Neovim runtime files
                --library = vim.api.nvim_get_runtime_file("", true),
                --checkThirdParty = false,
            --},
        },
    },

    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
        end
        local set_of_plugins = {}
        for _, plugin_name in ipairs({
            'nvim',
            'runtime',
            '0my-configurations',
            'local',

            'nvim-dap',

            'nvim-moonicipal',
            'nvim-channelot',
            'nvim-buffls',
            'nvim-blunder',
            'nvim-impairative',
        })
        do
            set_of_plugins[plugin_name] = true
        end
        local plugin_paths_to_add = vim.tbl_filter(function(plugin_path)
            local plugin_name = vim.fs.basename(vim.fs.dirname(plugin_path))
            return set_of_plugins[plugin_name]
        end, vim.api.nvim_get_runtime_file("lua", true))
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            diagnostics = {
                --globals = {'vim'},
            },
            hint = {
                enable = true,
                arrayIndex = 'Enable',
                setType = true,
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = 'ApplyInMemory',
                library = {
                    vim.env.VIMRUNTIME,
                    vim.env.VIMRUNTIME .. '/lua/vim/lsp',
                    unpack(plugin_paths_to_add),
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        })

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
}

lspconfig.kotlin_language_server.setup {
    capabilities = capabilities;
}

lspconfig.jsonls.setup {
    capabilities = capabilities;
}

lspconfig.yamlls.setup {
    capabilities = capabilities;
    settings = {
        yaml = {
            schemas = local_settings.yaml_schemas,
        },
    },
}

lspconfig.serve_d.setup {
    capabilities = capabilities;
}

lspconfig.nushell.setup {
}

require'lspconfig.configs'.yarn_spinner = {
    default_config = {
        cmd = {
            'dotnet', 'run',
            '--property:Configuration=Release',
            '--project', '/files/builds/YarnSpinner/YarnSpinner.LanguageServer/'
        },
        filetypes = { 'yarn' },
        root_dir = lspconfig.util.root_pattern('.git', '*.yarn'),
    }
}

lspconfig.yarn_spinner.setup {
    capabilities = capabilities,
}

vim.cmd [=[
augroup YarnFileType
autocmd!
autocmd BufRead,BufNewFile *.yarn setfiletype yarn
augroup END
]=]
