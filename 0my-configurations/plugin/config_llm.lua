local aider = require'nvim_aider'
vim.schedule(function()
    aider.setup {
        args = (function()
            local args = {}
            vim.list_extend(args, {'--no-auto-commits'})
            if vim.fn.filereadable('aider.conf.yml') == 1 then
                vim.list_extend(args, {'--config', 'aider.conf.yml'})
            elseif vim.env.GOOGLE_API_KEY then
                vim.list_extend(args, {
                    '--model', 'gemini',
                    '--api-key', 'gemini=' .. vim.env.GOOGLE_API_KEY,
                })
            end
            return args
        end)(),
        auto_reload = true,
    }
end)

local ck = require'caskey'
ck.setup {
    mode = {'n', 'v'},
    name = 'LLM',
    ['<M-a>'] = {
        ['/'] = {
            act = aider.api.open_command_picker,
            desc = 'Aider open_command_picker',
        },
        ['<M-a>'] = {
            act = aider.api.send_to_terminal,
            desc = 'Aider send_to_terminal',
        },
        ['f'] = {
            act = aider.api.add_current_file,
            desc = 'Aider add_current_file',
        },
        -- ['F'] = {
            -- act = aider.api.add_file,
            -- desc = 'Aider add_file',
        -- },
        ['F'] = {
            act = aider.api.add_read_only_file,
            desc = 'Aider add_read_only_file',
        },
        ['d'] = {
            act = aider.api.drop_current_file,
            desc = 'Aider drop_current_file',
        },
        -- ['D'] = {
            -- act = aider.api.drop_file,
            -- desc = 'Aider drop_file',
        -- },
        ['h'] = {
            act = aider.api.health_check,
            desc = 'Aider health_check',
        },
        ['R'] = {
            act = aider.api.reset_session,
            desc = 'Aider reset_session',
        },
        ['b'] = {
            act = aider.api.send_buffer_with_prompt,
            desc = 'Aider send_buffer_with_prompt',
        },
        -- ['c'] = {
            -- act = aider.api.send_command,
            -- desc = 'Aider send_command',
        -- },
        ['q'] = {
            act = aider.api.send_diagnostics_with_prompt,
            desc = 'Aider send_diagnostics_with_prompt',
        },
        ['t'] = {
            act = aider.api.toggle_terminal,
            desc = 'Aider toggle_terminal',
        },
    },
}
