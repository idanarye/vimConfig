require'nvim-treesitter.configs'.setup {
    ensure_installed = { "norg" };
    highlight = { enable = true };
    incremental_selection = { enable = true };
    textobjects = { enable = true };
    --indent = {
        --enable = true,
        --disable = { 'rust' }, -- I only want this for Python
    --},
    playground = {
        enable = true;
        persist_queries = false;
    };
    query_linter = {
        enable = true;
        use_virtual_text = true;
        lint_events = {'BufWrite', 'CursorHold'};
    };
}
