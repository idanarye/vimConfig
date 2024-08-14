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
                        title = window.title,
                    }, KitielTerminal))
                end
            end
        end
    end)):totable()
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
    local text_lines = vim.split(command_as_text, '\n')
    text_lines[1] = '\05 \21' .. text_lines[1]
    self:send_text(text_lines)
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
