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
    if vim.snippet.active{direction = 1} then
        return '<cmd>lua vim.snippet.jump(1)<cr>'
    elseif luasnip.jumpable() then
        -- luasnip.jump(1)
        return [=[<cmd>lua require'luasnip'.jump(1)<Cr>]=]
    else
        return '<C-j>'
    end
end, {silent=true, expr = true})

vim.keymap.set({'i', 's'}, '<C-k>', function()
    if vim.snippet.active{direction = -1} then
        return '<cmd>lua vim.snippet.jump(-1)<cr>'
    elseif luasnip.jumpable() then
        --luasnip.jump(-1)
        return [=[<cmd>lua require'luasnip'.jump(-1)<Cr>]=]
    else
        return '<C-k>'
    end
end, {silent=true, expr = true})

vim.api.nvim_create_user_command('InsertSnippet', function()
    local relevant_filetypes = vim.tbl_keys(luasnip.available())
    local all_snippets = require'luasnip.session.snippet_collection'.get_snippets(nil, 'snippets')
    local completions = {}
    local max_filetype_length = 0
    local max_trigger_length = 0
    for _, filetype in ipairs(relevant_filetypes) do
        if max_filetype_length < #filetype then
            max_filetype_length = #filetype
        end
        for _, snippet in ipairs(all_snippets[filetype] or {}) do
            if max_trigger_length < #snippet.trigger then
                max_trigger_length = #snippet.trigger
            end
        end
    end
    local fmt = ('%%-%ds [%%-%ds] %%s'):format(max_trigger_length, max_filetype_length)
    for _, filetype in ipairs(relevant_filetypes) do
        for _, snippet in ipairs(all_snippets[filetype] or {}) do
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
            local action, text = unpack(chosen)
            if action == 'esc' then
                return
            end
            local snippet = completions[text]
            if snippet == nil then
                return
            end
            luasnip.snip_expand(snippet)
        end,
    })
end, {desc = 'Insert a LuaSnip snippet'})
