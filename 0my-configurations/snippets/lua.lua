return {
    s({
        trig = 'f)',
        name = 'Insert anonymous function last argument',
    }, {
        t {'function('}, i(1), t(')'),
        t {'', '    '}, i(2),
        t {'', 'end)'}, i(3),
    }),
    s({
        trig = 'f,',
        name = 'Insert anonymous function non-last argument',
    }, {
        t {'function('}, i(1), t(')'),
        t {'', '    '}, i(2),
        t {'', 'end,'}, i(3),
    }),
}
