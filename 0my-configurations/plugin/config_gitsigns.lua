local gs = require'gitsigns.actions'
local ck = require'caskey'

require'gitsigns'.setup {
    on_attach = function (bufnr)
        ck.emit("Gitsigns", bufnr)
    end,
}

ck.setup {
    mode = 'n',
    name = 'Gitsigns',
    when = ck.emitted'Gitsigns',

    -- TODO: do I need these two?
    -- ['n ]g'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    -- ['n [g'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['<leader>hs'] = { act = gs.stage_hunk, desc = 'stage hunk' },
    ['<leader>hu'] = { act = gs.undo_stage_hunk, desc = 'undo stage hunk' },
    ['<leader>hr'] = { act = gs.reset_hunk, desc = 'reset hunk' },

    ['<leader>hR'] = { act = gs.reset_buffer, desc = 'reset buffer' },
    ['<leader>hp'] = { act = gs.preview_hunk, desc = 'preview hunk' },
    ['<leader>hb'] = { act = function() gs.blame_line(true) end, desc = 'blame line' },
}

ck.setup {
    mode = 'v',
    name = 'Gitsigns',
    when = ck.emitted'Gitsigns',

    ['<leader>hs'] = { act = function()
        gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')})
    end, desc = 'stage hunk' },

    ['<leader>hr'] = { act = function()
        gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')})
    end, desc = 'reset hunk' },
}

-- Text objects
ck.setup {
    mode = {'o', 'x'},
    name = 'Gitsigns',
    when = ck.emitted'Gitsigns',
    ['ih'] = { act = gs.select_hunk, desc = 'select hunk' },
}
