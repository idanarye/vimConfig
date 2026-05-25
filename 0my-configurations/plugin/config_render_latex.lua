render_latex = require'render_latex'

render_latex.setup {
}

vim.opt.concealcursor = 'nc'

require'idan.impairative-toggling':manual {
    key = 'm',
    name = 'Render Latex',
    enable = render_latex.enable,
    disable = render_latex.disable,
    toggle = render_latex.toggle,
}
