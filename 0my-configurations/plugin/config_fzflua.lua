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

fzf.register_ui_select()

require'caskey'.setup {
    mode = {'n'},
    name = 'fzf-lua',
    ['<C-p>'] = {act = fzf.files, desc='fzf-lua files'},
    ['<M-p>'] = {
        ['<M-p>'] = {act = fzf.builtin, desc='fzf-lua builtins'},
        ['l'] = {act = fzf.blines, desc='fzf-lua lines in buffer'},
        ['m'] = {act = fzf.git_status, desc='fzf-lua git files'},
        ['s'] = {act = fzf.live_grep, desc = 'fzf-lua live grep'},
        ['<M-s>'] = {act = function()
            local input = vim.fn.input('rg> ')
            if input then
                fzf.grep {
                    search = input;
                    no_esc = true;
                }
            end
        end, desc='fzf-lua grep (prompt pattern)'},
        ['S'] = {act = function()
            fzf.grep {
                search = '\\b' .. vim.fn.expand('<cword>') .. '\\b';
                no_esc = true;
            }
        end, desc='fzf-lua grep (word under cursor)'},
    }
}
