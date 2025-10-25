local fzf = require'fzf-lua'
fzf.setup {
    winopts = {
        --split = 'belowright new',
        --split = 'botright new',
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
        ['m'] = {act = function()
            local show_prefix_result = vim.system{'git', 'rev-parse', '--show-prefix'}:wait()
            if show_prefix_result.code ~= 0 then
                vim.notify(show_prefix_result.stderr, vim.log.levels.ERROR)
                return
            end
            local dir_prefix = show_prefix_result.stdout
            if vim.endswith(dir_prefix, '\n') then
                dir_prefix = dir_prefix:sub(1, -2)
            end
            local commit = nil
            local selecting_commit = false

            local actions = {}
            local file_opts = {
                query = '',
                actions = actions,
                fzf_opts = {
                    ['--multi'] = true,
                },
                fzf_cli_args = '',
            }
            local commit_opts = {
                query = '',
                actions = actions,
                fzf_opts = {
                    ['--multi'] = false,
                    ['--with-nth'] = '2..',
                    ['--nth'] = '2..',
                },
                fzf_cli_args = '--bind "load:pos(1)"',
            }

            actions['ctrl-g'] = {fn = function(selected, opts)
                if selecting_commit then
                    commit_opts.query = opts.last_query
                    local pos
                    pos, commit = selected[1]:match'^(%d+)\t(%w+) '
                    commit_opts.fzf_cli_args = ('--bind "load:pos(%s)"'):format(pos)
                    selecting_commit = false
                    fzf.core.fzf_resume(file_opts)
                else
                    file_opts.query = opts.last_query
                    selecting_commit = true
                    fzf.core.fzf_resume(commit_opts)
                end
            end, reload = true }

            local process_selected = function(selected)
                return vim.iter(selected):map(function(entry)
                    if commit then
                        return entry:match'^.\t(.*)$'
                    else
                        return entry:match'^...(.*)$'
                    end
                end):map(function(path)
                    return vim.fs.relpath(dir_prefix, path)
                end):totable()
            end

            actions['default'] = function(selected, opts)
                if selecting_commit then
                    actions['ctrl-g'].fn(selected, opts)
                else
                    fzf.actions.file_edit_or_qf(process_selected(selected), opts)
                end
            end

            for action_bind, action_function in pairs {
                ["ctrl-s"] = 'file_split',
                ["ctrl-v"] = 'file_vsplit',
                ["ctrl-t"] = 'file_tabedit',
                ["alt-q"]  = 'file_sel_to_qf',
                ["alt-Q"]  = 'file_sel_to_ll',
            }
            do
                actions[action_bind] = function(selected, opts)
                    if selecting_commit then
                        fzf.core.fzf_resume()
                    else
                        return fzf.actions[action_function](process_selected(selected), opts)
                    end
                end
            end

            fzf.fzf_exec(function(cb)
                require'moonicipal.util'.defer_to_coroutine(function()
                    if selecting_commit then
                        local pos = 1
                        cb(pos .. '\t<WORKTREE>')
                        for _, line in require'channelot'.job{'git', 'log', '--oneline'}:iter() do
                            pos = pos + 1
                            cb(pos .. '\t' .. line)
                        end
                    else
                        local cmd
                        if commit then
                            cmd = {'git', 'show', commit, '--format=', '--name-status', '--'}
                        else
                            cmd = {'git', 'status', '--porcelain=v1'}
                        end
                        for _, line in require'channelot'.job(cmd):iter() do
                            cb(line)
                        end
                    end
                    cb()
                end)
            end, file_opts)
        end, desc='fzf-lua git files'},
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
                    default = fzf.actions.file_edit,
                },
                fzf_opts = {
                    ['--no-multi'] = '',
                }
            })
        end, desc='fzf-lua choose background buffer with unsaved data'},
        ['f'] = {act = fzf.filetypes, desc='fzf-lua file types'},
    }
}
