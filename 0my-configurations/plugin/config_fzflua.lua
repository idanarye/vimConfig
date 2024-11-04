local fzf = require'fzf-lua'
fzf.setup {
    winopts = {
        split = 'belowright new',
    },
    keymap = {
        fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            --["ctrl-d"] = "half-page-down",
            --["ctrl-u"] = "half-page-up",
            --["ctrl-a"] = "beginning-of-line",
            --["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
        },
    },
    defaults = {
        multiline = 1,
    },
    previewers = {
        git_diff = {
            pager = "delta",
        },
        builtin = {
            extensions = {
                ["png"] = { "viu", "-b" },
            },
        },
    },
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
        ['s'] = {act = function()
            fzf.live_grep {
                silent = true,
            }
        end, desc = 'fzf-lua live grep'},
        ['<M-s>'] = {act = function()
            local input = vim.fn.input('rg> ')
            if input then
                fzf.grep {
                    search = input,
                    no_esc = true,
                    silent = true,
                }
            end
        end, desc='fzf-lua grep (prompt pattern)'},
        ['S'] = {act = function()
            fzf.grep {
                search = '\\b' .. vim.fn.expand('<cword>') .. '\\b',
                no_esc = true,
                silent = true,
            }
        end, desc='fzf-lua grep (word under cursor)'},
        ['u'] = {act = function()
            local buffers_loaded_in_this_tab = {}
            for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                buffers_loaded_in_this_tab[vim.api.nvim_win_get_buf(winid)] = true
            end
            local relevant_buffers = vim.iter(vim.api.nvim_list_bufs())
            :map(function(bufnr)
                if buffers_loaded_in_this_tab[bufnr] then
                    return
                end
                if not vim.api.nvim_get_option_value('modified', {buf = bufnr}) then
                    return
                end
                return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.')
            end):totable()
            if next(relevant_buffers) == nil then
                return
            end
            fzf.fzf_exec(relevant_buffers, {
                actions = {
                    default = require'fzf-lua.actions'.file_edit,
                },
                fzf_opts = {
                    ['--no-multi'] = '',
                }
            })
        end, desc='fzf-lua choose background buffer with unsaved data'},
        ['f'] = {act = fzf.filetypes, desc='fzf-lua file types'},
    }
}
