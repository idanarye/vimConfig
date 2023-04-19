require'aerial'.setup {
}

vim.keymap.set('n', '<Leader>`', function()
    require'aerial'.toggle {
        focus = false,
        direction = 'right',
    }
end, {})

vim.keymap.set('n', '<M-p>t', function()
    vim.wait(1000, function()
        local data = require'aerial.data'.get(0)
        if not data then
            require'aerial'.sync_load()
            return false
        end
        local symbols = {}
        local symbol_captions = {}
        for _, symbol in data:iter() do
            local s = symbol
            local parts = {}
            while s do
                table.insert(parts, s.name)
                s = s.parent
            end
            vim.fn.reverse(parts)
            local path = table.concat(vim.fn.reverse(parts), '::')
            local caption = ('[%s#%s] %s'):format(symbol.kind, symbol.idx, path)
            symbols[caption] = symbol
            table.insert(symbol_captions, caption)
        end
        vim.cmd.messages('clear')
        require'fzf-lua'.fzf_exec(symbol_captions, {
            actions = {
                default = function(symbol_id)
                    local symbol = symbols[symbol_id[1]]
                    require'aerial'.select {
                        index = symbol.idx,
                    }
                end,
            },
            fzf_opts = {
                ['--no-multi'] = '',
            }
        })
        return true
    end)
end, {})
