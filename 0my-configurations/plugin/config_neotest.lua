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

require'caskey'.setup {
    mode = {'n'},
    name = 'neotest',
    ['<Leader>t'] = {
        ['t'] = { act = neotest.run.run, desc = 'Run test' },
        ['T'] = { act = function()
            neotest.run.run(vim.fn.expand("%"))
        end, desc = 'Run tests file'},
        ['<C-t>'] = { act = function()
            neotest.run.run_last()
        end, desc = 'Rerun last test'},
        ['o'] = { act = neotest.output.open, desc = 'Open Neotest output popup' },
        ['p'] = { act = neotest.output_panel.toggle, desc = 'Toggle Neotest panel' },
        ['d'] = { act = function()
            neotest.run.run{strategy = 'dap'}
        end, desc = 'Run test in debug mode'},
        ['D'] = { act = function()
            neotest.run.run{vim.fn.expand('%'), strategy = 'dap'}
        end, desc = 'Run tests file in debug mode'},
        ['<C-d>'] = { act = function()
            neotest.run.run{strategy = 'dap'}
        end, desc = 'Rerun last test in debug mode'},
        ['k'] = { act = neotest.run.stop, desc = 'Stop Neotest' },
        ['s'] = { act = neotest.summary.toggle, desc = 'Toggle Neotest summary' },
    },
}
