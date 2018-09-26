if exists('g:query_map')
	call extend(g:query_map, {
				\ 'rust': 'https://doc.rust-lang.org/std/?search={query}',
				\ 'amethyst': 'https://www.amethyst.rs/doc/latest/doc/amethyst/?search={query}'
				\ })
endif
