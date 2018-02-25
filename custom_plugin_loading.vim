runtime plug.vim
let s:pluginsFile = expand('<sfile>:p:h') . '/plugins.vim'
function! ReloadPluginDefinition()
    call plug#begin('~/.vim/plugins')
    execute 'source ' . s:pluginsFile
    call plug#end()
endfunction
call ReloadPluginDefinition()
