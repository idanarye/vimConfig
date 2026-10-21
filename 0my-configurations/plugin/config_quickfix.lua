local quicker = require'quicker'
local ck = require'caskey'

quicker.setup {
    edit = {
        enabled = false,
    },
    constrain_cursor = false,
    keys = {
        {
            '>',
            function()
                require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = 'Expand quickfix context',
        },
        {
            '<',
            function()
                require('quicker').collapse()
            end,
            desc = 'Collapse quickfix context',
        },
    },
}

local function toggle_qf_validity_for(pred, name)
    local qf = vim.fn.getqflist()

    local relevant_items_are_valid = vim.iter(qf):any(function(item)
        return pred(item) and item.valid == 1
    end)
    local set_valid_to
    if relevant_items_are_valid then
        set_valid_to = 0
    else
        set_valid_to = 1
    end
    local num_changed = 0
    for _, item in ipairs(qf) do
        if pred(item) then
            item.valid = set_valid_to
            num_changed = num_changed + 1
        end
    end
    if 0 < num_changed then
        vim.fn.setqflist(qf)
        vim.notify(('%d %s are now %s'):format(num_changed, name or 'items', ({[0] = 'invalid', [1] = 'valid'})[set_valid_to]))
    end
end

ck.setup {
    mode = 'n',
    name = 'quickfix',

    ['<M-q>'] = {
        ['r'] = { act = function()
            quicker.refresh()
        end, desc = 'refresh Quicker buffer ' },
        ['q'] = { act = function()
            quicker.toggle {
            }
        end, desc = 'toggle Quicker quickfix ' },
        ['Q'] = { act = function()
            quicker.open {
                focus = true,
            }
        end, desc = 'focus Quicker quickfix ' },
        ['l'] = { act = function()
            quicker.toggle {
                loclist = true,
            }
        end, desc = 'toggle Quicker loclist ' },
        ['L'] = { act = function()
            quicker.open {
                loclist = true,
                focus = true,
            }
        end, desc = 'focus Quicker loclist ' },
        ['w'] = { act = function()
            toggle_qf_validity_for(function(item)
                return item.type == 'W'
            end, 'warnings')
        end, desc = 'toggle warnings validity' },
        ['o'] = { act = function()
            local function is_outside_the_workdir(bufnr)
                local buftype = vim.api.nvim_get_option_value('buftype', {buf = bufnr})
                if buftype ~= '' then
                    -- special buffer - probably interesting
                    return true
                end
                local filename = vim.fs.abspath(vim.api.nvim_buf_get_name(bufnr))
                return vim.fs.relpath('.', filename) == nil
            end

            local cache = {}

            toggle_qf_validity_for(function(item)
                if cache[item.bufnr] == nil then
                    cache[item.bufnr] = is_outside_the_workdir(item.bufnr)
                end
                return cache[item.bufnr]
            end, 'outside items')
        end, desc = 'toggle validity of items from outside the workdir' },
    },
}
