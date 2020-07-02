let $FZF_DEFAULT_COMMAND = 'rg --files'
let g:fzf_command_prefix = 'Fzf'

source /usr/share/vim/vimfiles/plugin/fzf.vim
" function! fzf#run(...) abort
    " return call(function('skim#run'), a:000)
" endfunction

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=never '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function FzfRgRegex(withPreview) abort
    let l:options = {'options': [
          \ '--phony',
          \ '--bind', 'change:reload:rg --column --line-number --no-heading --color=never {q}',
          \ '--prompt', 'rg> '
          \ ]}

    if a:withPreview
        let l:spec = fzf#vim#with_preview(l:options, 'up:60%')
    else
        let l:spec = fzf#vim#with_preview(l:options, 'right:50%:hidden', '?')
    endif
    call fzf#vim#grep('echo', 1, l:spec, a:withPreview)
endfunction
