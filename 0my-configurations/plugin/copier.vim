if !exists('g:copierTemplatesForUpdatingProjects')
    finish
endif

function! s:chooseTemplate() abort
    call fzf#run(fzf#wrap({
                \ 'source': 'ls '. shellescape(g:copierTemplatesForUpdatingProjects),
                \ 'sink': function('s:applyTemplate'),
                \ }, 0))
endfunction

command! Copier call s:chooseTemplate()

function! s:applyTemplate(template) abort
    let l:srcPath = g:copierTemplatesForUpdatingProjects . '/' . a:template

    botright new
    call termopen(['copier', l:srcPath, '.'])
    call feedkeys('a', 'n')
endfunction
