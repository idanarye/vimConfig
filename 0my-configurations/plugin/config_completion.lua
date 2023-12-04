local cmp = require'cmp'

local run_if_visible = function(dlg)
    return function(fallback)
        if next(cmp.core.view.custom_entries_view.entries) ~= nil then
            return dlg()
        else
            fallback()
        end
    end
end

cmp.setup {
    snippet = {
        expand = function(args)
            pcall(require'luasnip'.lsp_expand, args.body)
        end
    },
    completion = {
        autocomplete = false;
        completeopt = 'menu,menuone,noselect';
    },

    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = run_if_visible(cmp.select_next_item);
        ['<C-p>'] = run_if_visible(cmp.select_prev_item);
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' };
        { name = 'calc' },
        { name = 'crates' },
        --{ name = 'luasnip' },
    }),

    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
}

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" };
    };
})
