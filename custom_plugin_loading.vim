let s:vimPlugDir = fnamemodify(expand('<sfile>:p:h') . '/../vim-plug/', ':p')
if -1 == index(split(&runtimepath, ','), s:vimPlugDir)
    let &runtimepath .= ',' . s:vimPlugDir
    runtime plug.vim
endif
let s:pluginsFile = expand('<sfile>:p:h') . '/plugins.vim'
let s:pluginOverrideFile = expand('<sfile>:p:h') . '/../override-plugins.txt'
function! ReloadPluginDefinition()
    call plug#begin('~/.vim/plugins')
    execute 'source ' . s:pluginsFile
    if filereadable(s:pluginOverrideFile)
        for l:override in readfile(s:pluginOverrideFile)
            if l:override =~ '^\s*#'
                continue
            endif
            let l:overrideDir = fnamemodify(l:override, ':p')
            let l:pluginName = fnamemodify(l:overrideDir, ':h:t')
            let g:plugs[l:pluginName] = {'dir': l:overrideDir}
        endfor
    endif
    call plug#end()
endfunction
call ReloadPluginDefinition()
