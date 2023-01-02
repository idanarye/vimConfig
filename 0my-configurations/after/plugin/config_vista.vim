let g:vista_ctags_renderer = 'default'
let g:vista_stay_on_open = 0
let g:vista_fzf_preview = ['right:50%']
let g:vista_close_on_fzf_select = 1

function! s:initVistaIfNeeded() abort
    if !exists('t:vista')
        call vista#init#Api()
    endif
endfunction

autocmd TabNew * ++once call s:initVistaIfNeeded()
call s:initVistaIfNeeded()
