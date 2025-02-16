require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        'bash',
        -- 'd', -- don't install it, it makes Neovim and sometimes the machine itself freeze on certain files
        'json',
        'json5',
        -- 'kotlin',
        -- 'lua',
        -- 'markdown',
        -- 'markdown_inline',
        -- 'norg',
        'python',
        'query',
        'rust',
        'toml',
        'yaml',
        'nu',
    };
    highlight = {
        enable = true,
    };
    incremental_selection = { enable = true };
    textobjects = { enable = true };
    indent = {
        enable = true,
        disable = { 'rust', 'lua', 'nu', }, -- I only want this for Python
    },
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
