require'mason'.setup {}
require'mason-lspconfig'.setup {}
local lspconfig = require'lspconfig'
local lsp_extensions = require'lsp_extensions'

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

lspconfig.sumneko_lua.setup {
    capabilities = capabilities;

    cmd = {'lua-language-server'};
    settings = {
        Lua = {
            runtime = {
                -- Setup your lua path
                path = runtime_path,
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
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
}

lspconfig.serve_d.setup {
    capabilities = capabilities;
}
