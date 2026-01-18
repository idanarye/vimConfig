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

ck.setup {
    mode = {'n'},
    ['<Leader>j'] = {
        ['j'] = {act = ck.cmd'JJ', desc = 'Run JJ (Jujutsu)'},
    },
}
