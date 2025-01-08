local snippets = require'snippets'

if not SNIPPETS_SETUP then
    SNIPPETS_SETUP = true
    snippets.setup {
        create_autocmd = true,
        friendly_snippets = true,
    }

end
vim.schedule(function()
    local search_paths = snippets.config.get_option('search_paths')
    local already_has = {}
    for _, path in ipairs(search_paths) do
        already_has[path] = true
    end
    for _, snippet_dir in ipairs(vim.fn.globpath(vim.o.runtimepath, 'snippets', true, true)) do
        if not already_has[snippet_dir] then
            already_has[snippet_dir] = true
            table.insert(search_paths, snippet_dir)
        end
    end
    snippets.utils.register_snippets()
end)

local ck = require'caskey'

ck.setup {
    mode = {'i', 's'},
    name = 'Snippets',
    ['<M-l>'] = {act = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local match_pos = vim.fn.searchpos([=[\v<]=], 'bn', cursor[1])
        if match_pos[1] ~= cursor[1] then
            return
        end
        local trigger = vim.api.nvim_buf_get_text(0, cursor[1] - 1, match_pos[2] - 1, cursor[1] - 1, cursor[2], {})[1]
        local ft = vim.bo.filetype
        local snippet = snippets.load_snippets_for_ft(vim.bo.filetype)[trigger]
        if snippet then
            local snippet_body = snippet.body
            if vim.islist(snippet_body) then
                snippet_body = table.concat(snippet_body, '\n')
            end
            vim.api.nvim_buf_set_text(0, cursor[1] - 1, match_pos[2] - 1, cursor[1] - 1, cursor[2], {})
            vim.snippet.expand(snippet_body)
        end
    end, {}},
}
