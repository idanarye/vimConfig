if exists(":CompilerSet") != 2 " older Vim always used :setlocal
	command -nargs=* CompilerSet setlocal <args>
endif

function! FindProjectRoot(lookFor)
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            return expand(pathMaker)
        endif
    endwhile
    return 0
endfunction

let projectRoot=FindProjectRoot('rakefile')
if type(projectRoot)==0
	finish
endif

if stridx(&tags,projectRoot."/tags")<0
	let &tags=&tags.",".projectRoot."/tags"
endif

let s:rakeHeader=readfile(projectRoot."/rakefile",'',1)[0]
if s:rakeHeader=='#java'
	so ~/.vim/bundle/compiler/java.vim
else
	so ~/.vim/bundle/compiler/core_rake.vim
endif
