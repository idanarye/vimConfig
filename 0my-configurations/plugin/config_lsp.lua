local nvim_lsp = require'lspconfig'
local lsp_extensions = require'lsp_extensions'

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
lsp_extensions.inlay_hints{
    prefix = '',
    highlight = "Comment",
    enabled = {"TypeHint", "ChainingHint", "ParameterHint"},
}

require'lsp_signature'.setup {
  toggle_key = '<M-s>';
}


require'lspfuzzy'.setup {
}

nvim_lsp.rust_analyzer.setup({
    capabilities = capabilities,
    -- on_attach = on_attach,
    --on_attach = require'completion'.on_attach;
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

-- nvim_lsp.jedi_language_server.setup {
    -- init_options = {
        -- diagnostics = {
            -- enable = false,
        -- }
    -- },
    -- settings = {
        -- ['jedi-language-server'] = {
            -- diagnostics = {
                -- enable = false,
            -- },
        -- },
    -- },
-- }

nvim_lsp.jedi_language_server.setup {
    capabilities = capabilities,
    -- cmd = { 'jedi-language-server', '--log-file', '/tmp/jedilog.log' },
    init_options = {
        workspace = {
            extraPaths = {
                '/home/idanarye/.vim/plugins/vim-omnipytent/autoload',
                '/home/idanarye/.vim/plugins/vim-omnipytent-extra',
                unpack(vim.g.extraJediPaths or {}),
            }
        },
    }
}
 -- nvim_lsp.pylsp.setup {
   -- capabilities = capabilities;
 -- }


require'lspconfig'.ccls.setup{}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {'lua-language-server'};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.kotlin_language_server.setup{}
