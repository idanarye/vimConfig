let s:vimPlugDir = fnamemodify(expand('<sfile>:p:h') . '/../vim-plug/', ':p')
if -1 == index(split(&runtimepath, ','), s:vimPlugDir)
    let &runtimepath .= ',' . s:vimPlugDir
    runtime plug.vim
endif

let s:pluginsFile = expand('<sfile>:p:h') . '/plugins.vim'
let s:pluginOverrideFile = expand('<sfile>:p:h') . '/../override-plugins.txt'

function! s:getThisDirPluginName() abort
    try
        let l:gitConfig = readfile('.git/config')
    catch
        return v:null
    endtry
    for l:line in l:gitConfig
        let l:m = matchlist(l:line, '\V\^\s\*url = git@github.com:idanarye/\(\.\+\).git\$')
        if !empty(l:m)
            return l:m[1]
        endif
    endfor
    return v:null
endfunction

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

    let l:thisDirPluginName = s:getThisDirPluginName()
    if has_key(g:plugs, l:thisDirPluginName)
        let g:plugs[l:thisDirPluginName] = {'dir': getcwd()}
    endif

    call plug#end()
endfunction

call ReloadPluginDefinition()
