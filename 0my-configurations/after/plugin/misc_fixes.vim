if !empty(maparg('cic', 'v'))
	vunmap cic
endif

" neovim-qt configs
if exists(':GuiTabline')
    GuiTabline 0
endif
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif
if exists(':FontSize')
    FontSize 14
endif
