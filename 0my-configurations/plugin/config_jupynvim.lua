local orig_opts = vim.iter({'conceallevel', 'concealcursor'}):fold({}, function(acc, k)
    acc[k] = vim.o[k]
    return acc
end)
require'jupynvim'.setup {
}
for k, v in pairs(orig_opts) do
    vim.o[k] = v
end
