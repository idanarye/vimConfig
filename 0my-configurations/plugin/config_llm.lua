require'claudecode'.setup {
}

local ck = require'caskey'
ck.setup {
    mode = {'n', 'v'},
    name = 'LLM',
    ['<M-a>'] = {
        ['t'] = {
            act = ck.cmd'ClaudeCode',
        },
        ['<M-a>'] = {
            act = ck.cmd'ClaudeCodeFocus',
        },
        ['s'] = {
            mode = {'v'},
            act = ck.cmd'ClaudeCodeSend',
        },
        ['d'] = {
            act = ck.cmd'ClaudeCodeDiffAccept',
        },
        ['D'] = {
            act = ck.cmd'ClaudeCodeDiffDeny',
        },
    },
}
