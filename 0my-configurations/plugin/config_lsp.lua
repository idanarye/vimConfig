local nvim_lsp = require'lspconfig'
local lsp_extensions = require'lsp_extensions'

local on_attach = function(client)
    require'completion'.on_attach(client)
end

lsp_extensions.inlay_hints{
    prefix = '',
    highlight = "Comment",
    enabled = {"TypeHint", "ChainingHint", "ParameterHint"},
}

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
            completion = {
                -- addCallArgumentSnippets = true,
                -- addCallParenthesis = true,
            },
        }
    }
})

nvim_lsp.jedi_language_server.setup({
    -- cmd = { 'jedi-language-server', '--log-file', '/tmp/jedilog.log' }
})

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true;
require'lspconfig'.ccls.setup{}
