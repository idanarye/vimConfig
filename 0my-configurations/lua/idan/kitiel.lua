---@class kitiel.Connection
---@field socket string
local KitielConnection = {}
KitielConnection.__index = KitielConnection

---@return kitiel.Connection
function KitielConnection.new(socket)
    return setmetatable({
        socket = socket,
    }, KitielConnection)
end

---@return kitiel.Terminal
function KitielConnection:moonicipal_cache(task)
    local cc = task:cached_choice {
        key = 'id',
        format = 'title',
        select_1 = true,
    }
    for _, terminal in ipairs(self:terminals()) do
        cc(terminal)
    end
    return cc:select()
end

---@param args string[]
---@return string[]
function KitielConnection:_format_kitten_cmd(args)
    return {'kitten', '@', '--to', 'unix:' .. self.socket, unpack(args)}
end

---@param args string[]
---@return vim.SystemCompleted
function KitielConnection:run_kitten(args)
    return vim.system(self:_format_kitten_cmd(args)):wait()
end

function KitielConnection:ls()
    local ls_result = self:run_kitten{'ls'}
    if ls_result.code ~= 0 then
        error(ls_result.stderr)
    end
    return vim.json.decode(ls_result.stdout)
end

---@class kitiel.Terminal
---@field id integer
---@field parent kitiel.Connection
---@field cmdline string
---@field foreground_processes [{cmdline: string[], cmd: string, pid: integer}]
---@field title string
local KitielTerminal = {}
KitielTerminal.__index = KitielTerminal

---@return kitiel.Terminal[]
function KitielConnection:terminals()
    return vim.iter(coroutine.wrap(function()
        for _, instance in ipairs(self:ls()) do
            for _, tab in ipairs(instance.tabs) do
                for _, window in ipairs(tab.windows) do
                    coroutine.yield(setmetatable({
                        parent = self,
                        id = window.id,
                        cmdline = window.cmdline,
                        foreground_processes = window.foreground_processes,
                        title = window.title,
                    }, KitielTerminal))
                end
            end
        end
    end)):totable()
end

function KitielTerminal:get_normalized_foreground_process()
    return vim.fs.basename(self.foreground_processes[#self.foreground_processes].cmdline[1])
end

---@return string
function KitielTerminal:_match_expr()
    return 'id:' .. self.id
end

---@param text string|string[]
function KitielTerminal:send_text(text)
    vim.validate {
        text = {text, {'string', 'table'}},
    }
    vim.system(self.parent:_format_kitten_cmd{
        'send-text',
        '--match', self:_match_expr(),
        '--stdin',
    }, {
        stdin = text,
    })
end

---@param text string|string[]
function KitielTerminal:send_text_backeted_paste(text)
    vim.validate {
        text = {text, {'string', 'table'}},
    }
    vim.system(self.parent:_format_kitten_cmd{
        'send-text',
        '--match', self:_match_expr(),
        '--stdin',
        '--bracketed-paste', 'enable',
    }, {
        stdin = text,
    })
end

---@return string
function KitielTerminal:get_last_command_text()
    return self.parent:run_kitten{'get-text', '--match', self:_match_expr(), '--extent', 'last_cmd_output'}.stdout
end

---@param command_as_text string
---@overload fun(): string
function KitielTerminal:__call(command_as_text)
    if command_as_text == nil then
        return self:get_last_command_text()
    end

    local normalized_foreground_process = self:get_normalized_foreground_process()
    if normalized_foreground_process == 'nu' then
        local text_lines = vim.split(command_as_text, '\n')
        text_lines[1] = '\05 \21' .. text_lines[1]
        if self:get_normalized_foreground_process() == 'nu' then
            for i, line in ipairs(text_lines) do
                text_lines[i] = line .. '\r'
            end
        end
        self:send_text(text_lines)
    elseif normalized_foreground_process == 'python' or normalized_foreground_process == 'python3' then
        self:send_text('\x15')
        self:send_text_backeted_paste(command_as_text)
        self:send_text('\x1b\r')
    else
        self:send_text(command_as_text)
    end
end

function KitielTerminal:focus()
    self.parent:run_kitten{'focus-window', '--match', self:_match_expr(), '--no-response'}
end

---@param new_title string
function KitielTerminal:set_title(new_title)
    self.parent:run_kitten{'set-window-title', '--match', self:_match_expr(), new_title}
end

function KitielTerminal:interactive_set_title()
    vim.ui.input({
        prompt = 'Title: ',
        default = self.title,
    }, function(new_title)
        if new_title ~= nil then
            self:set_title(new_title)
        end
    end)
end

return KitielConnection
