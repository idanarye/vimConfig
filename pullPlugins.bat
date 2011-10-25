@ECHO OFF

CALL gitPullPlugin.bat git://github.com/vim-scripts dbext.vim
CALL gitPullPlugin.bat git://github.com/tpope vim-fugitive
CALL gitPullPlugin.bat git://repo.or.cz vcscommand .git
CALL gitPullPlugin.bat git://github.com/gabemc powershell-vim
