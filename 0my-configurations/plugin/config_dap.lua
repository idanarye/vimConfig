local dap = require'dap'
local dapui = require'dapui'
local dap_view = require'dap-view'

local mason_core_path = require'mason-core.path'

dap.defaults.fallback.switchbuf = 'useopen,split'

dapui.setup({
    --sidebar = { open_on_start = false };
    --tray = { open_on_start = false };
})

dap_view.setup {
    winbar = {
        sections = { 'console', 'watches', 'exceptions', 'breakpoints', 'threads', 'repl' },
        default_section = 'repl',
        show = true,
    },
    windows = {
        terminal = {
            hide = {'python'},
            -- start_hidden = true,
        }
    }
}

vim.g.dap_virtual_text = true

require'dap-python'.setup(mason_core_path.package_prefix'debugpy/venv/bin/python')

dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
        command = mason_core_path.bin_prefix'codelldb';
        args = { '--port', '${port}' };
    },
}

dap.configurations.cpp = {
    {
        name = 'Launch';
        type = 'codelldb';
        request = 'launch';
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end;
        cwd = '${workspaceFolder}';
        stopOnEntry = false;
        args = {};

        runInTerminal = false;
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require'dap-kotlin'.setup {
    dap_command = mason_core_path.bin_prefix'kotlin-debug-adapter',
}

dap.adapters.nlua = function(callback, config)
    callback({
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or 8086,
    })
end

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
    }
}


vim.api.nvim_create_user_command('OneSmallStepForVimkindLaunchServer', function()
    require"osv".launch {
        port = 8086,
    }
end, {})

require'caskey'.setup {
    mode = {'n'},
    name = 'DAP',
    ['<M-d>'] = {
        ['u'] = {act = dapui.toggle, desc='Toggle DAP UI'},
        ['U'] = {act = dap.repl.toggle, desc='Toggle DAP REPL'},
        ['v'] = {act = dap_view.toggle, desc='Toggle DAP View'},

        ['c'] = {act = dap.continue, desc='DAP continue'},
        ['C'] = {act = dap.run_to_cursor, desc='DAP run to cursor'},
        ['Q'] = {act = dap.close, desc='DAP close'},
        ['b'] = {act = dap.toggle_breakpoint, desc='DAP toggle breakpoint'},
        ['<C-b>'] = {act = function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc='DAP add conditional breakpoint'},
        ['B'] = {act = dap.clear_breakpoints, desc='DAP clear all breakpoints'},

        ['o'] = {act = dap.step_over, desc='DAP step over'},
        ['i'] = {act = dap.step_into, desc='DAP step into'},
        ['O'] = {act = dap.step_out, desc='DAP step out'},

        ['k'] = {act = dap.up, desc='DAP go up in the current stacktrace without stepping'},
        ['j'] = {act = dap.down, desc='DAP go down in the current stacktrace without stepping'},
        ['f'] = {act = dap.focus_frame, desc='DAP jump to the current frame'},

        ['e'] = {act = dapui.eval, mode = {'n', 'v'}, desc='DAP eval'},
    },
}
