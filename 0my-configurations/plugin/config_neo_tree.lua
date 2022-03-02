vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':NeoTreeFocusToggle<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader><Tab>', ':NeoTreeReveal<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>d', ':NeoTreeRevealInSplit<Cr>', {noremap = true, silent = true})
require("neo-tree").setup {
    filesystem = {
        hijack_netrw_behavior = "open_split";
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
                local path = args.path
                local open_cmd = args.open_cmd or "edit"
                require'nvim-tree.actions.open-file'.fn(open_cmd, path)
            end;
        };
    };
}
vim.fn.sign_define("LspDiagnosticsSignError", {text = " ", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = " ", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = " ", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "LspDiagnosticsSignHint"})
