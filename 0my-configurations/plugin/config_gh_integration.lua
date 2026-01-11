require'ghlite'.setup {
    open_command = 'xdg-open',
}

local ck = require'caskey'
ck.setup {
    mode = {'n'},
    name = 'GHLite',
    ['<Leader><C-g>'] = {
        act = function()
            local ghlite_commands = vim.iter(vim.api.nvim_get_commands{}):map(function(cmd)
                if vim.startswith(cmd, 'GHLite') then
                    return cmd
                end
            end):totable()
            vim.ui.select(ghlite_commands, {}, function(command)
                if command then
                    vim.cmd(command)
                end
            end)
        end,
    },
}

local ghlite_ns = vim.api.nvim_create_namespace('GHLiteNamespace')

vim.diagnostic.config({virtual_lines = true}, ghlite_ns)

require'idan.impairative-toggling':getter_setter {
    key = 'C',
    name = 'GHLite comments',
    get = function()
        return not not (vim.diagnostic.config(nil, ghlite_ns) or {}).virtual_lines
    end,
    set = function(enable)
        vim.diagnostic.config({virtual_lines = enable}, ghlite_ns)
    end,
}
