imap <expr> <C-l>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-l>'

imap <expr> <C-j>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
smap <expr> <C-j>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'

if !exists('g:vsnip_filetypes')
    let g:vsnip_filetypes = {}
endif

if !exists('g:vsnip_snippet_dirs')
    let g:vsnip_snippet_dirs = []
endif
call add(g:vsnip_snippet_dirs, expand('<sfile>:p:h:h') . '/snippets')
