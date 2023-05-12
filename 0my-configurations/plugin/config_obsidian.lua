require'obsidian'.setup {
    dir = vim.fn.stdpath('data') .. '/obsidian.nvim',
    finder = 'fzf-lua'
}

require'caskey'.setup {
    mode = {'n'},
    name = 'obsidian.nvim',
    ['<M-w>'] = {
        -- [] = { act = require'caskey'.cmd'ObsidianBacklinks', },
        -- [] = { act = require'caskey'.cmd'ObsidianToday', },
        -- [] = { act = require'caskey'.cmd'ObsidianYesterday', },
        -- [] = { act = require'caskey'.cmd'ObsidianOpen', },
        ['n'] = { act = require'caskey'.cmd'ObsidianNew', },
        ['s'] = { act = require'caskey'.cmd'ObsidianSearch', },
        ['q'] = { act = require'caskey'.cmd'ObsidianQuickSwitch', },
        -- [] = { act = require'caskey'.cmd'ObsidianLink', },
        -- [] = { act = require'caskey'.cmd'ObsidianLinkNew', },
        -- [] = { act = require'caskey'.cmd'ObsidianFollowLink', },
        -- [] = { act = require'caskey'.cmd'ObsidianTemplate', },
    },
}

