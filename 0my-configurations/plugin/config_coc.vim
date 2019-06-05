function! s:installMissingExtensions(_, extensions) abort
    let l:installed = {}
    for l:ext in a:extensions
        let l:installed[l:ext.id] = v:true
    endfor
    " let l:required = map(copy(a:extensions), 'v:val.id')
    let l:missing = []
    for l:ext in g:my_coc_extensions
        if !has_key(l:installed, l:ext)
            call add(l:missing, l:ext)
        endif
    endfor
    call coc#util#install_extension(l:missing)
    CocUpdate
endfunction

command! UpdateCocExtensions call CocActionAsync('extensionStats', function('s:installMissingExtensions'))
