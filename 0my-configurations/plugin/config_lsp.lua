local lsp_installer = require'nvim-lsp-installer'
lsp_installer.setup {}
local lspconfig = require'lspconfig'
local lsp_extensions = require'lsp_extensions'

local capabilities = vim.lsp.protocol.make_client_capabilities()
 capabilities.textDocument.completion.completionItem.snippetSupport = true
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
  floating_window_above_cur_line = true;
}


require'fzf_lsp'.setup {
  override_ui_select = true;
}


-- This is already defined by rust-tools in config_rust.lua
-- lspconfig.rust_analyzer.setup {}

lspconfig.pylsp.setup {
    capabilities = capabilities;

    settings = {
      pylsp = {
        plugins = {
          flake8 = {
            enabled = true;
            ignore = {'F403', 'F405', 'W503'};
          };
          pycodestyle = {
            enabled = false;
            maxLineLength = 130;
          };
          pyflakes = {
            enabled = false;
          };
          jedi = {
            extra_paths = {
              '/home/idanarye/.vim/plugins/vim-omnipytent/autoload',
              '/home/idanarye/.vim/plugins/vim-omnipytent-extra',
              unpack(vim.g.extraJediPaths or {}),
            };
          };
        };
      };
    };

    root_dir = function(startpath)
      if startpath == '' then
        startpath = vim.fn.getcwd()
      end
      return lspconfig.pylsp.document_config.default_config.root_dir(startpath)
    end;
  }


lspconfig.ccls.setup {}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
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

lspconfig.kotlin_language_server.setup {
}

lspconfig.jsonls.setup {
  capabilities = capabilities;
}

lspconfig.yamlls.setup {
}
