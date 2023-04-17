local function tabs_info()
    return vim.fn.map(vim.api.nvim_list_tabpages(), function(ordinal, tabpage)
        local tab_caption = table.concat(vim.fn.map(vim.api.nvim_tabpage_list_wins(tabpage), function(_, win)
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':.')
            return bufname
        end), ' ')
        return {
            ordinal = ordinal + 1,
            tabpage = tabpage,
            caption = tab_caption,
        }
    end)
end

local function do_with_tabs(include_current, action)
    local tabs = tabs_info()
    if not include_current then
        local current_tabpage = vim.api.nvim_get_current_tabpage()
        tabs = vim.fn.filter(tabs, function(_, tab)
            return tab.tabpage ~= current_tabpage
        end)
    end
    vim.ui.select(tabs, {
        format_item = function(tab) 
            return ('[#%s] %s'):format(tab.ordinal, tab.caption)
        end,
    }, action)
end

vim.keymap.set('n', '<M-t><M-t>', function()
    do_with_tabs(true, function(tab)
        vim.api.nvim_set_current_tabpage(tab.tabpage)
    end)
end, {noremap = true})

vim.keymap.set('n', '<M-t>t', function()
    do_with_tabs(true, function(tab)
        vim.api.nvim_set_current_tabpage(tab.tabpage)
    end)
end, {noremap = true})

vim.keymap.set('n', '<M-t>m', function()
    do_with_tabs(false, function(tab)
        vim.fn.Tabmerge(tab.ordinal)
    end)
end, {noremap = true})
