noremap <Leader><Tab> :CocCommand explorer --toggle<Cr>
noremap <Leader>d :CocCommand explorer --position=floating --open-action-strategy=sourceWindow<Cr>

function! s:runWithReveal(...) abort
    autocmd BufEnter \[coc-explorer\]* ++once normal gS
    return ':CocCommand explorer ' . join(map(copy(a:000), 'fnameescape(v:val)'), ' ') . "\<Cr>"
endfunction

noremap <expr> <Leader><Leader><Tab> <SID>runWithReveal('--no-toggle')
