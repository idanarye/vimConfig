vim.api.nvim_create_user_command('DBUISetDbConnection', function()
    require'moonicipal.util'.defer_to_coroutine(function()
        local chosen = require'moonicipal'.select(vim.fn['db_ui#connections_list'](), {
            format = function(con)
                return con.name
            end,
        })
        if chosen then
            vim.b.db = chosen.url
        end
    end)
end, {})

-- local ck = require'caskey'

-- ck.setup {
    -- name = 'dadbod',
    -- ['<M-s>'] = {
        -- mode = {'n', 'i', 'v'},
        -- ['<M-s>'] = { act = ck.cmd('.DB'), { desc = 'Run the entire file as query' }}
    -- }
-- }
