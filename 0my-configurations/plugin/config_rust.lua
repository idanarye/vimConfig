vim.g.rustaceanvim = {
    tools = {
        server = {
            default_settings = {
                ["rust-analyzer"] = {
                    assist = {
                        importGranularity = "module";
                        importPrefix = "by_self";
                    },
                    cargo = {
                        loadOutDirsFromCheck = true;
                        features = 'all';
                    },
                    procMacro = {
                        enable = true;
                    },
                    completion = {
                        -- addCallArgumentSnippets = true;
                        -- addCallParenthesis = true;
                    },
                },
            },
        },
    },
}

require'crates'.setup {
}
require'ferris'.setup {
}
