nnoremap <buffer> <LocalLeader>f :call myutil#runRangeCommandOnEntireBufferAndRestoreCurosr("call mypy#runFlake8('')")<Cr>
vnoremap <buffer> <LocalLeader>f :call mypy#runFlake8('')<Cr>
setlocal formatexpr=mypy#runAutopep8()
