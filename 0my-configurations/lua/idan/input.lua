local M = {}

---@class IdanCachedBashCommandTaskOpts
---@field default string
---@field must_enter? string
---@field prep fun(ls: BufflsForBash)
---@field map_result? fun(command: string): string

---@param opts IdanCachedBashCommandTaskOpts
function M.cached_bash_command_task(opts)
    return function(self)
        local result = self:cached_data_cell {
            default = opts.default,
            buf = function()
                vim.cmd.setfiletype('bash')
                local ls = require'buffls.ForBash':for_buffer()
                ---@cast ls BufflsForBash
                ls:add_action('Restore default command', function()
                    vim.api.nvim_buf_set_lines(0, 0, -1, true, {opts.default})
                end)
                opts.prep(ls)
            end,
        }
        if self:is_main() then
            return
        end
        if not result then
            if opts.must_enter then
                require'moonicipal'.abort(opts.must_enter)
            else
                result = opts.default
            end
        end
        if opts.map_result then
            result = opts.map_result(result)
        end
        return result
    end
end

return M
