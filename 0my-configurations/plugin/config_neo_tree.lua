vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':Neotree focus toggle<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader><Tab>', ':Neotree focus reveal<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>d', ':Neotree reveal current<Cr>', {noremap = true, silent = true})
require("neo-tree").setup {
    filesystem = {
        hijack_netrw_behavior = "open_current";
        window = {
            mappings = {
                ['t'] = function(state)
                    vim.cmd('tabnew ' .. state.tree:get_node():get_id())
                end;
                ['o'] = 'system_open';
            }
        };
        commands = {
            system_open = function(state)
                vim.api.nvim_command('silent !xdg-open ' .. state.tree:get_node():get_id())
            end;
        };
        bind_to_cwd = false;
    };
    event_handlers = {
        {
            event = 'file_open_requested';
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
            end;
        };
    };
}
vim.fn.sign_define("LspDiagnosticsSignError", {text = " ", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = " ", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = " ", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})
