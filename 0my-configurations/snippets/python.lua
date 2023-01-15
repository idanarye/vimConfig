return {
    s({
        trig = 'ipy',
        name = 'Insert IPython.embed()',
    }, t({
        'import IPython',
        'IPython.embed()',
    })),
}
