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


-- This is already defined by rust-tools in config_rust.lua
-- lspconfig.rust_analyzer.setup {}

lspconfig.pylsp.setup {
    capabilities = capabilities,

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
            runtime = {
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        },
    },
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
