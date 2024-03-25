vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':Neotree focus toggle<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader><Tab>', ':Neotree focus reveal<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>d', ':Neotree reveal current<Cr>', {noremap = true, silent = true})

require("neo-tree").setup {
    sources = {
        'filesystem',
        'buffers',
        'git_status',
        'diagnostics',
        'zk',
    },
    source_selector = {
        sources = {
            {
                source = 'filesystem',
            },
            {
                source = 'buffers',
            },
            {
                source = 'git_status',
            },
            {
                source = 'zk',
            },
            {
                source = 'diagnostics',
            },
        },
    },
    filesystem = {
        hijack_netrw_behavior = "open_current",
        window = {
            mappings = {
                ['t'] = function(state)
                    vim.cmd('tabnew ' .. state.tree:get_node():get_id())
                end,
                ['o'] = 'system_open',
                ['w'] = false,
            }
        },
        commands = {
            system_open = function(state)
                vim.api.nvim_command('silent !xdg-open ' .. state.tree:get_node():get_id())
            end,
        },
        bind_to_cwd = false,
    },
    event_handlers = {
        {
            event = 'file_open_requested',
            handler = function(args)
                if args.state.current_position == 'current' then
                    return
                end
                local path = args.path
                local open_cmd = args.open_cmd or "edit"
                local window = require'window-picker'.pick_window()
                if window then
                    vim.api.nvim_set_current_win(window)
                    vim.api.nvim_command(open_cmd .. ' ' .. path)
                end
                return { handled = true }
            end,
        },
    },
    zk = {
        bind_to_cwd = true,
        follow_current_file = false,
    },
}
vim.fn.sign_define("LspDiagnosticsSignError", {text = " ", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = " ", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = " ", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})

vim.api.nvim_create_user_command('FixNeoTreeLingeringBuffer', function()
    local shown_buffers = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        shown_buffers[vim.api.nvim_win_get_buf(win)] = true
    end
    local deleted_buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if not shown_buffers[buf] and vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile' and vim.api.nvim_buf_get_option(buf, 'filetype') == 'neo-tree' then
            deleted_buffers[buf] = true
            vim.api.nvim_buf_delete(buf, {})
        end
    end
    vim.notify('Deleted ' .. vim.tbl_count(deleted_buffers) .. ' lingering NeoTree buffers')
end, {})
