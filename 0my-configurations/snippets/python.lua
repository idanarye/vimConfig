return {
    s({
        trig = 'ipy',
        name = 'Insert IPython.embed()',
    }, t({
        '__import__("IPython").embed()',
    })),
}
