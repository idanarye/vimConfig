local treepin = require'treepin'

treepin.setup {
}

require'caskey'.setup {
    mode = {'n'},
    name = 'TreePin',
    ['<Leader><C-p>'] = {
        ['p'] = { act = treepin.pinLocal, desc='Sets the window\'s pin at the treesitter node under the cursor' },
        ['r'] = { act = treepin.pinRoot, desc='Sets the window\'s pin at the second largest treesitter node under the cursor (the largest is the file itself)' },
        ['g'] = { act = treepin.pinGrow, desc='Expands the pin to the next parent treesitter node that sits on a different line' },
        ['s'] = { act = treepin.pinShrink, desc='Reverses the effect of growing the pin. Cannot be shrunk smaller than the node under the cursor when the pin was created' },
        ['c'] = { act = treepin.pinClear, desc='Removes the pin buffer and the pin itself' },
        ['G'] = { act = treepin.pinGo, desc='Jump to the first line of the pin' },
        ['S'] = { act = treepin.pinShow, desc='Called automatically when a pin is created. Enables displaying the pin buffer' },
        ['h'] = { act = treepin.pinHide, desc='Hides the pin buffer but keeps the pin stored' },
        ['t'] = { act = treepin.pinToggle, desc='Either runs pinHide or pinShow depending on whether the pin is visible' },
    },
}
