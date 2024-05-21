local impairative = require'impairative'

impairative.toggling {
    -- Use capital O for now to avoid conflicts
    enable = '[O',
    disable = ']O',
    toggle = 'yO',
}
:field {
    key = 'b',
    table = vim.o,
    field = 'background',
    values = { [true] = 'light', [false] = 'dark' }
}
:field {
    key = 'c',
    table = vim.o,
    field = 'cursorline',
}
:getter_setter {
    key = 'd',
    get = function()
        return vim.o.diff
    end,
    set = function(value)
        if value then
            vim.cmd.diffthis()
        else
            vim.cmd.diffoff()
        end
    end,
}
:field {
    key = 'h',
    table = vim.o,
    field = 'hlsearch',
}
:field {
    key = 'i',
    table = vim.o,
    field = 'ignorecase',
}
:field {
    key = 'l',
    table = vim.o,
    field = 'list',
}
:field {
    key = 'n',
    table = vim.o,
    field = 'number',
}
:field {
    key = 'r',
    table = vim.o,
    field = 'relativenumber',
}
:field {
    key = 's',
    table = vim.o,
    field = 'spell',
}
:field {
    key = 't',
    table = vim.o,
    field = 'colorcolumn',
    values = { [true] = '+1', [false] = '' }
}
:field {
    key = 'u',
    table = vim.o,
    field = 'cursorcolumn',
}
:field {
    key = 'v',
    table = vim.o,
    field = 'virtualedit',
    values = { [true] = 'all', [false] = '' }
}
:field {
    key = 'w',
    table = vim.o,
    field = 'wrap',
}
:getter_setter {
    key = 'x',
    get = function()
        return vim.o.cursorline and vim.o.cursorcolumn
    end,
    set = function(value)
        vim.o.cursorline = value
        vim.o.cursorcolumn = value
    end
}
