vim.g.rustaceanvim = {
    server = {
        cmd = function()
            return { 'nice', '-n', '19', 'rust-analyzer' }
        end,
        capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }
            return capabilities
        end)(),
        default_settings = {
            ["rust-analyzer"] = {
                numThreads = 2,
                cachePriming = {
                    enable = true,
                    numThreads = 1,
                },
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                    features = 'all',
                    -- targetDir = 'target/ra',
                    targetDir = true,
                    extraEnv = {
                        CARGO_BUILD_JOBS = '2',
                    }
                },
                lens = {
                    enable = false,
                },
                lru = {
                    capacity = 64,
                },
                files = {
                    watcher = 'server',
                    -- exclude =  {'target', 'node_modules', '.git'},
                },
                server = {
                    extraEnv = {
                        NICENESS = '15',
                    }
                },
                procMacro = {
                    enable = true,
                },
                completion = {
                    addCallArgumentSnippets = true,
                    -- addCallParenthesis = true,
                },
            },
        },
    },
}

require'crates'.setup {
}
require'ferris'.setup {
}
