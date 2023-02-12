require'mason'.setup {}
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
    capabilities = capabilities;

    root_dir = function(startpath)
        if startpath == '' then
            startpath = vim.fn.getcwd()
        end
        return lspconfig.pylsp.document_config.default_config.root_dir(startpath)
    end;
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
