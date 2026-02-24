local ck = require'caskey'

local augroup = vim.api.nvim_create_augroup('idan:shell_workflows', {})

local window_visit_counter = 0
local window_visit_order_varname = '-window-visit-order-'

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function()
        window_visit_counter = window_visit_counter + 1
        vim.api.nvim_win_set_var(0, window_visit_order_varname, window_visit_counter)
    end,
})

local function is_shell_like(win_id)
    local buf = vim.api.nvim_win_get_buf(win_id or 0)
    local buftype = vim.api.nvim_get_option_value('buftype', {buf = buf})
    return buftype == 'terminal' or buftype == 'prompt'
end

---@param should_be_shell boolean
local function last_accessed_window_of_type(should_be_shell)
    local latest_win = nil
    local max_order = nil
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= current_win and is_shell_like(win) == should_be_shell then
            local ok, order = pcall(vim.api.nvim_win_get_var, win, window_visit_order_varname)
            if not ok then
                order = 0
            end
            if max_order == nil or max_order < order then
                latest_win = win
                max_order = order
            end
        end
    end
    return latest_win
end

ck.setup {
    mode = {'n', 'v', 'i', 't'},
    ['<C-\\>'] = {
        ['<C-s>'] = { act = function()
            require'channelot'.create_window_for_terminal()
            vim.fn.jobstart({'nu'}, {term = true})
        end, desc = 'Start Terminal'},
        ['<C-e>'] = { act = function()
            if is_shell_like(0) then
                vim.cmd.startinsert()
                return
            end
            local last_win = last_accessed_window_of_type(true)
            if last_win == nil then
                return
            end                  
            vim.api.nvim_set_current_win(last_win)
            vim.cmd.startinsert()
        end, desc = 'Go to last shell'},
        ['<C-w>'] = { act = function()
            if not is_shell_like(0) then
                return
            end
            local last_win = last_accessed_window_of_type(false)
            if last_win == nil then
                return
            end
            vim.api.nvim_set_current_win(last_win)
        end, desc = 'Go to last non-shell'},
        ['<C-q>'] = { act = function()
            require'moonicipal.util'.defer_to_coroutine(function()
                require'moonicipal'.fix_echo()

                local bufs_to_chans = {}
                for _, chan in ipairs(vim.api.nvim_list_chans()) do
                    if chan.mode == 'terminal' then
                    -- if chan.stream == 'job' then
                        bufs_to_chans[chan.buffer] = chan
                    end
                end

                vim.iter(vim.api.nvim_tabpage_list_wins(0)):each(function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    local chan = bufs_to_chans[buf]
                    if chan == nil then
                        return
                    end
                    if chan.stream == 'job' then
                        if vim.fn.jobwait({chan.id}, 0)[1] == -1 then
                            return
                        end
                    else
                        -- TODO: support Channelot terminals
                        return
                    end
                    vim.api.nvim_buf_delete(buf, {force = true})
                end)
            end)
        end, desc = 'Close all finished terminals'},
        ['<C-r>'] = {mode = {'i', 't', 'c'}, act = function()
            local chosen_reg = vim.fn.getcharstr()
            if chosen_reg == '=' then
                vim.fn.setreg('=', vim.fn.input('='))
            end
            vim.api.nvim_feedkeys(vim.fn.getreg(chosen_reg), 'i', false)
        end, desc = 'Paste a register into the terminal'},
    },
}
