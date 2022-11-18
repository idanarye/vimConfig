local M = {}

function M.unload_package(pattern)
    local reg = vim.regex(pattern)
    for name in pairs(package.loaded) do
        if reg:match_str(name) then
            package.loaded[name] = false
        end
    end
end

return M
