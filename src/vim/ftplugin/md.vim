"--------------------------------------------------------------------------
"
"         FILE:  .vim/ftplugin/md.vim
"
"  DESCRIPTION:  Some helpfull settings when writing markdown
"
"--------------------------------------------------------------------------


if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal textwidth=68
setlocal syntax=markdown
"setlocal spell spelllang=en_us

"--------------------------------------------------------------------------
" END
"--------------------------------------------------------------------------
