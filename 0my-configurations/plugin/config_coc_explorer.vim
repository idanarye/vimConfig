function! s:runWithCwd(...) abort
    return ':CocCommand explorer ' . join(map(copy(a:000), 'fnameescape(v:val)'), ' ') . ' ' . fnameescape(getcwd()) . "\<Cr>"
endfunction

noremap <expr> <Leader><Tab> <SID>runWithCwd('--toggle')
noremap <expr> <Leader>d <SID>runWithCwd('--position=floating', '--open-action-strategy=sourceWindow')

function! s:runWithReveal(...) abort
    autocmd BufEnter \[coc-explorer\]* ++once normal gS
    " return ':CocCommand explorer ' . join(map(copy(a:000), 'fnameescape(v:val)'), ' ') . "\<Cr>"
    return call('s:runWithCwd', a:000)
endfunction

noremap <expr> <Leader><Leader><Tab> <SID>runWithReveal('--no-toggle')
