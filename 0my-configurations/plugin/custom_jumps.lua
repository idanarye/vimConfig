local function compare_position(this, that)
    if type(this) == 'table' and type('that') == table then
        local compare_row = compare_position(this[1], that[1])
        if compare_row == 0 then
            return compare_position(this[2], that[2])
        else
            return compare_row
        end
    else
        if type(this) == 'table' then
            this = this[1]
        end
        if type(that) == 'table' then
            that = that[1]
        end
        if this == that then
            return 0
        elseif this < that then
            return -1
        else
            return 1
        end
    end
end

local function create_mapping(char, source)
    local function create_jump_function(selector)
        return function()
            local selected = selector(source())
            if type(selected) == 'number' then
                local current_cursor = vim.api.nvim_win_get_cursor(0)
                vim.api.nvim_win_set_cursor(0, {selected, current_cursor[2]})
            elseif type(selected) == 'table' then
                vim.api.nvim_win_set_cursor(0, selected)
            end
        end
    end

    local mappings_to_selectors = {
        ['[' .. char:upper()] = function(items)
            return items[1]
        end,
        [']' .. char:upper()] = function(items)
            return items[#items]
        end,
        ['[' .. char] = function(items)
            local current_cursor = vim.api.nvim_win_get_cursor(0)
            local closest = nil
            for _, item in ipairs(items) do
                if 0 < compare_position(current_cursor, item) then
                    if closest then
                        if 0 < compare_position(item, closest) then
                            closest = item
                        end
                    else
                        closest = item
                    end
                end
            end
            return closest
        end,
        [']' .. char] = function(items)
            local current_cursor = vim.api.nvim_win_get_cursor(0)
            vim.cmd.messages('clear')
            local closest = nil
            for _, item in ipairs(items) do
                if compare_position(current_cursor, item) < 0 then
                    if closest then
                        if compare_position(item, closest) < 0 then
                            closest = item
                        end
                    else
                        closest = item
                    end
                end
            end
            return closest
        end,
    }

    for mapping, selector in pairs(mappings_to_selectors) do
        vim.keymap.set('n', mapping, create_jump_function(selector), {noremap = true})
    end
end

create_mapping('g', function()
    local git_cmd = table.concat({
        'git diff --unified=0 --',
        vim.fn.shellescape(vim.fn.expand('%')),
        [=[| grep "^@@ " | cut -d\  -f3 | sed "s/^[^0-9]*\([0-9]\+\).*/\1/"]=],
    }, ' ')
    return vim.fn.map(vim.fn.systemlist(git_cmd), function(_, line)
        return tonumber(line)
    end)
end)

create_mapping('d', function()
    return vim.fn.map(vim.diagnostic.get(0), function(_, diag)
        return {diag.lnum + 1, diag.col}
    end)
end)
