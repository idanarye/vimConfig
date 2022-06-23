local fzf = require'fzf-lua'
fzf.setup {
    previewers = {
        git_diff = {
            pager = "delta";
        };
        builtin = {
            extensions = {
                ["png"] = { "viu", "-b" };
            };
        };
    };
}

vim.keymap.set('n', '<C-p>', fzf.files)
vim.keymap.set('n', '<M-p><M-p>', fzf.builtin)
vim.keymap.set('n', '<M-p>l', fzf.blines)
vim.keymap.set('n', '<M-p>m', fzf.git_status)
vim.keymap.set('n', '<M-p><C-t>', fzf.btags)
vim.keymap.set('n', '<M-p>s', fzf.live_grep)
