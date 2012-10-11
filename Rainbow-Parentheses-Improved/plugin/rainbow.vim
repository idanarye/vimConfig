"==========================================================
"Script Title: rainbow parentheses improved
"Script Version: 2.3
"Author: luochen1990
"Last Edited: 2012 Sep 9
"Simple Configuration:
"First, put "rainbow.vim" to dir vim73/plugin or vimfiles/plugin
"Second, add the follow sentence to your .vimrc or _vimrc :
"		autocmd syntax * call rainbow#activate()
"Third, restart your vim and enjoy coding.
"Advanced Configuration:
"* use rainbow#load(...) to load your setting :
"		e.g. you can add the sentence below to your vimrc :
"			au syntax * cal rainbow#load([['(',')'],['\[','\]'],['{','}'],['begin','end']])
"* you can also change the colors by editting the value of s:guifgs or s:ctermfgs.
"* use command :RainbowToggle to toggle this plugin.
"* if you want to make your vimrc portable (usable without this plugin),
"  you can define some global variables instead of add autocmd commands :
"		e.g. you can add the sentences below to your vimrc :
"			let g:rainbow_active = 1
"			let g:rainbow_loaded = [['(',')'],['\[','\]'],['{','}'],['begin','end']]
"			let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3']



let s:guifgs = exists('g:rainbow_guifgs')? g:rainbow_guifgs : [
			\ 'DarkOrchid3', 'RoyalBlue3', 'SeaGreen3',
			\ 'DarkOrange3', 'FireBrick', 
			\ ]

let s:ctermfgs = exists('g:rainbow_ctermfgs')? g:rainbow_ctermfgs : [
			\ 'darkgray', 'Darkblue', 'darkmagenta', 
			\ 'darkcyan', 'darkred', 'darkgreen',
			\ ]

let s:max = has('gui_running')? len(s:guifgs) : len(s:ctermfgs)

func rainbow#load(...)
	if exists('b:loaded')
		cal rainbow#clear()
	endif
	let b:loaded = (a:0 < 1) ? [['(',')'],['\[','\]'],['{','}']] : a:1
	let cmd = 'syn region %s matchgroup=%s start=/%s/ end=/%s/ containedin=%s contains=%s'
	let str = 'TOP'
	for each in range(1, s:max)
		let str .= ',lv'.each
	endfor
	for [left , right] in b:loaded
		for each in range(1, s:max - 1)
			exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1) , str)
		endfor
		exe printf(cmd, 'lv'.s:max, 'lv'.s:max.'c', left, right, 'lv1' , str)
	endfor
	if (match(a:000 , 'later') == -1)
		cal rainbow#activate()
	endif
endfunc

func rainbow#clear()
	unlet b:loaded
	for each in range(1 , s:max)
		exe 'syn clear lv'.each
	endfor
endfunc

func rainbow#activate()
	if !exists('b:loaded')
		cal rainbow#load()
	endif
	for id in range(1 , s:max)
		let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
		let guifg = s:guifgs[(s:max - id) % len(s:guifgs)]
		exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
	endfor
	let b:active = 'active'
endfunc

func rainbow#inactivate()
	if exists('b:active')
		for each in range(1, s:max)
			exe 'hi clear lv'.each.'c'
		endfor
		unlet b:active
	endif
endfunc

func rainbow#toggle()
	if exists('b:active')
		cal rainbow#inactivate()
	else
		cal rainbow#activate()
	endif
endfunc

if exists('g:rainbow_loaded')
	autocmd syntax * call rainbow#load(g:rainbow_loaded)
elseif exists('g:rainbow_active')
	autocmd syntax * call rainbow#activate()
endif

command! RainbowToggle call rainbow#toggle()

