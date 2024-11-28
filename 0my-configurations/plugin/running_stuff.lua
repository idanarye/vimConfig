local ck = require'caskey'

local COMMANDS = {
    ['a'] = 'act',
    ['B'] = 'bump',
    ['b'] = 'build',
    ['C'] = 'clean',
    ['c'] = 'check',
    ['<C-c>'] = 'configure',
    ['<M-c>'] = 'command',
    ['d'] = 'debug',
    ['D'] = 'dump',
    ['<C-d>'] = 'doc',
    ['e'] = 'execute',
    ['E'] = 'explore',
    ['<C-e>'] = 'engage',
    ['<M-d>'] = 'deploy',
    ['f'] = 'fetch',
    ['F'] = 'fix',
    ['<C-f>'] = 'find',
    ['G'] = 'generate',
    ['g'] = 'go',
    ['h'] = 'help',
    ['i'] = 'install',
    ['I'] = 'init',
    ['k'] = 'kill',
    ['l'] = 'load',
    ['L'] = 'launch',
    ['<C-l>'] = 'log',
    ['m'] = 'migrate',
    ['p'] = 'prompt',
    ['q'] = 'query',
    ['R'] = 'refresh',
    ['r'] = 'run',
    ['<C-r>'] = 'reset',
    ['s'] = 'shell',
    ['<C-s>'] = 'ssh',
    ['S'] = 'sync',
    ['t'] = 'test',
    ['<C-t>'] = 'build_tests',
    ['<M-t>'] = 'test_debugger',
    ['T'] = 'tags',
    ['u'] = 'upload',
    ['U'] = 'update',
    ['v'] = 'view',
    ['w'] = 'wipe',
    ['W'] = 'wipe_all',
    ['z'] = 'zip',
}

for digit = 0, 9 do
    local digit_as_str = tostring(digit)
    COMMANDS[digit_as_str] = ':' .. digit_as_str
end

for _, cfg in ipairs {
    {name = "Moonicipal", leader = "<M-i>", command = "MC"},
     {name = "Omnipytent", leader = "<M-o>", command = "OP"},
}
do
    local mappings = {}
    for _, key in ipairs{'', cfg.leader} do
        mappings[key] = {
            mode = {'n'},
            desc = ('Select %s command'):format(cfg.name),
            act = function()
                vim.cmd[cfg.command]()
            end,
        }
    end
    mappings[' '] = {
        mode = {'n'},
        desc = ('Start command mode to enter %s command'):format(cfg.name),
        act = function()
            vim.api.nvim_feedkeys((':%s '):format(cfg.command), 'n', false)
        end,
    }

    for key, task in pairs(COMMANDS) do
        mappings[key] = {
            desc = ('Run %s task %s'):format(cfg.name, task),
            act = function()
                vim.cmd[cfg.command](task)
            end,
        }
    end
    ck.setup {
        mode = {'n', 'i'},
        name = cfg.name,
        [cfg.leader] = mappings,
    }
end
