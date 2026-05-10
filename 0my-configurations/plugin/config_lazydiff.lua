local lazydiff = require'lazydiff'

lazydiff.setup {
}

require'idan.impairative-toggling':manual {
    key = 'D',
    name = 'LazyDiff',
    toggle = lazydiff.toggle,
    enable = lazydiff.enable,
    disable = lazydiff.disable,
}
