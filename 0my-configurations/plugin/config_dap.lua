local dap = require'dap'

require'dapui'.setup({
    sidebar = { open_on_start = false };
    tray = { open_on_start = false };
})

vim.g.dap_virtual_text = true

dap.adapters.python = {
    type = 'executable';
    command = '/usr/bin/python';
    args = { '-m', 'debugpy.adapter' };
}

dap.adapters.lldb = {
    type = 'executable';
    command = '/usr/bin/lldb-vscode';
}

dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = 'Launch file';

        program = "${file}";
        paythonPath = function()
            --local cwd = vim.fn.getcwd()
            --if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                --return cwd .. '/venv/bin/python'
            --elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                --return cwd .. '/.venv/bin/python'
            --else
                return '/usr/bin/python'
            --end
        end;
    },
}

dap.configurations.cpp = {
    {
        name = 'Launch';
        type = 'lldb';
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
