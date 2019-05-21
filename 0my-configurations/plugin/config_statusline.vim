function! StatusLine(current)
    return (a:current ? crystalline#mode() . '%#Crystalline#' : '%#CrystallineInactive#')
                \ . ' %f%h%w%m%r '
                \ . (a:current ? '%#CrystallineFill# %{fugitive#head()} ' : '')
                \ . '%=' . (a:current ? '%#Crystalline# %{&paste?"PASTE ":""}%{&spell?"SPELL ":""}' . crystalline#mode_color() : '')
                \ . ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
endfunction
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'jellybeans'
set laststatus=2
