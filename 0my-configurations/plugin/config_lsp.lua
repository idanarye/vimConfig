local lsp_installer = require'nvim-lsp-installer'
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
  floating_window_above_cur_line = true;
}


require'fzf_lsp'.setup {
  override_ui_select = true;
}

local server_setups = {}

server_setups.rust_analyzer = {
    capabilities = capabilities,
    -- on_attach = on_attach,
    --on_attach = require'completion'.on_attach;
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module";
                importPrefix = "by_self";
            },
            cargo = {
                loadOutDirsFromCheck = true;
                allFeatures = true;
            },
            procMacro = {
                enable = true;
            },
            completion = {
                -- addCallArgumentSnippets = true;
                -- addCallParenthesis = true;
            },
        }
    }
}

server_setups.pylsp = {
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
      return nvim_lsp.pylsp.document_config.default_config.root_dir(startpath)
    end;
  }


server_setups.ccls = {}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

server_setups.sumneko_lua = {
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

server_setups.kotlin_language_server = {
}

for server_name, _ in pairs(server_setups) do
  local _, server = lsp_installer.get_server(server_name)
  if not server:is_installed() then
    server:install()
  end
end

lsp_installer.on_server_ready(function(server)
  local setup_opts = server_setups[server.name]
  if setup_opts then
    server:setup(server_setups[server.name])
  end
end)
