return {
    s({
        trig = 'f)',
        name = 'Insert anonymous function last argument',
    }, {
        t {'function('}, i(2), t(')'),
        t {'', '    '}, i(1),
        t {'', 'end)'},
    }),
    s({
        trig = 'f,',
        name = 'Insert anonymous function non-last argument',
    }, {
        t {'function('}, i(2), t(')'),
        t {'', '    '}, i(1),
        t {'', 'end,'},
    }),
}
