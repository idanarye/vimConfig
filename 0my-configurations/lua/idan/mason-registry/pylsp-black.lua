local Package = require'mason-core.package'

return Package.new {
    name = 'pylsp-black',
    desc = 'Black support for pylsp',
    homepage = 'https://github.com/python-lsp/python-lsp-black',
    languages = { 'Python' },
    categories = { 'LSP' },
    install = function(ctx)
        local pylsp = require'mason-registry'.get_package('python-lsp-server')
        assert(pylsp:is_installed(), 'python-lsp-server is not installed')
        ctx.spawn[pylsp:get_install_path() .. '/venv/bin/python'] {
            '-m', 'pip', 'install', 'python-lsp-black',
        }
        ctx.receipt:with_primary_source(ctx.receipt.pip3('python-lsp-black'))
    end,
}
