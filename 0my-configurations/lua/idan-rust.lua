local M = {}

function M.jq_cargo_metadata(query)
    local output = vim.fn.system('cargo metadata --no-deps --format-version=1 | jq ' .. vim.fn.shellescape(query))
    return vim.json.decode(output)
end

M.tasks = {
    run_cargo_fmt = function()
        vim.cmd'!cargo fmt'
    end,

    clippy = function()
        vim.cmd'Erun! cargo clippy -q'
    end,

    cargo_example = function(self)
        local cc = self:cached_choice {
            key = 'name',
            format = 'name',
        }
        for _, example in ipairs(M.jq_cargo_metadata'.packages[0].targets | map(select(.kind[] == "example"))') do
            cc(example)
        end
        return cc:select()
    end,
}

return M
