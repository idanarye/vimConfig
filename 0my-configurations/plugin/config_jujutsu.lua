require'lazyjj'.setup {
    mapping = '<Leader><C-j>'  -- NOTE: This is the default
}

---@param revset string
---@param name? string
local function revset_preset(revset, desc)
    return {
        cmd = function()
            require'jujutsu-nvim'.set_custom_revset(revset)
        end,
        desc = 'Revset preset: ' .. (desc or revset)
    }
end

require'jujutsu-nvim'.setup {
    diff_preset = 'diffview',  -- NOTE: default is difftastic but I don't have it installed
    keymap = {
        --['1'] = { cmd = 'set_revset b()', desc = 'erv' },
        ['`'] = revset_preset('', 'Clear'),
        ['1'] = revset_preset('b()'),
        ['2'] = revset_preset('remote_bookmarks()'),
    },
}

local ck = require'caskey'

---@param cmd string
local function jj_si(cmd)
    return {
        act = function()
            vim.cmd.JJ(cmd)
            vim.cmd.startinsert()
        end,
        desc = 'JJ ' .. cmd,
    }
end

ck.setup {
    mode = {'n'},
    ['<Leader>j'] = {
        ['j'] = {act = ck.cmd'JJ', desc = 'Run JJ (Jujutsu)'},
        ['f'] = jj_si('git fetch'),
    },
}

vim.api.nvim_create_user_command("JJCreateRemoteBookmark", function()
    require'moonicipal.util'.defer_to_coroutine(function()
        local channelot = require'channelot'
        local tracked_bookmarks = {}
        for _, line in channelot.job{'jj', 'bookmark', 'list', '--tracked', '-T', [=[name ++ "\n"]=]}:iter{stdout = 'buffered', stderr = 'ignore'} do
            tracked_bookmarks[line] = true
        end
        local untracked_bookmarks = {}
        for _, line in channelot.job{'jj', 'bookmark', 'list', '-T', [=[name ++ "\n"]=]}:iter{stdout = 'buffered', stderr = 'ignore'} do
            if not tracked_bookmarks[line] then
                table.insert(untracked_bookmarks, line)
            end
        end

        local chosen_bookmark = require'moonicipal'.select(untracked_bookmarks)
        if not chosen_bookmark then
            return
        end
        require'channelot'.windowed_terminal_job{'jj', 'bookmark', 'track', chosen_bookmark, '--remote=origin'}:wait()
    end)
end, {})
