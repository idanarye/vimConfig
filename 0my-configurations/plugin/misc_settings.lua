local lspkind = require('lspkind')
local lspkindInitFunction = lspkind.init or lspkind.setup
lspkindInitFunction {
}

vim.opt.spelloptions:append('camel')
