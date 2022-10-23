local whitespace = require'whitespace-nvim'

whitespace.setup {
    highlight = 'Error';
    ignored_filetypes = { 'TelescopePrompt' };
}

whitespace.highlight()

vim.cmd([[
command! EraseBadWhitespace lua require'whitespace-nvim'.trim()
]])
