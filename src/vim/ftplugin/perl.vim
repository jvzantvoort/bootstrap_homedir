"--------------------------------------------------------------------------
"
"         FILE:  .vim/ftplugin/perl.vim
"
"  DESCRIPTION:  Settings for editing perl scripts and modules
"
"      CREATED:  Mon, 30 Dec 2013
"
"--------------------------------------------------------------------------

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal shiftwidth=4
setlocal autoindent
setlocal expandtab
setlocal smarttab
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal tabstop=4

" keybindings for perl
"--------------------------------------------------------------------------
map <C-N> <Esc>:!/usr/bin/perl -c %<cr>

"--------------------------------------------------------------------------
" End
"--------------------------------------------------------------------------
