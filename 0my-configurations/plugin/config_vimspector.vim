finish
nnoremap <silent> <M-d>l :<c-u>call vimspector#Launch()<Cr>
nmap <M-d>c <Plug>VimspectorContinue
nmap <M-d>k <Plug>VimspectorStop
nmap <M-d>r <Plug>VimspectorRestart
nnoremap <silent> <M-d>R :<c-u>call vimspector#Reset()<Cr>
nmap <M-d>p <Plug>VimspectorPause
nmap <M-d>b <Plug>VimspectorToggleBreakpoint
nmap <M-d><C-b> <Plug>VimspectorToggleConditionalBreakpoint
nnoremap <silent> <M-d>B :<c-u>call vimspector#ClearBreakpoints()<Cr>
nmap <M-d>o <Plug>VimspectorStepOver
nmap <M-d>i <Plug>VimspectorStepInto
nmap <M-d>O <Plug>VimspectorStepOut

nnoremap <M-d>L :call <SID>vimspectorLaunchFzf()<Cr>'
function! s:vimspectorLaunchFzf() abort
    messages clear
    let l:config = json_decode(readfile('.vimspector.json'))
    call fzf#run({
                \ 'source': keys(l:config.configurations),
                \ 'sink': function('<SID>vimspectorLaunchFzfSink'),
                \ })
endfunction

function! s:vimspectorLaunchFzfSink(configuration)
    call vimspector#LaunchWithSettings({'configuration': a:configuration})
endfunction
