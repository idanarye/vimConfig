local ts = require'nvim-treesitter'

ts.setup {
}

---@class (exact) _TreeSitterSpecificLanguageConfiguration
---@field indent? boolean

---@type table<string, _TreeSitterSpecificLanguageConfiguration>
local langs = {
    ['bash'] = {},
    -- 'd', -- don't install it, it makes Neovim and sometimes the machine itself freeze on certain files
    ['json'] = {},
    ['json5'] = {},
    -- 'kotlin',
    -- ['lua'] = { indent = false },
    -- 'markdown',
    -- 'markdown_inline',
    -- 'norg',
    ['python'] = {},
    ['query'] = {},
    ['rust'] = {
        indent = false,
    },
    ['toml'] = {},
    ['yaml'] = {},
    ['nu'] = {},
}

ts.install(vim.tbl_keys(langs))

---@generic T
---@param field? T
---@param default T
---@return T
local function with_default(field, default)
    if field == nil then
        return default
    else
        return field
    end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(langs),
    callback = function(event)
        local cfg = langs[event.match]
        if not cfg then
            return
        end
        vim.treesitter.start()
        if with_default(cfg.indent, true) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- Old setup
local _ = {
    highlight = {
        enable = true,
    };
    incremental_selection = { enable = true };
    textobjects = { enable = true };
    indent = {
        enable = true,
        disable = { 'rust', 'lua', }, -- I only want this for Python and Nushell
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
