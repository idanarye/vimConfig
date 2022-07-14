local fzf = require'fzf-lua'

local wikipage_fzf = function()
    local paths = {}
    for _, v in pairs(vim.g.vimwiki_wikilocal_vars) do
        paths[v.path] = true
    end
    local paths2 = {}
    for k, _ in pairs(paths) do
        table.insert(paths2, k)
    end
    local wiki_files = vim.fn.globpath(table.concat(paths2, ','), '**/*.wiki', 0, 1)
    fzf.fzf_exec(wiki_files, {
        actions = fzf.defaults.actions.files;
        preview = 'cat {}';
    })
end

vim.keymap.set('n', '<M-p>w', wikipage_fzf)
vim.keymap.set('n', '<M-p><M-w>', wikipage_fzf)
