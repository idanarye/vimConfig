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
