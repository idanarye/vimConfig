local Package = require'mason-core.package'

return Package.new {
    name = 'pylsp-mypy',
    desc = 'MyPy support for pylsp',
    homepage = 'https://github.com/python-lsp/pylsp-mypy',
    languages = { 'Python' },
    categories = { 'LSP' },
    install = function(ctx)
        local pylsp = require'mason-registry'.get_package('python-lsp-server')
        assert(pylsp:is_installed(), 'python-lsp-server is not installed')
        ctx.spawn[pylsp:get_install_path() .. '/venv/bin/python'] {
            '-m', 'pip', 'install', 'pylsp-mypy',
        }
        ctx.receipt:with_primary_source(ctx.receipt.pip3('pylsp-mypy'))
    end,
}
