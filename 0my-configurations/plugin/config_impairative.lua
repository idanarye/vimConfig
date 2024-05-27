require'impairative.replicate-unimpaired'()

local impairative = require'impairative'

impairative.toggling {
    disable = ']o',
    enable = '[o',
    toggle = 'yo',
}
:option {
    key = 'e',
    option = 'conceallevel',
    values = {[true] = 2, [false] = 0},
}
:getter_setter {
    key = 'i',
    name = 'inlay hints',
    get = vim.lsp.inlay_hint.is_enabled,
    set = vim.lsp.inlay_hint.enable,
}

impairative.operations {
    backward = '[',
    forward = ']',
}
:jump_in_buf {
    key = 'g',
    desc = 'jump to the {previous|next} git diff',
    fun = function()
        local res = vim.system({'git', 'diff', '--unified=0', '--', vim.fn.expand('%')}, {
            text = true
        }):wait()
        if res.code ~= 0 then
            return vim.iter({})
        end
        local pattern = vim.re.compile[=[
        "@@"
        " "+
        "-" [0-9]+ ("," [0-9]+)?
        " "+
        "+" {[0-9]+} ("," {[0-9]+})?
        " "+
        "@@"
        ]=]
        return vim.iter(vim.gsplit(res.stdout, '\n', {plain = true})):map(function(line)
            local line_nr, line_count = pattern:match(line)
            if line_nr then
                local start_line = tonumber(line_nr)
                local end_line
                if line_count then
                    end_line = start_line + math.max(1, tonumber(line_count)) - 1
                else
                    end_line = start_line
                end
                return {
                    start_line = start_line,
                    start_col = 0,
                    end_line = end_line,
                    end_col = #(vim.api.nvim_buf_get_lines(0, end_line - 1, end_line - 0, true)[1]) + 1
                }
            end
        end)
    end,
}
