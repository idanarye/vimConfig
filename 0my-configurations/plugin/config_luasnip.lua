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

vim.api.nvim_create_user_command('InsertSnippet', function()
    local all_snippets = require'luasnip.session.snippet_collection'.get_snippets(nil, 'snippets')
    local completions = {}
    local max_filetype_length = 0
    local max_trigger_length = 0
    for filetype, filetype_snippets in pairs(all_snippets) do
        if max_filetype_length < #filetype then
            max_filetype_length = #filetype
        end
        for _, snippet in ipairs(filetype_snippets) do
            if max_trigger_length < #snippet.trigger then
                max_trigger_length = #snippet.trigger
            end
        end
    end
    local fmt = ('%%-%ds [%%-%ds] %%s'):format(max_trigger_length, max_filetype_length)
    for filetype, filetype_snippets in pairs(all_snippets) do
        for _, snippet in ipairs(filetype_snippets) do
            completions[fmt:format(snippet.trigger, filetype, snippet.description[1])] = snippet
        end
    end

    local function get_snippet_from_chosen(chosen)
        for _, choice in ipairs(chosen) do
            local snippet = completions[choice]
            if snippet then
                return snippet
            end
        end
    end

    require'fzf-lua'.fzf_exec(vim.tbl_keys(completions), {
        nomulti = true,
        fn_selected = function(chosen)
            local snippet = get_snippet_from_chosen(chosen)
            luasnip.snip_expand(snippet)
        end,
    })
end, {desc = 'Insert a LuaSnip snippet'})
