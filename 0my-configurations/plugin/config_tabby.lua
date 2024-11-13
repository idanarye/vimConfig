vim.o.showtabline = 2

local theme = {
    fill = 'TabLineFill',
    head = 'TabLine',
    current_tab = 'TabLine',
    tab = 'TabLineSel',
    win = 'TabLine',
    tail = 'TabLine',
}
require('tabby.tabline').set(function(line)
    return {
        {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local any_changed = false
            for _, win in ipairs(tab.wins().wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.api.nvim_get_option_value('modified', {buf = buf}) then
                    any_changed = true
                    break
                end
            end
            if any_changed then
                if type(hl) ~= 'table' then
                    hl = vim.api.nvim_get_hl(0, {name = hl})
                    for _, field in ipairs{'bg', 'fg'} do
                        if type(hl[field]) == 'number' then
                            hl[field] = ('#%06x'):format(hl[field])
                        end
                    end
                end
                hl.style = 'italic'
            end
            return {
                line.sep('', hl, theme.fill),
                tab.is_current() and '' or '',
                tab.number(),
                tab.name(),
                tab.close_btn(''),
                line.sep('', hl, theme.fill),
                hl = hl,
                margin = ' ',
            }
        end),
        line.spacer(),
        --line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            --local hl = nil
            --if win.buf().is_changed() then
                --hl = {style = 'italic'}
            --end
            --return {
                --line.sep('', theme.win, theme.fill),
                --win.is_current() and '' or '',
                --{win.buf_name(), hl=hl},
                --line.sep('', theme.win, theme.fill),
                --hl = theme.win,
                --margin = ' ',
            --}
        --end),
        {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
        },
        hl = theme.fill,
    }
end)
