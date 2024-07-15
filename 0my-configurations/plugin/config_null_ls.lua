local null_ls = require('null-ls')

null_ls.setup {
    sources = {
        require'buffls',
        null_ls.builtins.formatting.stylua,
    };
}
