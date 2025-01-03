local function tabs_info()
    return vim.fn.map(vim.api.nvim_list_tabpages(), function(ordinal, tabpage)
        return {
            ordinal = ordinal + 1,
            tabpage = tabpage,
        }
    end)
end

local function do_with_tabs(include_current, action)
    local tabs = tabs_info()
    local preselect
    if include_current then
        local current_tabpage = vim.api.nvim_get_current_tabpage()
        preselect = vim.iter(ipairs(tabs)):find(function(_, tab)
            return tab.tabpage == current_tabpage
        end)
    else
        local current_tabpage = vim.api.nvim_get_current_tabpage()
        tabs = vim.fn.filter(tabs, function(_, tab)
            return tab.tabpage ~= current_tabpage
        end)
    end
    require'moonicipal.util'.defer_to_coroutine(function()
        local chosen_tab = require'moonicipal'.select(tabs, {
            format = function(tab)
                local caption = require'tabby.feature.tab_name'.get(tab.tabpage)
                return ('[#%s] %s'):format(tab.ordinal, caption)
            end,
            preview = function(tab)
                -- local tab_caption = table.concat(vim.fn.map(vim.api.nvim_tabpage_list_wins(tabpage), function(_, win)
                return vim.iter(vim.api.nvim_tabpage_list_wins(tab.tabpage))
                :map(function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':.')
                end)
                :join('\n')
            end,
            preselect = preselect,
        })
        action(chosen_tab)
    end)
end

local function gen_do_with_tabs_fn(include_current, action)
    return function()
        do_with_tabs(include_current, action)
    end
end

local ck = require'caskey'

ck.setup {
    mode = {'n'},
    ['<M-t>'] = vim.tbl_extend('error', {
        ['<M-t>'] = {act = gen_do_with_tabs_fn(true, function(tab)
                vim.api.nvim_set_current_tabpage(tab.tabpage)
        end), desc = 'select a tab to jump to'},

        ['t'] = {act = gen_do_with_tabs_fn(true, function(tab)
                vim.api.nvim_set_current_tabpage(tab.tabpage)
        end), desc = 'select a tab to jump to'},

        ['m'] = {act = gen_do_with_tabs_fn(false, function(tab)
                vim.fn.Tabmerge(tab.ordinal)
        end), desc = 'select a tab to jump to merge with the current tab'},
        ['n'] = {act = ck.cmd'tabnew'},
        ['q'] = {act = ck.cmd'tabclose'},
        ['c'] = {act = ck.cmd'tabclose'},
        ['o'] = {act = ck.cmd'tabonly'},
        ['l'] = {act = ck.cmd'tabmove +1'},
        ['L'] = {act = ck.cmd'tabmove'},
        ['h'] = {act = ck.cmd'tabmove -1'},
        ['H'] = {act = ck.cmd'tabmove 0'},
        ['s'] = {act = ck.cmd'tab split'},
    }, (function()
        local mappings = {}
        for i = 1, 9 do
            mappings[tostring(i)] = {act = ck.cmd('tabnext ' .. i)}
        end
        return mappings
    end)()),
}
