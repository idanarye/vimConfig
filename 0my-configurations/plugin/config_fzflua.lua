local fzf = require'fzf-lua'
fzf.setup {
    winopts = {
        split = 'belowright new';
    };
    keymap = {
        fzf = {
            ["ctrl-z"] = "abort";
            ["ctrl-u"] = "unix-line-discard";
            --["ctrl-d"] = "half-page-down";
            --["ctrl-u"] = "half-page-up";
            --["ctrl-a"] = "beginning-of-line";
            --["ctrl-e"] = "end-of-line";
            ["alt-a"] = "toggle-all";
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap";
            ["f4"] = "toggle-preview";
            ["shift-down"] = "preview-page-down";
            ["shift-up"] = "preview-page-up";
        };
    };
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
vim.keymap.set('n', '<M-p>s', fzf.live_grep)
