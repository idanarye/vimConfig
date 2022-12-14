local neotest = require'neotest'

neotest.setup {
    adapters = {
        require'neotest-plenary',
        require'neotest-python',
        require'neotest-rust' {
            args = { "--no-capture" },
        },
    };
}

local function bind_key(key, dlg)
    vim.keymap.set('n', '<Leader>t' .. key, dlg)
end

bind_key('t', neotest.run.run)
bind_key('T', function()
    neotest.run.run(vim.fn.expand("%"))
end)
bind_key('<C-t>', function()
    neotest.run.run_last()
end)
bind_key('o', neotest.output.open)
bind_key('p', neotest.output_panel.toggle)

bind_key('d', function()
    neotest.run.run{strategy = 'dap'}
end)
bind_key('D', function()
    neotest.run.run{vim.fn.expand('%'), strategy = 'dap'}
end)
bind_key('<C-d>', function()
    neotest.run.run_last{strategy = 'dap'}
end)

bind_key('k', neotest.run.stop)
bind_key('s', neotest.summary.toggle)
