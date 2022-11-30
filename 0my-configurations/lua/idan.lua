local M = {}

function M.unload_package(pattern)
    local reg = vim.regex(pattern)
    for name in pairs(package.loaded) do
        if reg:match_str(name) then
            package.loaded[name] = false
        end
    end
end

function M.run_block_in_ipython(job, block)
    job:write'\21'
    local rows = vim.split(block, '\n')
    for i, row in ipairs(rows) do
        if rows[i + 1] then
            job:write('\x01' .. row .. '\x0f\x0e')
        else -- last row
            job:write('\x01' .. row .. '\x1b\r')
        end
    end
end

function M.generate_docs(cmd)
    vim.cmd'botright vnew'
    local j = require'channelot'.terminal_job(cmd or 'make -s docs')
    vim.cmd.setfiletype('help')
    vim.keymap.set('n', 'q', vim.cmd.quit, {buffer = true})
    j:wait()
    vim.cmd.checktime()
end

return M
