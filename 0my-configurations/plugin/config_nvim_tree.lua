vim.api.nvim_set_keymap('n', '<Leader><Tab>', ':NvimTreeToggle<Cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader><Tab>', ':NvimTreeFindFile<Cr>', {noremap = true, silent = true})

require'nvim-tree'.setup {
    diagnostics = {
        enable = true;
    };

    filters = {
        dotfiles = true;
        custom = {};
    };

    git = {
        ignore = true;
    };
}

-- These settings are here for now until the author of nvim-tree moves them to the setup function:
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1

vim.g.nvim_tree_window_picker_exclude = {
    filetype = {
        'packer',
        'qf'
    };
    buftype = {
        'terminal'
    };
}
