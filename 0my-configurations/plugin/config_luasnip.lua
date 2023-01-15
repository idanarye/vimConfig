vim.schedule(function()
    require("luasnip.loaders.from_vscode").lazy_load()
    local snippet_dirs = vim.fn.globpath(vim.o.runtimepath, 'snippets', nil, true)
    require("luasnip.loaders.from_lua").load {paths = snippet_dirs}
    require("luasnip.loaders.from_vscode").load {paths = snippet_dirs}
end)

local luasnip = require'luasnip'

vim.keymap.set({'i', 's'}, '<C-l>', function()
    if luasnip.expand_or_jumpable() then
        return '<Plug>luasnip-expand-snippet'
    elseif luasnip.choice_active() then
        return '<Plug>luasnip-next-choice'
    else
        return '<C-l>'
    end
end, {silent=true, expr = true})

vim.keymap.set({'i', 's'}, '<C-j>', function()
    if luasnip.jumpable() then
        luasnip.jump(1)
    else
        return '<C-j>'
    end
end, {silent=true, expr = true})

vim.keymap.set({'i', 's'}, '<C-k>', function()
    if luasnip.jumpable() then
        luasnip.jump(-1)
    else
        return '<C-j>'
    end
end, {silent=true, expr = true})
