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
            local qf = vim.fn.getqflist()
            local warnings_are_valid = vim.iter(qf):any(function(item)
                return item.type == 'W' and item.valid == 1
            end)
            local set_valid_to
            if warnings_are_valid then
                set_valid_to = 0
            else
                set_valid_to = 1
            end
            local num_warnings = 0
            for _, item in ipairs(qf) do
                if item.type == 'W' then
                    item.valid = set_valid_to
                    num_warnings = num_warnings + 1
                end
            end
            if 0 < num_warnings then
                vim.fn.setqflist(qf)
                vim.notify(('%d warnings are now %s'):format(num_warnings, ({[0] = 'invalid', [1] = 'valid'})[set_valid_to]))
            end
        end, desc = 'toggle warnings validity' },
    },
}
