-- vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete() . "\\<C-n>"', {expr = true, noremap = true, silent = true})
-- vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', {expr = true, noremap = true, silent = true})


local on_attach = function(client)
    require'completion'.on_attach(client)
end

vim.api.nvim_set_keymap('i', '<C-Space>', '<Plug>(completion_smart_tab)', {})
vim.o.completeopt = 'menuone'
vim.api.nvim_set_var('completion_enable_auto_popup', 0)
-- vim.api.nvim_set_var('completion_enable_snippet', vim)
-- vim.api.nvim_set_var('completion_confirm_key', "<C-l>")

-- vim.api.nvim_set_var(
-- let g:completion_enable_auto_popup = 0
-- let g:completion_enable_snippet = 'vim-vsnip'


-- vim.o.completeopt = 'menuone,noselect'
-- require'compe'.setup {
    -- enabled = true;
    -- autocomplete = false;
    -- -- debug = false;
    -- -- min_length = 1;
    -- preselect = 'enable';
    -- -- preselect = 'always';
    -- -- throttle_time = 80;
    -- -- source_timeout = 200;
    -- -- resolve_timeout = 800;
    -- -- incomplete_delay = 400;
    -- -- max_abbr_width = 100;
    -- -- max_kind_width = 100;
    -- -- max_menu_width = 100;
    -- -- documentation = {
        -- -- border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
        -- -- winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        -- -- max_width = 120,
        -- -- min_width = 60,
        -- -- max_height = math.floor(vim.o.lines * 0.3),
        -- -- min_height = 1,
    -- -- };

    -- source = {
        -- path = true;
        -- buffer = true;
        -- calc = true;
        -- nvim_lsp = true;
        -- nvim_lua = true;
        -- vsnip = true;
        -- ultisnips = true;
        -- luasnip = true;
    -- };
-- }
