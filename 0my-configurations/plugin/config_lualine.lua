require'debugmaster.debug.mode'
local function replace_if_debugmaster_active(value)
    return function(...)
        local mode = vim.api.nvim_get_mode()
        if mode.mode ~= 'n' then
            return ...
        end
        if require'debugmaster.debug.mode'.is_active() then
            return value
        else
            return ...
        end
    end
end

require'lualine'.setup {
    sections = {
        lualine_a = {
            {
                'mode',
                fmt = replace_if_debugmaster_active('DEBUG'),
                -- This doesn't work properly
                -- color = replace_if_debugmaster_active('dCursor'),
            },
        },
    },
    inactive_sections = {
        lualine_a = {
            function()
                return vim.fn.winnr()
            end,
        },
    },
}

require'lualine'.get_config().sections.lualine_a = {}
