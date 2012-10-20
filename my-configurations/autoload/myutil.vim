"
"Shamelessly copied from the VimClojure util scripts
function! myutil#SynIdName()
	return synIDattr(synID(line("."), col("."), 0), "name")
endfunction
