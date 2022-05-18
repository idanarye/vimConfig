let s:vimPlugDir = fnamemodify(expand('<sfile>:p:h') . '/../vim-plug/', ':p')
if -1 == index(split(&runtimepath, ','), s:vimPlugDir)
    let &runtimepath .= ',' . s:vimPlugDir
    runtime plug.vim
endif

let s:pluginsFile = expand('<sfile>:p:h') . '/plugins.vim'

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

function! s:applyPluginOverride(pluginOverrideFile) abort
    if filereadable(a:pluginOverrideFile)
        for l:override in readfile(a:pluginOverrideFile)
            if l:override =~ '^\s*#'
                continue
            endif
            let l:overrideDir = fnamemodify(l:override, ':p')
            let l:pluginName = fnamemodify(l:overrideDir, ':h:t')
            let g:plugs[l:pluginName] = {'dir': l:overrideDir}
        endfor
    endif
endfunction

let s:globalPluginOverrideFilePath = expand('<sfile>:p:h') . '/../override-plugins.txt'

function! ReloadPluginDefinition()
    call plug#begin()
    execute 'source ' . s:pluginsFile

    call s:applyPluginOverride(s:globalPluginOverrideFilePath)
    call s:applyPluginOverride('override-plugins.txt')

    let l:thisDirPluginName = s:getThisDirPluginName()
    if has_key(g:plugs, l:thisDirPluginName)
        let g:plugs[l:thisDirPluginName] = {'dir': getcwd()}
    endif

    call plug#end()
endfunction

call ReloadPluginDefinition()
