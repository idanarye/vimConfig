---@type vim.lsp.Config
return {
    cmd = {
        'dotnet', 'run',
        '--property:Configuration=Release',
        '--project', '/files/builds/YarnSpinner/YarnSpinner.LanguageServer/'
    },
    filetypes = { 'yarn' },
    root_markers = {'.git', '*.yarnproject'},
}
