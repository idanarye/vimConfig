let vimclojure#UseErrorBuffer=0
"let g:vimclojure#ParenRainbow=1

command! VimClojureWantNailgun let vimclojure#WantNailgun=1
command! -bang -nargs=1 ClojureEval call myclojure#evalCommand(<q-args>,<bang>0)
command! -complete=file -nargs=1 ClojureRun call myclojure#runFile(<q-args>)

nnoremap <buffer> <F8> <Esc>:ClojureRun run.clj<Cr>
